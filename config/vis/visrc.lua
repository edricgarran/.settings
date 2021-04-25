require('vis')

-- Load plugins
require('plugins/vis-commentary')
require('plugins/vis-pairs')
require('plugins/vis-surround')

vis.events.subscribe(vis.events.INIT, function()
    vis:command('set theme custom')
    vis:command('set tabwidth 4')
    vis:command('set autoindent')
    vis:command('set expandtab')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
    vis:command('set number')
    vis:command('set cursorline')
end)
