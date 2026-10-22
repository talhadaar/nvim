require("nvchad.configs.lspconfig").defaults()

-- Neovim never wraps virtual text/lines, so wrap the message ourselves to the
-- window width. Left margin covers the gutter plus the virtual_lines connector.
local function wrap_diagnostic(d)
  local win = vim.fn.bufwinid(d.bufnr)
  if win == -1 then
    win = vim.api.nvim_get_current_win()
  end
  local textoff = vim.fn.getwininfo(win)[1].textoff
  local width = math.max(20, vim.api.nvim_win_get_width(win) - textoff - d.col - 8)

  local out = {}
  for line in d.message:gmatch "[^\n]+" do
    local cur = ""
    for word in line:gmatch "%S+" do
      if cur ~= "" and #cur + 1 + #word > width then
        table.insert(out, cur)
        cur = word
      else
        cur = cur == "" and word or cur .. " " .. word
      end
    end
    table.insert(out, cur)
  end
  return table.concat(out, "\n")
end

vim.diagnostic.config {
  virtual_text = false,
  virtual_lines = { format = wrap_diagnostic },
}

vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
  callback = function()
    vim.diagnostic.show()
  end,
})

local servers = { "html", "cssls", "basedpyright", "ruff", "rust_analyzer", "taplo", "jsonls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
