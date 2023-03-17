vim.api.nvim_create_user_command("Fcopystart", require("fcopy").start, {})
vim.cmd "command! -range Fcopyend lua require'fcopy'.end_()"

