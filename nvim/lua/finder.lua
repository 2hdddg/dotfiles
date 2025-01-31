local telescope = require'telescope'
local actions = require'telescope.actions'
telescope.setup{
  defaults = {
    layout_strategy = 'bottom_pane',
    sorting_strategy = "ascending",
    wrap_results = true,
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
  extensions = {
      file_browser = {
          hijack_netrw = true,
          hidden = true,
          grouped = true,
          hide_parent_dir = true,
      },
  },
}
telescope.load_extension('fzf')
