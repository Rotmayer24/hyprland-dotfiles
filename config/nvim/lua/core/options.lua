vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "
vim.o.backup = false
vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.updatetime = 50
vim.o.winborder = "rounded"
vim.o.wrap = false
vim.opt.mouse = "a"

local undodir = vim.fn.expand("~/.config/nvim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

vim.opt.undofile = true
vim.opt.undodir = undodir
vim.opt.encoding = "UTF-8"

local http_server_job = nil

vim.keymap.set("n", "<leader>hs", function()
    if http_server_job and vim.fn.jobwait({ http_server_job }, 0)[1] == -1 then
        vim.fn.jobstop(http_server_job)
        http_server_job = nil
        vim.notify("HTTP server stopped", vim.log.levels.INFO)
        return
    end

    http_server_job = vim.fn.jobstart(
        { "python", "-m", "http.server", "8000" },
        {
            cwd = vim.fn.getcwd(),
            detach = false,
            on_exit = function()
                http_server_job = nil
            end,
        }
    )

    if http_server_job > 0 then
        vim.notify("HTTP server started: http://localhost:8000", vim.log.levels.INFO)
    else
        vim.notify("Failed to start HTTP server", vim.log.levels.ERROR)
        http_server_job = nil
    end
end, { desc = "Toggle HTTP server" })
