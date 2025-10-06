---@module "snacks"
vim.g.lazyvim_picker = 'snacks'

-- Disabling some providers that I don't need right now.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Set <space> as the leader key
-- See `help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ******************* Vim Options ******************* --
-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true -- I like seeing the amount of lines to a line

vim.o.mouse = 'a' -- Sometimes, I use the mouse for resizing splits

vim.o.showmode = false -- The mode is already in the status line

-- This shares my clipboard between the OS and Neovim
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

-- Enables break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Make indent four spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Stop me before I close an unsaved file
vim.o.confirm = true

-- ******************** Keymaps ******************* --
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- ****************** Autocommands ******************** --
-- See `:help lua-guide-autocommands`

-- Highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- ************** Install Lazy Vim ************** --
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- ******************* Configure Plugins ***************** --
-- See status of plugins -> :Lazy
-- Update plugins        -> :Lazy update

require('lazy').setup {
    'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = { -- Automatically add options to a setup function
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },

    { -- Useful plugin to show you pending keybinds.
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        opts = {
            -- delay between pressing a key and opening which-key (milliseconds)
            -- this setting is independent of vim.o.timeoutlen
            delay = 0,
            icons = {
                -- set icon mappings to true if you have a Nerd Font
                mappings = vim.g.have_nerd_font,
                -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
                -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
                keys = vim.g.have_nerd_font and {} or {
                    Up = '<Up> ',
                    Down = '<Down> ',
                    Left = '<Left> ',
                    Right = '<Right> ',
                    C = '<C-…> ',
                    M = '<M-…> ',
                    D = '<D-…> ',
                    S = '<S-…> ',
                    CR = '<CR> ',
                    Esc = '<Esc> ',
                    ScrollWheelDown = '<ScrollWheelDown> ',
                    ScrollWheelUp = '<ScrollWheelUp> ',
                    NL = '<NL> ',
                    BS = '<BS> ',
                    Space = '<Space> ',
                    Tab = '<Tab> ',
                    F1 = '<F1>',
                    F2 = '<F2>',
                    F3 = '<F3>',
                    F4 = '<F4>',
                    F5 = '<F5>',
                    F6 = '<F6>',
                    F7 = '<F7>',
                    F8 = '<F8>',
                    F9 = '<F9>',
                    F10 = '<F10>',
                    F11 = '<F11>',
                    F12 = '<F12>',
                },
            },

            -- Document existing key chains
            spec = {
                { '<leader>s', group = '[S]earch' },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
            },
        },
    },

    { -- Setup snacks for a lot of useful utilites
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = { -- There's more options, so I should explore them in the future
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            debug = { enabled = true },
            explorer = { enabled = true }, -- This is the one that got me interested
            git = { enabled = true },
            bitbucket = { enabled = true },
            image = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
        },
        keys = {
        -- stylua: ignore start
        { '<leader>;', function() Snacks.dashboard.open() end, desc = 'Open Dashboard' },
	
	    -- Top Pickers & Explorer
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
        { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
        -- find
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
        -- git
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
        { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
        { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
        -- Grep
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
        -- search
        { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
        { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
        { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
        { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
        { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
        { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
        { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
        { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
        -- LSP
        { "grd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        { "grD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
        { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "grtd", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        { "<leader>grs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
        { "<leader>grS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
            --stylua: ignore end
        },
    },

    -- ******************** LSP Plugins ******************* --
    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },

    { -- Main LSP Configuration
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'mason-org/mason.nvim', opts = {} },
            'mason-org/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- Status update for LSP
            { 'j-hui/fidget.nvim', opts = {} },

            -- Extra capabilities from blink.cmp
            'saghen/blink.cmp',
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
                    ---@param client vim.lsp.Client
                    ---@param method vim.lsp.protocol.Method
                    ---@param bufnr? integer some lsp support methods only in specific files
                    ---@return boolean
                    local function client_supports_method(client, method, bufnr)
                        if vim.fn.has 'nvim-0.11' == 1 then
                            return client:supports_method(method, bufnr)
                        else
                            return client.supports_method(method, { bufnr = bufnr })
                        end
                    end

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                        local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
                            end,
                        })
                    end

                    -- The following code creates a keymap to toggle inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            -- Diagnostic Config
            -- See :help vim.diagnostic.Opts
            vim.diagnostic.config {
                severity_sort = true,
                float = { border = 'rounded', source = 'if_many' },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = vim.g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '󰅚 ',
                        [vim.diagnostic.severity.WARN] = '󰀪 ',
                        [vim.diagnostic.severity.INFO] = '󰋽 ',
                        [vim.diagnostic.severity.HINT] = '󰌶 ',
                    },
                } or {},
                virtual_text = {
                    source = 'if_many',
                    spacing = 2,
                    format = function(diagnostic)
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            }

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            ---@class PluginLspOpts
            opts = {
                autoformat = false,
            }

            -- Enable the following language servers
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                pyright = {},
                gradle_ls = {},
                jdtls = {},
                rust_analyzer = {},
                eslint = {},
                ts_ls = {},
                buf_ls = {},
                omnisharp = {},
                -- See `:help lspconfig-all` for a list of all the pre-configured LSPs

                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                        },
                    },
                },
            }

            -- Ensure the servers and tools above are installed
            --
            -- To check the current status of installed tools and/or manually install
            -- other tools, you can run
            --    :Mason
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Used to format Lua code
            })
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            require('mason-lspconfig').setup {
                ensure_installed = {}, -- explicitly set to an empty table (mason-tool-installer populates installs)
                automatic_installation = false,
                automatic_enable = {
                    exclude = {
                        'jdtls', -- requires an external plugin
                    },
                },
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for ts_ls)
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },

    {
        -- See the short description in the header of /nvim/lua/jdtls/jdtls_setup.lua
        -- for sources on how to setup nvim-jdtls.
        'mfussenegger/nvim-jdtls',
        config = function()
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'java',
                callback = function()
                    require('jdtls.jdtls_setup').setup()
                end,
            })
        end,
    },

    { -- Autoformat
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>fB',
                function()
                    require('conform').format { async = true, lsp_format = 'fallback' }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- These types don't have well standardized styleo
                local disable_filetypes = { c = true, cpp = true }
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 500,
                        lsp_format = 'fallback',
                    }
                end
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
            },
        },
    },

    { -- Autocompletion
        'saghen/blink.cmp',
        event = 'VimEnter',
        version = '1.*',
        dependencies = {
            -- Snippet Engine
            {
                'L3MON4D3/LuaSnip',
                version = '2.*',
                build = (function()
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return ' make install jsregexp'
                end)(),
                dependencies = {},
                opts = {},
            },
            'folke/lazydev.nvim',
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'default',
            },

            appearance = {
                nerd_fond_variant = 'mono',
            },

            completion = {
                documentation = { auto_show = false, auto_show_delay_ms = 500 },
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'lazydev' },
                providers = {
                    lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
                },
            },

            snippets = { preset = 'luasnip' },

            fuzzy = { implementation = 'lua' },
            signature = { enabled = true },
        },
    },

    -- Highlight todo, notes, etc
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    { -- I just use this for the status line I'm used to. I may change it later.
        'echasnovski/mini.nvim',
        config = function()
            local statusline = require 'mini.statusline'
            statusline.setup { use_icons = vim.g.have_nerd_font }

            statusline.section_location = function()
                return '%2l:%-2v'
            end
        end,
    },

    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs',

        -- Configuration
        opts = {
            ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
            -- Install any languages that are not installed
            auto_install = true,
            hightlight = {
                enable = true,
            },
            indent = { enable = true },
        },
    },

    { -- Syncronized browser markdown preview
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        build = 'cd app && yarn install',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        ft = { 'markdown' },
    },

    { -- Simple way to customize the status line
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },

        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'palenight',
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    always_show_tabline = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                        refresh_time = 16, -- ~60fps
                        events = {
                            'WinEnter',
                            'BufEnter',
                            'BufWritePost',
                            'SessionLoadPost',
                            'FileChangedShellPost',
                            'VimResized',
                            'Filetype',
                            'CursorMoved',
                            'CursorMovedI',
                            'ModeChanged',
                        },
                    },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {},
            }
        end,
    },

    -- Additional colorschemes
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000, -- Make sure it loads early
        lazy = false, -- Load immediately, not on demand
        config = function()
            require('catppuccin').setup {
                flavour = 'mocha', -- Or 'Latte', 'frappe', 'macchiato'
                background = {
                    light = 'latte',
                    dark = 'mocha',
                },
            }
        end,
    },
}

-- Set colorscheme
vim.cmd.colorscheme 'jellybeans'
