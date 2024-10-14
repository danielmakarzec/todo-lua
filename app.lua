-- utf8 = utf8 or require("utf8")

local function testUnicode()
    print("Unicode test:")
    print("Box drawing characters:")
    print("┌─┐")
    print("│ │")
    print("└─┘")
    print("Unicode string length test:")
    local str = "Hello, 世界"
    print("String:", str)
    print("Byte length:", #str)
    print("UTF-8 length:", utf8.len(str))
    print("First character:", utf8.char(utf8.codepoint(str, 1, 1)))
    io.write("Press Enter to continue...")
    io.read()
end
-- testUnicode()
local data = require "data"
local ui = require "ui"
local utils = require "utils"
local saveTasks, loadTasks = data.saveTasks, data.loadTasks
local drawTable, printTodoList, createNewTask = ui.drawTable, ui.printTodoList, ui.createNewTask
local getChar, clearScreen, setColor, days_ago = utils.getChar, utils.clearScreen, utils.setColor, utils.days_ago

local todos, active, completed = loadTasks()
local dashboards = { todos, active, completed }

if #todos == 0 and #active == 0 and #completed == 0 then
    local task = {
        name = "TASK EXAMPLE", 
        created_at = os.date()
    }
    todos = { task }
end


local selectedIndex = 1
local selectedColumn = 1
while true do
    printTodoList(todos, active, completed, selectedIndex, selectedColumn)
    
    print("Lua version:", _VERSION)
    print("UTF-8 library available:", utf8 ~= nil)
    local char = getChar()
    
    if char == "q" then
        break
    elseif char == " " then
        -- Move task to the column on the right
        if selectedColumn == 1 and #todos > 0 then
            table.insert(active, table.remove(todos, selectedIndex))
            selectedColumn = selectedColumn + 1
            selectedIndex = #active
            -- if selectedIndex > #todos and selectedIndex > 1 then
                -- selectedIndex = selectedIndex - 1
            -- end
        elseif selectedColumn == 2 and #active > 0 then
            table.insert(completed, table.remove(active, selectedIndex))
            selectedColumn = selectedColumn + 1
            selectedIndex = #completed
            -- if selectedIndex > #active and selectedIndex > 1 then
            -- selectedIndex = selectedIndex - 1
            -- end
        end
    elseif char == "\92" then  -- ASCII code fro \
        -- Move task to the column on the left
        if selectedColumn == 3 and #completed > 0 then
            table.insert(active, table.remove(completed, selectedIndex))
            selectedColumn = selectedColumn - 1
            selectedIndex = #active
            -- if selectedIndex > #completed and selectedIndex > 1 then
            -- selectedIndex = selectedIndex - 1
            -- end
        elseif selectedColumn == 2 and #active > 0 then
            table.insert(todos, table.remove(active, selectedIndex))
            selectedColumn = selectedColumn - 1
            selectedIndex = #todos
            -- if selectedIndex > #completed and selectedIndex > 1 then
                -- selectedIndex = selectedIndex - 1
            -- end
        end
    elseif char == "\20" then  -- ASCII code for Ctrl+T
        local newTask = createNewTask()
        local newTaskName = newTask.name
        if newTask and newTask ~= "" then
            table.insert(todos, newTask)
            selectedIndex = #todos
            selectedColumn = 1
        end
    elseif char == "\19" then  -- ASCII code for Ctrl+S
        if saveTasks(todos, active, completed) then
            setColor("green")
            io.write("\nTasks saved successfully!")
            setColor("reset")
            io.write("\nPress any key to continue...")
            getChar()
        else
            setColor("red")
            io.write("\nFailed to save tasks.")
            setColor("reset")
            io.write("\nPress any key to continue...")
            getChar()
        end
    elseif char == "\27" then
        -- ESC sequence
        if getChar() == "[" then
            local arrow = getChar()
            if arrow == "A" and selectedIndex > 1 then
                -- Up arrow
                selectedIndex = selectedIndex - 1
            elseif arrow == "B" then
                -- Down arrow
                if (selectedColumn == 1 and selectedIndex < #todos) or
                   (selectedColumn == 2 and selectedIndex < #active) or
                   (selectedColumn == 3 and selectedIndex < #completed) then
                    selectedIndex = selectedIndex + 1
                end
            elseif arrow == "C" and selectedColumn < 3 then
                -- Right arrow
                selectedColumn = selectedColumn + 1
                selectedIndex = math.min(selectedIndex, math.max(1, #dashboards[selectedColumn]))
            elseif arrow == "D" and selectedColumn > 1 then
                -- Left arrow
                selectedColumn = selectedColumn - 1
                selectedIndex = math.min(selectedIndex, math.max(1, #dashboards[selectedColumn]))
            end
        end
    end
end 

saveTasks(todos, active, completed)  -- Auto-save on exit
clearScreen()
print("Goodbye!")
