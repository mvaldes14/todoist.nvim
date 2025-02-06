vim.api.nvim_create_user_command("TodoistTasks", "lua require('todoist').show_tasks()", {})
vim.api.nvim_create_user_command("TodoistAdd", "lua require('todoist').add_tasks()", {})
