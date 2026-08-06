-- Telescope picker over all git hunks, previewed as a real diff.
local M = {}

-- Locate the `@@ -a,b +c,d @@` header whose new-side range covers lnum.
local function hunk_header_line(lines, lnum)
  local last = 1
  for i, line in ipairs(lines) do
    local start, count = line:match "^@@ %-%d+,?%d* %+(%d+),?(%d*) @@"
    if start then
      start = tonumber(start)
      if start > lnum then
        return last
      end
      last = i
    end
  end
  return last
end

local function preview(self, entry)
  local file = entry.filename
  local cwd = vim.fs.dirname(file)
  local out = vim.system({ "git", "diff", "-U3", "--", file }, { cwd = cwd, text = true }):wait()

  -- untracked files have no tracked counterpart; --no-index renders them as a full add
  if out.stdout == "" then
    out = vim.system({ "git", "diff", "--no-index", "--", "/dev/null", file }, { cwd = cwd, text = true }):wait()
  end

  local lines = vim.split(out.stdout, "\n", { trimempty = true })
  vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
  vim.bo[self.state.bufnr].filetype = "diff"

  local target = hunk_header_line(lines, entry.lnum)
  pcall(vim.api.nvim_win_set_cursor, self.state.winid, { target, 0 })
  pcall(vim.api.nvim_win_call, self.state.winid, function()
    vim.cmd "normal! zt"
  end)
end

function M.pick()
  require("gitsigns").setqflist("all", { open = false }, function()
    require("telescope.builtin").quickfix {
      prompt_title = "Git Hunks",
      previewer = require("telescope.previewers").new_buffer_previewer {
        title = "Hunk Diff",
        -- keyed per hunk, not per file, or the cached buffer keeps the previous scroll position
        get_buffer_by_name = function(_, entry)
          return entry.filename .. ":" .. entry.lnum
        end,
        define_preview = preview,
      },
    }
  end)
end

return M
