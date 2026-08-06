require "nvchad.autocmds"

-- Auto-hover LSP docs when the cursor rests. Fires on CursorHold, so cadence
-- is vim.o.updatetime (250ms, set by NvChad).
vim.g.auto_hover = true

local hover_shown = false

-- hover() tags its float with a window var named after its focus_id, so that
-- is how we find it again (see :h vim.lsp.util.open_floating_preview).
local function close_hover()
  local cur = vim.api.nvim_get_current_win()
  if vim.w[cur]["textDocument/hover"] then
    return -- cursor is inside the float; leave it so <leader>lh stays scrollable
  end

  hover_shown = false
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.w[win]["textDocument/hover"] then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
end

-- CursorMoved already dismisses the float; this covers keys that fire no
-- autocmd at all (<C-s>, toggles, z-commands, leader prefixes).
vim.on_key(function()
  if hover_shown then
    vim.schedule(close_hover)
  end
end, vim.api.nvim_create_namespace "auto_hover")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = args.buf,
      callback = function()
        if not vim.g.auto_hover then
          return
        end
        -- focusable=false stops a second hover from jumping the cursor into the
        -- float; <leader>lh stays focusable for scrolling long docs.
        vim.lsp.buf.hover { focusable = false, silent = true }
        hover_shown = true
      end,
    })
  end,
})
