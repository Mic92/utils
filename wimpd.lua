local timer = timer
local naughty_notify = require("naughty").notify
--local escape = awful.util.escape
local mpd = require("utils.mpd")
local utf8 = require("utils.utf8")
-- TODO import mpd:send as mpc:rawsend
local pairs = pairs
local setmetatable = setmetatable
local tonumber = tonumber
local os = os
local string = string
local print = print

ESCAPE_SYMBOL_MAPPING = {}
ESCAPE_SYMBOL_MAPPING["&"] = "&amp;"

-- wimpd - a wrapper and widget for mpd.lua
-- usage:
--  require("wimpd")
--  local conf = {}
--  local mpc = wimpd.new(conf)
--module("utils.wimpd")
local wimpd = { _NAME = "wimpd" }

-- {{{ Utils
local function trim(text, maxlen)
  if not text then return "NA"
  elseif maxlen and utf8.len(text) > maxlen then
    text = utf8.sub(text, 1, maxlen - 3).."..."
  end
  --return escape(text)
  return utf8.replace(text, ESCAPE_SYMBOL_MAPPING)
end

local function timeformat(t)
  t = tonumber(t)
  if t >= 3600 then -- more than one hour!
    return os.date("%X", t-3600)
  else
    return os.date("%M:%S", t)
  end
end

local function basename(s)
  if s == nil then return "" end
  -- Remove all slashes, if any.
  local basename = s:match(".*/([^/]*)") or s
  -- Remove file extension too.
  -- Hint: MPD ignores files without a supported file extension.
  -- Basename regex is derived from luarocks
  return basename:match("(.*)%.[^.]+")
end

local function notify(song)
  local t
  if song.isradio then
    t = "<b>Radio:</b> "..trim(song.name, 25)
  else
    t = string.format("%s %s\n%s %s\n%s %s",
    "<b>Artist:</b>", trim(song.artist),
    "<b>Album:</b>",  trim(song.album),
    "<b>Title:</b>",  trim(song.title or
    basename(song.file, 25)))
  end
  naughty_notify ({
    icon    = "/usr/share/pixmaps/sonata.png",
    icon_size = 45,
    opacity = 0.9,
    timeout = 3,
    text    = t,
    margin  = 10, })
  end
  -- }}}

function wimpd.new(conf)
  local mpc = mpd.new(conf)
  local widget_timer = timer { timeout = 3}
  -- so we get a hirachy like this
  -- client object -> mpc -> mpd (good idea?)

  function mpc.attach(widget)
    widget_timer:connect_signal("timeout",  function()
      widget:set_markup(mpc.get_stat() or "")
    end)
    widget_timer:start()
  end

  function mpc.update(widget)
    widget_timer:emit_signal("timeout")
  end

  function mpc.detach(widget)
    widget_timer:disconnect_signal("timeout")
    widget_timer:stop()
  end

  function mpc.get_stat()
    --local events = self:idle()

    --if events.erormsg then
    --  return "MPD Problem: "..events.errormsg
    --elseif events.player or events.playlist then
    -- local status = self:send("status")
    local status = mpc:send("status")

    if status.errormsg ~= nil then
      return "MPD Problem: "..status.errormsg
    else
      if status.state == "stop" then return end

      -- Fetch infos about current songs
      local current = mpc:send("currentsong")
      local now_playing

      current.isradio = (current.name ~= nil)

      -- Additional information depending on mode
      if current.isradio then
        local station = trim(current.name, 20)
        -- Radio stations often put the name of artist and song
        -- in the title, so it gets longer as usual.
        local title   = trim(current.title, 35)

        now_playing = string.format("%s: %s", station, title)
      else
        local artist = trim(current.artist, 20)
        local title  = trim(current.title or
        basename(current.file), 25)
        local total_time   = timeformat(status.time:match(":(%d+)"))
        local current_time = timeformat(status.time:match("(%d+):"))

        now_playing = string.format("%s: %s | %s/%s", artist, title, current_time, total_time)

      end

      -- Title has changed?
      if mpc.last_songid ~= status.songid and mpc.last_songid then
        notify(current)
      end

      mpc.last_songid = status.songid

      if status.state == "pause" then
        -- Use inconspicuous color to push it to the background
        -- depend on the theme.
        s = "<span color='#505050'>"..now_playing.."</span>"
        return s
      else
        return now_playing
      end
    end
  end

  return mpc
end

return wimpd
