import sys
import json
import time
import datetime
import itertools

from queue import Queue
from threading import Thread

import psutil
import notify2
import pulsectl


def notify(text, title=""):
    notify2.Notification(title, text).show()


def wid_label(text, **kwargs):
    return {
        "full_text": text,
        "separator": False,
        "color": "#c0c0c0",
        **kwargs,
    }


def visual_percent(value, bars=" ▁▂▃▄▅▆▇█"):
    return bars[int(value / 100.0 * (len(bars) - 1))]


def clock(out, id):
    while True:
        text = format(datetime.datetime.now(), "%d/%m/%Y %H:%M")
        out.put((id, [wid_label(text, name="clock")]))
        time.sleep(1)


def cpu(out, id):
    while True:
        cpus = psutil.cpu_percent(interval=0.5, percpu=True)
        cpus = (visual_percent(cpu) for cpu in sorted(cpus))
        out.put((id, [wid_label("".join(cpus))]))


def memory(out, id):
    while True:
        vm = psutil.virtual_memory()
        widgets = [
            wid_label(
                f" {vm.percent:0.0f}%",
                min_width="x 100%",
                align="left",
            )
        ]
        out.put((id, widgets))
        time.sleep(1)


def battery(out, id):
    while True:
        bat = psutil.sensors_battery()
        if bat is None:
            return

        plug_indicator = "" if bat.power_plugged else ""
        icon = visual_percent(bat.percent, "")
        out.put(
            (
                id,
                [
                    wid_label(
                        f"{plug_indicator}{icon} {bat.percent:0.0f}%",
                        min_width="xx 100%",
                        align="center",
                    ),
                ],
            )
        )
        time.sleep(60)


def volume(out, id):
    def update(pulse):
        widgets = []
        for sink in pulse.sink_list():
            volume = 100.0 * sink.volume.value_flat
            if sink.mute:
                widgets.append(
                    wid_label("", name="volume", instance=sink.name),
                )
            else:
                icon = visual_percent(volume, "")
                widgets.append(
                    wid_label(
                        f"{icon} {volume:0.0f}%",
                        name="volume",
                        instance=sink.name,
                        min_width="x 100%",
                        align="left",
                    ),
                )
        out.put((id, widgets))

    def on_event(event):
        with pulsectl.Pulse("statusbar-update") as pulse:
            update(pulse)

    with pulsectl.Pulse("statusbar") as pulse:
        update(pulse)
        pulse.event_mask_set("sink")
        pulse.event_callback_set(on_event)
        pulse.event_listen()


def volume_handle(event):
    if event["button"] == 1:
        with pulsectl.Pulse("statusbar-input") as pulse:
            sink = pulse.get_sink_by_name(event["instance"])
            pulse.mute(sink, not sink.mute)
    if event["button"] == 4:
        with pulsectl.Pulse("statusbar-input") as pulse:
            sink = pulse.get_sink_by_name(event["instance"])
            pulse.volume_change_all_chans(sink, 0.05)
            if sink.volume.value_flat > 1.0:
                pulse.volume_set_all_chans(sink, 1.0)
    if event["button"] == 5:
        with pulsectl.Pulse("statusbar-input") as pulse:
            sink = pulse.get_sink_by_name(event["instance"])
            pulse.volume_change_all_chans(sink, -0.05)


class Manager:
    def __init__(self):
        self.state = []
        self.outputs = Queue()
        self.event_handlers = {}

    def block_supervisor(self, block, id):
        while True:
            try:
                block(self.outputs, id)
            except Exception as e:
                notify("Error", str(e))
                self.outputs.put((id, ()))
                time.sleep(1)
            else:
                break

    def spawn(self, block):
        id = len(self.state)
        self.state.append([])
        Thread(
            target=self.block_supervisor,
            args=(block, id),
            daemon=True,
        ).start()

    def on_event(self, event, handler):
        self.event_handlers[event] = handler

    def spawn_input(self):
        def run_input():
            sys.stdin.readline()  # skip [
            notify2.init("statusbar")
            for line in sys.stdin:
                event = json.loads(line.lstrip(","))
                try:
                    handler = self.event_handlers[event["name"]]
                except KeyError:
                    continue
                try:
                    handler(event)
                except Exception:
                    continue

        Thread(target=run_input, daemon=True).start()

    def run(self):
        notify2.init("statusbar")
        json.dump({"version": 1, "click_events": True}, sys.stdout)
        sys.stdout.write("\n[\n")
        while True:
            id, widgets = self.outputs.get()
            if self.state[id] != widgets:
                self.state[id] = widgets
                json.dump(list(itertools.chain(*self.state)), sys.stdout)
                sys.stdout.write(",\n")
                sys.stdout.flush()


def main():
    manager = Manager()

    manager.spawn(cpu)
    manager.spawn(memory)
    manager.spawn(battery)

    manager.on_event("volume", volume_handle)
    manager.spawn(volume)

    manager.spawn(clock)

    manager.spawn_input()
    manager.run()


if __name__ == "__main__":
    main()
