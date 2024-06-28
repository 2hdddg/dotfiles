local treesitter = require('nvim-treesitter')
local colors = require('colors')

local function recordingMacro()
    local reg = vim.fn.reg_recording()
    if reg == "" then
        return reg
    end
    return "Recording @" .. reg
end

local function searchStatus()
    if vim.v.hlsearch == 0 then
        return ""
    end
    local x = vim.fn.searchcount()
    local s = "[" .. x.current .. "/"
    local total = x.total
    if x.total == x.maxcount then
        s = s .. "*]"
    else
        s = s .. x.total .. "]"
    end
    return "Search " .. s
end

local function pathOrFilename()
    -- Only filename
    name = vim.fn.expand('%:t')
    if name == '' then
        -- Probably an oil.nvim buffer, anyway use full path
        name = vim.fn.expand('%')
        if string.find(name, "oil://") == 1 then
            name = string.gsub(name, "oil://", "", 1)
        end
    end
    -- Append modifications
    opts = ''
    if vim.bo.modified then
        opts = ' 󰙏'
    elseif not vim.bo.modifiable or vim.bo.readonly then
        opts = ' '
    end
    -- Compose
    return name .. opts
end

local theme = {
  normal = {
    a = {bg = colors.green, fg = colors.black },
    b = {bg = colors.red, fg = colors.black },
    c = {bg = colors.xgray6, fg = colors.xgray1},
    x = {bg = colors.black, fg = colors.black},
    y = {bg = colors.xbright_orange, fg = colors.black},
    z = {bg = colors.xbright_orange, fg = colors.black},
  },
  insert = {
    a = {bg = colors.blue, fg = colors.black},
    z = {bg = colors.xbright_orange, fg = colors.black},
  },
  visual = {
    a = {bg = colors.yellow, fg = colors.black},
    z = {bg = colors.xbright_orange, fg = colors.black},
  },
  replace = {
    a = {bg = colors.red, fg = colors.black},
    z = {bg = colors.xbright_orange, fg = colors.black},
  },
  command = {
    a = {bg = colors.xgray3, fg = colors.black},
    z = {bg = colors.xbright_orange, fg = colors.black},
  },
  inactive = {
    a = {bg = colors.xgray6, fg = colors.black},
    b = {bg = colors.xgray6, fg = colors.black},
    c = {bg = colors.xgray6, fg = colors.black},
    x = {bg = colors.xgray6, fg = colors.black},
    y = {bg = colors.xgray6, fg = colors.black},
    z = {bg = colors.xgray6, fg = colors.black},
  },
  inactive_sections = {
    lualine_a = {pathOrFilename},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {{'diagnostics', sources = {'nvim_diagnostic'}}},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
}
require'lualine'.setup {
  options = {
    icons_enabled = false,
    theme = theme,
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {'class'}
  },
  sections = {
    lualine_a = {pathOrFilename},
    lualine_b = {recordingMacro},
    lualine_c = {searchStatus},
    lualine_x = {{'diagnostics', sources = {'nvim_diagnostic'}}},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
  tabline = {},
  extensions = {}
}
