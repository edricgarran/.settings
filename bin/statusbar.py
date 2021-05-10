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
        "separator": False,
        "full_text": text,
        **kwargs,
    }


def wid_value(text, **kwargs):
    return {
        "separator": False,
        "full_text": text,
        "background": "#202020",
        "border": "#303030",
        **kwargs,
    }


def vertical_percent(value, bars=" ▁▂▃▄▅▆▇█"):
    return bars[int(value / 100.0 * (len(bars) - 1))]


def clock(out, id):
    while True:
        text = format(datetime.datetime.now(), "%d/%m/%Y %H:%M")
        out.put((id, [wid_label(text, name="clock")]))
        time.sleep(1)


def cpu(out, id):
    while True:
        cpus = psutil.cpu_percent(interval=0.1, percpu=True)
        cpus = (vertical_percent(cpu) for cpu in sorted(cpus))
        out.put((id, [wid_label("".join(cpus))]))


def memory(out, id):
    while True:
        vm = psutil.virtual_memory()
        out.put(
            (
                id,
                [
                    wid_label("MEM"),
                    wid_value(
                        f"{vm.percent:0.0f}%",
                        min_width="100%",
                        align="center",
                    ),
                ],
            )
        )
        time.sleep(1)


def battery(out, id):
    while True:
        bat = psutil.sensors_battery()
        if bat is None:
            return
        plug_indicator = "+" if bat.power_plugged else "-"
        out.put(
            (
                id,
                [
                    wid_label("BAT"),
                    wid_value(
                        f"{bat.percent:0.0f}%{plug_indicator}",
                        min_width="100%",
                        align="center",
                    ),
                ],
            )
        )
        time.sleep(1)


def volume(out, id):
    with pulsectl.Pulse("statusbar") as pulse:
        pulse.connect()
        while True:
            widgets = []
            for sink in pulse.sink_list():
                if sink.mute:
                    value = "MUTE"
                else:
                    value = f"{sink.volume.value_flat * 100:0.0f}%"
                widgets.append(
                    wid_label("VOL", name="volume", instance=sink.name),
                )
                widgets.append(
                    wid_value(
                        value,
                        name="volume",
                        instance=sink.name,
                        min_width="100%",
                        align="center",
                    ),
                )
            out.put((id, widgets))
            time.sleep(0.1)


def volume_handle(event):
    if event["button"] == 1:
        with pulsectl.Pulse("statusbar") as pulse:
            sink = pulse.get_sink_by_name(event["instance"])
            pulse.mute(sink, not sink.mute)
    if event["button"] == 4:
        with pulsectl.Pulse("statusbar") as pulse:
            sink = pulse.get_sink_by_name(event["instance"])
            pulse.volume_change_all_chans(sink, 0.05)
    if event["button"] == 5:
        with pulsectl.Pulse("statusbar") as pulse:
            sink = pulse.get_sink_by_name(event["instance"])
            pulse.volume_change_all_chans(sink, -0.05)


class Manager:
    def __init__(self):
        self.state = []
        self.outputs = Queue()
        self.event_handlers = {}

    def spawn(self, block):
        id = len(self.state)
        self.state.append([])
        Thread(target=block, args=(self.outputs, id), daemon=True).start()

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
                except Exception as e:
                    notify(str(e), "Error")

        Thread(target=run_input, daemon=True).start()

    def run(self):
        notify2.init("statusbar")
        json.dump({"version": 1, "click_events": True}, sys.stdout)
        sys.stdout.write("\n[\n")
        while True:
            id, widgets = self.outputs.get()
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
    manager.on_event("volume", volume_handle)
    manager.spawn(volume)

    manager.spawn(clock)

    manager.spawn_input()
    manager.run()


if __name__ == "__main__":
    main()
