local M = {}

--- description: Creates a floating window
--- @return table: The buffer and window
M.create_win = function()
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        title = "Todoist",
        title_pos = "center",
        border = "rounded",
        footer = "<q> Close, <a> Add Task, <x> Complete Task",
        footer_pos = "center",
    })
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    vim.keymap.set({ "n" }, "q", function()
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_win_close(win, true)
        end
    end, { buffer = buf })
    vim.keymap.set({ "n" }, "a", function()
        local api = require("todoist.api")
        api.api_add_tasks()
    end, { buffer = buf })
    vim.keymap.set({ "n" }, "x", function()
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_win_close(win, true)
        end
    end, { buffer = buf })

    return { buf = buf, win = win }
end

return M
