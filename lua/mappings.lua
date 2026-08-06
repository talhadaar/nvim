-- NvChad's own mappings are deliberately NOT sourced; this file owns the leader tree.
-- Group labels and icons live in configs/whichkey.lua.
local map = vim.keymap.set

-- insert mode movement
map("i", "<C-b>", "<ESC>^i", { desc = "Move to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move to end of line" })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })
map("i", "jk", "<ESC>")

-- windows
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

-- general
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle explorer" })
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Escape terminal mode" })

map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "Next buffer" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Previous buffer" })

-- toggleable terminals
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "Toggle vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Toggle horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Toggle floating term" })

-- leader: direct
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus explorer" })
map("n", "<leader>?", "<cmd>WhichKey<CR>", { desc = "All keymaps" })
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- leader b: buffers
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "<leader>bf", "<cmd>Telescope buffers<CR>", { desc = "Find buffer" })
map("n", "<leader>b]", function()
  require("nvchad.tabufline").next()
end, { desc = "Next buffer" })
map("n", "<leader>b[", function()
  require("nvchad.tabufline").prev()
end, { desc = "Previous buffer" })
map("n", "<leader>bd", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Close buffer" })

-- leader f: find
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Files" })
map("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", { desc = "All files" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Grep" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "In current buffer" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help pages" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Marks" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "Hidden terminals" })

-- leader g: git
map("n", "<leader>gh", function()
  require("configs.githunks").pick()
end, { desc = "Hunks (all files)" })
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Status" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Commits" })
map("n", "<leader>gp", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })
map("n", "<leader>gb", function()
  require("gitsigns").blame_line { full = true }
end, { desc = "Blame line" })
map("n", "<leader>gd", function()
  require("gitsigns").diffthis()
end, { desc = "Diff this file" })

map("n", "]c", function()
  require("gitsigns").nav_hunk "next"
end, { desc = "Next git hunk" })

map("n", "[c", function()
  require("gitsigns").nav_hunk "prev"
end, { desc = "Previous git hunk" })

-- leader l: lsp. Buffer-local so they only appear where a server is attached.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local function o(desc)
      return { buffer = buf, desc = desc }
    end

    -- NvChad's defaults() attaches its own orphan leader maps; drop them.
    for _, lhs in ipairs { "<leader>wa", "<leader>wr", "<leader>wl", "<leader>D", "<leader>ra" } do
      pcall(vim.keymap.del, "n", lhs, { buffer = buf })
    end

    map("n", "gd", vim.lsp.buf.definition, o "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, o "Go to declaration")
    -- no `gr` map: it would shadow Neovim's built-in grr/gra/grn/gri family
    map("n", "gR", vim.lsp.buf.references, o "Go to references")

    map("n", "<leader>la", vim.lsp.buf.code_action, o "Code action")
    map("n", "<leader>lr", require "nvchad.lsp.renamer", o "Rename symbol")
    map("n", "<leader>lh", vim.lsp.buf.hover, o "Hover docs")
    map("n", "<leader>ls", vim.lsp.buf.signature_help, o "Signature help")
    map("n", "<leader>lt", vim.lsp.buf.type_definition, o "Type definition")
    map("n", "<leader>lS", "<cmd>Telescope lsp_document_symbols<CR>", o "Document symbols")
    map("n", "<leader>lW", "<cmd>Telescope lsp_workspace_symbols<CR>", o "Workspace symbols")
    map("n", "<leader>li", "<cmd>checkhealth vim.lsp<CR>", o "LSP info")

    map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, o "Add workspace folder")
    map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, o "Remove workspace folder")
    map("n", "<leader>lwl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, o "List workspace folders")
  end,
})

map({ "n", "x" }, "<leader>lf", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "Format file" })

-- leader t: terminal
map("n", "<leader>th", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "Horizontal terminal" })

map("n", "<leader>tv", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "Vertical terminal" })

map("n", "<leader>tf", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Floating terminal" })

-- leader u: ui / toggles
map("n", "<leader>un", "<cmd>set nu!<CR>", { desc = "Line numbers" })
map("n", "<leader>ur", "<cmd>set rnu!<CR>", { desc = "Relative numbers" })
map("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Word wrap" })
map("n", "<leader>us", "<cmd>set spell!<CR>", { desc = "Spellcheck" })
map("n", "<leader>uc", "<cmd>NvCheatsheet<CR>", { desc = "Cheatsheet" })
map("n", "<leader>uh", function()
  vim.g.auto_hover = not vim.g.auto_hover
  print("auto hover " .. (vim.g.auto_hover and "on" or "off"))
end, { desc = "Auto hover docs" })
map("n", "<leader>ut", function()
  require("nvchad.themes").open()
end, { desc = "Theme picker" })

-- leader x: diagnostics
map("n", "<leader>xx", vim.diagnostic.setloclist, { desc = "Loclist" })
map("n", "<leader>xd", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Document diagnostics" })
map("n", "<leader>xw", "<cmd>Telescope diagnostics<CR>", { desc = "Workspace diagnostics" })
map("n", "<leader>xl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
