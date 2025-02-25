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


-- TODO: Rethink if this is needed
-- M.create_input_win = function()
--   local task_line = 'init'
-- local width = math.floor(vim.o.columns * 0.2)
-- local height = math.floor(vim.o.lines * 0.2)
-- local col = math.floor((vim.o.columns - width) / 2)
-- local row = math.floor((vim.o.lines - height) / 2)
-- local buf = vim.api.nvim_create_buf(false, true)
-- local win = vim.api.nvim_open_win(buf, true, {
--   relative = "editor",
--   width = 30,
--   height = 1,
--   row = row,
--   col = col,
--   style = "minimal",
--   title = "Add a Task",
--   title_pos = "center",
--   border = "rounded",
--   focusable = true,
--   footer = "<q> Submit",
--   footer_pos = "center",
-- })
-- vim.keymap.set({ "n" }, "q", function()
--   if vim.api.nvim_buf_is_valid(buf) then
--     task_line = vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1]
--     vim.api.nvim_win_close(win, true)
--   end
-- end, { buffer = buf })
-- return task_line
-- return task_line
-- end

M.show_todos = function(items)
  local opts = {
    prompt = "Pick a todo",
    format_item = function(item)
      return item.name .. " " .. item.due
    end
  }

  vim.ui.select(items, opts, function(selected)
    print(selected)
  end)
end

return M
