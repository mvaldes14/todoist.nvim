local M = {}

-- NOTE: Floating window buffer type markdown

--- description: Creates a floating window
--- @return table: The buffer and window
M.create_win = function()
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = 80,
        height = 20,
        row = 10,
        col = 10,
        style = "minimal",
        title = "Todoist",
        border = "single",
    })
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    vim.keymap.set({ "n" }, "q", function()
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_win_close(win, true)
        end
    end, { buffer = buf })
    return { buf = buf, win = win }
end

return M
