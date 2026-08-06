dofile(vim.g.base46_cache .. "whichkey")

return {
  preset = "modern",
  delay = 200,
  icons = {
    mappings = true,
    rules = false, -- rules guess icons from desc keywords; we set them explicitly
  },
  spec = {
    { "<leader>b", group = "Buffers", icon = { icon = "󰓩", color = "cyan" } },
    { "<leader>f", group = "Find", icon = { icon = "󰍉", color = "azure" } },
    { "<leader>g", group = "Git", icon = { icon = "󰊢", color = "orange" } },
    { "<leader>l", group = "LSP", icon = { icon = "󰒕", color = "green" } },
    { "<leader>lw", group = "Workspace folders", icon = { icon = "󰉋", color = "green" } },
    { "<leader>t", group = "Terminal", icon = { icon = "", color = "grey" } },
    { "<leader>u", group = "UI / Toggles", icon = { icon = "󰒓", color = "purple" } },
    { "<leader>d", group = "Diagnostics", icon = { icon = "󰒡", color = "red" } },
    { "<leader>W", group = "Window", icon = { icon = "󰅁", color = "azure" } },

    { "<leader>w", icon = { icon = "󰆓", color = "green" } },
    { "<leader>x", icon = { icon = "󰅖", color = "red" } },
    { "<leader>q", icon = { icon = "󰈆", color = "red" } },
    { "<leader>Q", icon = { icon = "󰩈", color = "red" } },
    { "<leader>e", icon = { icon = "󰙅", color = "yellow" } },
    { "<leader>/", icon = { icon = "󰆈", color = "grey" } },
    { "<leader>?", icon = { icon = "󰌌", color = "blue" } },
  },
}
