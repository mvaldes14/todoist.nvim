local M = {}

---Sends a request to the todoist api
---@param url string: The url to send the request to
---@param token string: The api token to use
---@return table: The response from the api
M.get_request = function(url, token)
    local result = vim.system({
        "curl",
        "-s",
        "-H",
        "Authorization: Bearer " .. token,
        url,
    })
        :wait().stdout
    return vim.json.decode(result)
end

M.post_request = function(url, token, payload) end

return M
