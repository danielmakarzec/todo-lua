require("utf8")
local date = require "date"
local utils = {}

function utils.getChar()
    os.execute("stty raw -echo")
    local char = io.read(1)
    os.execute("stty sane")
    return char
end

function utils.clearScreen()
    io.write("\27[2J\27[H")
end

function utils.setColor(color)
    local colors = {
        red = "\27[31m",
        green = "\27[32m",
        blue = "\27[34m",
        yellow = "\27[33m",
        reset = "\27[0m",
        magenta = "\27[36m"
    }
    io.write(colors[color] or colors.reset)
end

function utils.getTerminalSize()
    local handle = io.popen("stty size")
    local result = handle:read("*a")
    handle:close()
    local rows, cols = result:match("(%d+) (%d+)")
    return tonumber(rows), tonumber(cols)
end

function utils.days_ago(d)
    print(d)
    d = date.diff(os.date(), d)
    days = math.floor(d:spandays())
    if days == 0 then
        return "( new )"
    else
       return string.format("(" .. days .. " ago)")
    end
end

return utils
