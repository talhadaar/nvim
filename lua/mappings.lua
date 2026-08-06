require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- git hunks
map("n", "<leader>gh", function()
  require("configs.githunks").pick()
end, { desc = "telescope git hunks" })

map("n", "]c", function()
  require("gitsigns").nav_hunk "next"
end, { desc = "git next hunk" })

map("n", "[c", function()
  require("gitsigns").nav_hunk "prev"
end, { desc = "git prev hunk" })

map("n", "<leader>gp", function()
  require("gitsigns").preview_hunk()
end, { desc = "git preview hunk" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
