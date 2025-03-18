local M = {}
local utils = require("todoist.utils")

--- description: Creates a floating window
--- @return table: The buffer and window
local function create_win(opts)
    opts = opts or {}
    local width, height, col, row
    if opts.small then
        width = math.floor(vim.o.columns * 0.5)
        height = math.floor(vim.o.lines * 0.2)
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
        footer = opts.footer,
        footer_pos = "center",
    })
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
    local ns_id = vim.api.nvim_create_namespace("todoist")
    local float = create_win({ name = name, small = true, footer = "<q> Close, <x> Close Task" })
    local task_info = utils.get_single_task(item.id) or {}
    local payload = {
        Content = vim.tbl_get(task_info, "content"),
        Created = vim.tbl_get(task_info, "created_at"),
        Deadline = vim.tbl_get(task_info, "deadline") or nil,
        Description = vim.tbl_get(task_info, "description") or nil,
        Due = vim.tbl_get(task_info, "due.date"),
        Recurring = vim.tbl_get(task_info, "due.is_recurring"),
        Done = vim.tbl_get(task_info, "is_completed"),
        Labels = vim.tbl_get(task_info, "labels") or nil,
        Priority = vim.tbl_get(task_info, "priority"),
        URL = vim.tbl_get(task_info, "url"),
    }
    vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, { "ID: " .. item.id })
    local labels = ""
    for _, v in pairs(payload["Labels"]) do
        labels = labels .. "@" .. v
    end
    payload["Labels"] = labels
    for k, v in pairs(payload) do
        vim.api.nvim_buf_set_lines(float.buf, -1, -1, false, { k .. ": " .. tostring(v) })
    end
    vim.keymap.set({ "n" }, "x", function()
        if vim.api.nvim_buf_is_valid(float.buf) then
            local api = require("todoist.api")
            api.complete_task(item.id)
        end
    end, { buffer = float.buf })
end

M.show_todos = function(items)
    local opts = {
        prompt = "Pick an item",
        format_item = function(item)
            local labels = ""
            for _, v in pairs(item.labels) do
                labels = labels .. "@" .. v
            end
            return item.name .. " #" .. item.project_name .. "  " .. item.due .. " " .. labels
        end,
    }
    vim.ui.select(items, opts, function(selected)
        if selected then
            show_todo_item(selected)
        end
    end)
end

return M
