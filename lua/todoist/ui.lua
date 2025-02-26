local M = {}

--- description: Creates a floating window
--- @return table: The buffer and window
M.create_win = function()
    -- TODO: Make this generic so it can be reused
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
        footer = "<q> Close",
        footer_pos = "center",
    })
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    vim.keymap.set({ "n" }, "q", function()
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_win_close(win, true)
        end
    end, { buffer = buf })
    return { buf = buf, win = win }
end

-- TODO: Rethink if this is needed
-- Buffer vs Notify
local function show_todo_item(item)
    local name = item.name
    local due = item.due
    local completed = item.completed and "Done" or "Not Done"
    local project_name = item.project_name
    vim.notify(project_name .. ":" .. name .. "->" .. due .. "[ ]" .. completed, vim.log.levels.INFO)
end
-- TODO: What do we do once we find an item?
-- What do we show or do with it?
M.show_todos = function(items)
    local opts = {
        prompt = "Pick a todo",
        format_item = function(item)
            return "#" .. item.project_name .. ": " .. item.name .. " - " .. item.due
        end,
    }

    vim.ui.select(items, opts, function(selected)
        show_todo_item(selected)
    end)
end

return M
