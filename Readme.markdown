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
Clone this repo into your configuration directory

    $ git clone git://github.com/Mic92/utils.git $XDG_CONFIG_HOME/awesome/utils

Require it in your configuration.

```lua
require("utils")
-- optional part to make usage more convenient
local cal = utils.cal
local markup = utils.markup
local iwlist = utils.iwlist
local wimpd  = utils.wimpd
```

Every module has a short example usage in the header.
