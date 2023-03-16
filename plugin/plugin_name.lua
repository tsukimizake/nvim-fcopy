vim.api.nvim_create_user_command("Fcopystart", require("fcopy").start, {})
vim.api.nvim_create_user_command("Fcopyend", require("fcopy").end_, {})
