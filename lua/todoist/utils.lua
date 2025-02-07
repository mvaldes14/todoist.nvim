local M = {}

local url = "https://api.todoist.com/rest/v2/"

local function encode_url(str)
    if str then
        str = str:gsub("([^%w%-_%.~%:/])", function(c) -- Allow ":" and "/"
            return string.format("%%%02X", string.byte(c))
        end)
    end
    return str
end

M.get_request = function(endpoint, filter, token)
    local params = encode_url(filter)
    local full_url = url .. endpoint .. "?filter=" .. params
    print(full_url)
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

M.post_request = function() end

return M
