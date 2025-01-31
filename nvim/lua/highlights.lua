local colors = require('colors')
local theme = {
    CursorLine = { bg=colors.xgray2, style="NONE" },
    CursorColumn = { bg=colors.xgray2 },
    MatchParen = { style = "inverse" },
    ColorColumn = { bg = colors.xgray2, style="NONE" },
    Conceal = { fg = colors.blue },
    CursorLineNr = { fg = colors.yellow, bg = colors.black },
    Visual = { fg='NONE', bg='NONE', style = "reverse" }, -- VisualNOS
    Search = { fg='NONE', bg='NONE', style = "reverse" },
    IncSearch = { fg='NONE', bg='NONE', style = "reverse" },
    Underlined = { fg=colors.blue, style = "underline" },
    Whitespace = { fg=colors.xgray3 },
    NonText = { link='Whitespace' },
    MoreMsg = {fg=colors.yellow, style="bold"},
    Directory = {fg=colors.green, style="bold"},
    Title = {fg=colors.green, style="bold"},
    LineNr = {fg=colors.bright_black},
    SignColumn = {bg=colors.black},
    Folded = {fg=colors.bright_black, bg=colors.black, style="italic"},
    FoldColumn = {fg=colors.bright_black, bg=colors.black},
    Cursor = {fg=colors.black, bg=colors.yellow},
    TermCursor = {fg=colors.yellow, bg=colors.black},
    TermCursorNC = {fg=colors.yellow, bg=colors.black},
    -- Popup border and background
    FloatBorder = {fg=colors.yellow},
    NormalFloat = {bg=colors.black},

    -- Completion menu
    Pmenu = { bg=colors.white, fg=colors.xgray2 },
    PmenuSel = { fg=colors.xorange, style="reverse" },
    PmenuSbar = { bg=colors.xgray2 },
    PmenuThumb = { bg=colors.yellow },
    --Pmenu
    --PmenuExtra
    --PmenuSel
    --PmenuKind
    --PmenuKindSel
    --PmenuExtraSel
    --PmenuSbar
    --PmenuThumb


    -- Telescope, style as completion menu
    TelescopeNormal = { link = 'Pmenu' },
    TelescopeResultsNormal = { bg = colors.black },
    TelescopePreviewNormal = { bg = colors.black }, -- Make preview of code look normal
    TelescopePromptNormal = { bg = colors.black }, -- Make preview of code look normal
    TelescopeSelection = { link = 'PmenuSel' },
    TelescopeMatching = {style = "reverse" },
    TelescopeBorder = {link = 'FloatBorder'},

    -- Oil
    OilFile = {fg = colors.cyan },
    OilLink = {fg = colors.xorange },

    -- Syntax
    -- Used by netrw to show file
    -- Also default linked to in syntax
    Identifier = {fg=colors.white},
    -- Built in language keywords
    Keyword = {fg=colors.red},
    Repeat = {link='Keyword'},
    Statement = {link='Keyword'},
    Conditional = {link='Keyword'},
    ['@type.qualifier'] = {link='Keyword'},
    -- Stuff loke void/float..
    ['@type.builtin'] = {link='Keyword'},
    StorageClass = {link='Keyword'},
    -- Constants (like literals but also semantic)
    Constant = {fg=colors.green},
    Boolean = {link='Constant'},
    Character = {link='Constant'},
    Float = {link='Constant'},
    Number = {link='Constant'},
    ['@lsp.mod.readonly'] = {link='Constant'},
    -- Special constant is string
    String = {fg=colors.bright_black, style="italic"},
    -- Scope of variables (instance vars)
    ['@lsp.typemod.property.classScope'] = {fg=colors.xbright_orange},
    -- Want this to override above but they are same priority...
    ['@lsp.typemod.property.readonly'] = {link='Constant'},
    ['@lsp.typemod.property.readonly.cpp'] = {link='Constant'},
    -- Type
    Type = {fg=colors.cyan},
    Structure = {link='Structure'},
    -- Separators
    Operator = {fg=colors.bright_white},
    Delimiter = {link='Operator'},
    -- Comment
    Comment = {fg=colors.xgray6, style="italic"},
    -- Preprocessor
    PreProc = {fg=colors.blue, style="italic"},
    Define = {link='PreProc'},
    Include = {link='PreProc'},
    Macro = {link='PreProc'},

    Exception = {fg=colors.red},
    Function = {fg=colors.yellow},
    Label = {fg=colors.red},
    PreCondit = {fg=colors.cyan},
    -- Make special chars stick out from string
    Special = {fg=colors.red},
    -- SpecialComment
    Todo = {fg=colors.xorange, bg=colors.black},
    Typedef = {link='Type'},
    -- TODO: 
    -- Treesitter
    ['@namespace'] = {fg=colors.bright_black},
    ['@variable'] = {fg=colors.white},
    ['@parameter'] = {link='@variable'},
    ['@field'] = {link='@variable'},
    ['@property'] = {link='@variable'},
    ['@constructor'] = {link='Function'},
    ['@function.call'] = {link='Function'},
    ['@attribute'] = {fg=colors.xorange},

    -- Diff
    DiffAdd = {fg=colors.green, bg=colors.black},
    DiffDelete = {fg=colors.red, bg=colors.black},
    DiffChange = {fg=colors.cyan, bg=colors.black},
    DiffText = {fg=colors.yellow, bg=colors.black},

    -- Lsp
    LspDiagnosticsDefaultError = {fg=colors.bright_red},
    LspDiagnosticsDefaultWarning = {fg=colors.bright_yellow},
    LspDiagnosticsDefaultInformation = {fg=colors.bright_green},
    LspDiagnosticsDefaultHint = {fg=colors.bright_cyan},
    LspDiagnosticsUnderlineError = {fg=colors.bright_red, style='underline'},
    LspDiagnosticsUnderlineWarning = {fg=colors.bright_yellow, style='underline'},
    LspDiagnosticsUnderlineInformation = {fg=colors.bright_green, style='underline'},
    LspDiagnosticsUnderlineHint = { fg=colors.bright_cyan, style='underline'},
    ['@lsp.type.namespace'] = {fg=colors.xgray6},
    ['@lsp.typemod.type.definition'] = {fg=colors.blue},
    ['@lsp.typemod.method.definition'] = {fg=colors.bright_magenta},
    ['@lsp.typemod.function.definition'] = {fg=colors.bright_magenta},

    -- CMP (ItemKind is just the kind, not the actual name)
    CmpItemKindDefault = {link='Identifier'},
    CmpItemKindFunction = {link='Function'},
    MiniCompletionActiveParameter = {fg=colors.xorange},

    -- TermDebug
    debugPC = { bg=colors.xgray6, style="NONE" },
}

local function highlight(group, properties)
    local cmd = "highlight " 
    if (properties.link) then
        cmd = cmd .. "link " .. group .. " " .. properties.link
    else
        cmd = cmd .. group
        if properties.bg then
            cmd = cmd .. " ctermbg=" .. properties.bg
        end
        if properties.fg then
            cmd = cmd .. " ctermfg=" .. properties.fg
        end
        if properties.style then
            cmd = cmd .. " cterm=" .. properties.style
        end
    end
    vim.cmd(cmd)
end

vim.o.background = "dark"
vim.cmd("highlight clear")
for group, properties in pairs(theme) do
    highlight(group, properties)
end
