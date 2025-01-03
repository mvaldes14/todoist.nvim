vim.api.nvim_create_user_command("TodoistTasks", "lua require('todoist').get_tasks()", {})
