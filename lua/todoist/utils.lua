local M = {}

local url = "https://api.todoist.com/rest/v2/"
local config = require("todoist.config")

local function encode_url(str)
    if str then
        str = str:gsub("([^%w%-_%.~%:/])", function(c) -- Allow ":" and "/"
            return string.format("%%%02X", string.byte(c))
        end)
    end
    return str
end

M.get_request_tasks = function(filter)
    local token = config.get_config().token_api
    local params = encode_url(filter)
    local full_url = url .. "tasks" .. "?filter=" .. params
    local result = vim.system({
        "curl",
        "-s",
        "-H",
        "Authorization: Bearer " .. token,
        full_url,
    })
        :wait().stdout
    return vim.json.decode(result)
end

M.get_single_task = function(filter)
    local token = config.get_config().token_api
    local params = encode_url(filter)
    local full_url = url .. "tasks/" .. params
    local result = vim.system({
        "curl",
        "-s",
        "-H",
        "Authorization: Bearer " .. token,
        full_url,
    })
        :wait().stdout
    return vim.json.decode(result)
end

M.get_request_projects = function()
    local token = config.get_config().token_api
    local result = vim.system({
        "curl",
        "-s",
        "-H",
        "Authorization: Bearer " .. token,
        url .. "projects",
    })
        :wait().stdout
    return vim.json.decode(result)
end

M.post_request = function(payload)
    local token = config.get_config().token_api
    local parts = {}
    for part in string.gmatch(payload, "([^$]+)") do
        table.insert(parts, part)
    end
    local task_body = vim.json.encode({ content = parts[1], due_string = parts[2] })
    local result = vim.system({
        "curl",
        "-XPOST",
        "-s",
        "-d",
        task_body,
        "-H",
        "Authorization: Bearer " .. token,
        "-H",
        "Content-Type: application/json",
        url .. "tasks",
    })
        :wait().stdout
    return vim.json.decode(result)
end

M.close_request = function(id)
    local token = config.get_config().token_api
    local result = vim.system({
        "curl",
        "-XPOST",
        "-s",
        "-H",
        "Authorization: Bearer " .. token,
        "-H",
        "Content-Type: application/json",
        url .. "tasks/" .. id .. "/close",
    })
        :wait().stdout
    return result
end

M.print = function(payload)
    print(vim.inspect(payload))
end

return M
