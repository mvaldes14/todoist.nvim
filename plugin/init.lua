vim.api.nvim_create_user_command("TodoistTasks", function(opts)
    require("todoist").show_tasks(opts)
end, { nargs = "?" })
vim.api.nvim_create_user_command("TodoistAdd", "lua require('todoist').add_tasks()", {})
