require("utf8")
local math = require "math"
local data = require "data"
local utils = require "utils"
local clearScreen, setColor, getTerminalSize , days_ago= utils.clearScreen, utils.setColor, utils.getTerminalSize, utils.days_ago
local ui = {}

function drawTable(title, items, selectedIndex, isSelected, color, height, width)
    local lines = {}
    
    table.insert(lines, "\u{250C}" .. string.rep("\u{2500}", width - 2) .. "\u{2510}")
    table.insert(lines, "\u{2502}" .. string.format("%-" .. (width - 2) .. "s", " " .. title) .. "\u{2502}")
    table.insert(lines, "\u{251C}" .. string.rep("\u{2500}", width - 2) .. "\u{2524}")
    
    local contentHeight = height - 5  -- Subtract header, footer, and margins
    
    for i = 1, contentHeight do
        local line = "\u{2502}"
        if i <= #items then
            if isSelected and i == selectedIndex then
                line = line .. "> "
            else
                line = line .. "  "
            end
            line = line .. string.format(
                "%-" .. (width - 4) .. "s", (days_ago(items[i].created_at) .. ' ' .. items[i].name):sub(1, width - 4)
            )
        else
            line = line .. string.rep(" ", width - 2)
        end
        line = line .. "\u{2502}"
        table.insert(lines, line)
    end
    
    table.insert(lines, "\u{2514}" .. string.rep("\u{2500}", width - 2) .. "\u{2518}")
    return lines
end

function printTodoList(todos, active, completed, selectedIndex, selectedColumn) 
    clearScreen()
    local rows, columns = getTerminalSize()
    local tableHeight = rows - 3  -- Subtract space for header and footer
    local tableWidth = math.floor(columns / 3)
    
    print("Todo List (arrows:navigate, space:complete, Ctrl+T:new, Ctrl+S:save, q:quit):")
    print()
    
    local todosTable = drawTable("ToDoS", todos, selectedIndex, selectedColumn == 1, "yellow", tableHeight, tableWidth)
    local activeTable = drawTable("Active Tasks", active, selectedIndex, selectedColumn == 2, "blue", tableHeight, tableWidth)
    local completedTable = drawTable("Completed Tasks", completed, selectedIndex, selectedColumn == 3, "green", tableHeight, tableWidth)
    
    for i = 1, #activeTable do
        setColor("yellow")
        io.write(todosTable[i])
        setColor("blue")
        io.write(activeTable[i])
        setColor("green")
        io.write(completedTable[i])
        setColor("reset")
        io.write("\n")
    end
end

function createNewTask() 
    clearScreen()
    setColor("yellow")
    print("Create New Task")
    print("--------------")
    setColor("reset")
    io.write("Enter task description (press Enter to submit): ")
    os.execute("stty sane")  -- Restore normal terminal behavior for input
    local newTask = io.read()
    os.execute("stty raw -echo")  -- Restore raw mode
    
    return {
        name = newTask, 
        created_at = os.date()
    }
end

ui.drawTable = drawTable
ui.printTodoList = printTodoList
ui.createNewTask = createNewTask
return ui
