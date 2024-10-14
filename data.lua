require("utf8")
local json = require("dkjson")
local data = {}

function data.saveTasks(todos, active, completed) 
    local data = {
        todos = todos,
        active = active,
        completed = completed
    }
    local jsonString = json.encode(data, { indent = true })
    local file = io.open("todo_list.json", "w")
    if file then
        file:write(jsonString)
        file:close()
        return true
    else
        return false
    end
end

function data.loadTasks() 
    local file = io.open("todo_list.json", "r")
    if file then
        local content = file:read("*all")
        file:close()
        local data = json.decode(content)
        return data.todos or {}, data.active or {}, data.completed or {}
    else
        return {}, {}, {}
    end
end

return data
