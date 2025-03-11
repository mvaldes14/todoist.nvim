local M = {}
local utils = require("todoist.utils")

--- description: Creates a floating window
--- @return table: The buffer and window
local function create_win(opts)
    opts = opts or {}
    local width, height, col, row
    if opts.small then
        width = math.floor(vim.o.columns * 0.4)
        height = math.floor(vim.o.lines * 0.4)
    else
        width = math.floor(vim.o.columns * 0.8)
        height = math.floor(vim.o.lines * 0.8)
    end
    col = math.floor((vim.o.columns - width) / 2)
    row = math.floor((vim.o.lines - height) / 2)
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        title = opts.name or "Todoist",
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

M.create_win = create_win

local function show_todo_item(item)
    local name = item.name
    local win = create_win({ name = name, small = true })
    local task_info = utils.get_single_task(item.id)
    local payload = {
        Content = vim.tbl_get(task_info, "content"),
        Created = vim.tbl_get(task_info, "created_at"),
        Deadline = vim.tbl_get(task_info, "deadline"),
        Description = vim.tbl_get(task_info, "description"),
        due = vim.tbl_get(task_info, "due.date"),
        recurring = vim.tbl_get(task_info, "due.is_recurring"),
        done = vim.tbl_get(task_info, "is_completed"),
        labels = vim.tbl_get(task_info, "labels"),
        priority = vim.tbl_get(task_info, "priority"),
        url = vim.tbl_get(task_info, "url"),
    }
    for k, v in pairs(payload) do
        vim.api.nvim_buf_set_lines(win.buf, -1, -1, false, { k .. ": " .. tostring(vim.inspect(v)) })
    end
end

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
