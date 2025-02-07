local M = {}

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

M.post_request = function() end

return M
