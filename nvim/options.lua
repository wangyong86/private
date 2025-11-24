-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.o.background = "dark" -- or "light" for light mode
--vim.cmd([[colorscheme gruvbox]])
-- Lua 配置文件 (例如 init.lua 或 lua/options.lua)

-- "set noet"  -> 不使用 expandtab (即 Tab 键插入硬 Tab 字符)
vim.opt.expandtab = false

-- "auto indent using 4 spaces"
vim.opt.autoindent = true
vim.opt.cindent = true

-- "line width and no wrap"
-- "set cc=80" -> 设置 colorcolumn 在第 80 列
vim.opt.colorcolumn = "80"
-- "set nowrap" -> 不自动换行
vim.opt.wrap = false

-- "align at (" -> 设置 C 风格缩进，使括号后的缩进正确
-- "set cino=(0"
vim.opt.cindent = true
vim.opt.cinoptions = "(0"

-- "auto detect filetype, for taglsit etc."
-- "filetype on" -> Neovim 默认启用此功能，但显式设置也无妨
vim.cmd('filetype plugin indent on') -- 启用文件类型检测、插件和缩进

-- "highlight synatx"
-- "syntax on" -> Neovim 默认启用此功能，通常无需设置

-- "highlight current line"
-- "set cursorline"
vim.opt.cursorline = true

-- "don't add style automatically"
-- "set paste" -> 进入粘贴模式，禁用自动缩进和映射
vim.opt.paste = true -- 注意：通常在需要粘贴时，手动使用 :set paste 或快捷键切换，而不是永久设置

-- "dispaly row, col"
-- "set ruler"
vim.opt.ruler = true

-- "bell"
-- "set noeb" -> 不使用可视铃声 (error bell)
vim.opt.errorbells = false
-- "set vb" -> 使用可视铃声 (visual bell)
vim.opt.visualbell = true

-- "avoid blue comment hard to recognation during night"
-- "set t_Co=256" -> 设置终端颜色为 256 色
vim.opt.termguicolors = true -- 现代终端推荐使用 termguicolors，它自动处理颜色深度
-- "colorscheme desert" -> 颜色主题需要用 vim.cmd
vim.cmd('colorscheme desert')

-- "set foldmethod=indent and disable it by default"
-- "set foldlevelstart=99" -> 默认禁用折叠 (foldlevelstart=99 表示折叠级别极高，所有代码都展开)
vim.opt.foldlevelstart = 99
-- 如果需要设置折叠方法，可以使用：
-- vim.opt.foldmethod = 'indent'

-- "search highlight"
-- "set hlsearch"
vim.opt.hlsearch = true

-- "enable mouse"
-- "set mouse=a"
vim.opt.mouse = 'a'
