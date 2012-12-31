awesome utils
=============

Some modules I use in awesome wm,
which aren't big enough to setup a github repo for each:

* cal - a popup calendar

* markup - a wrapper around pango markup

* wimpd - a mpd widget based on mpd.lua

* iwlist - a wrapper around iwlist accesspoint scan

Documentation
-------------
All modules at least require awesome 4.5.
If your using awesome 4.4 or earlier,
checkout 7c97544335ee4b1f38084c97504e00849e0f4fa6

Clone this repo into your configuration directory

    $ git clone git://github.com/Mic92/utils.git $XDG_CONFIG_HOME/awesome/utils

Require it in your configuration.

```lua
-- each module is independent
local cal = require("utils.cal")
local markup = require("utils.markup")
local iwlist = require("utils.iwlist")
local wimpd  = require("utils.wimpd")
```

Every module has a short example usage in the header.
