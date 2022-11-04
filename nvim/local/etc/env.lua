-- 環境変数設定
-- ZSHとVIM両方に効かせる環境変数はここで設定する
-- ZSHだけでいい場合は.zshenvで設定すればよい

local config_home = vim.fn.substitute(vim.fn.stdpath("config"), "/nvim$", "", "") -- ${xdg-CONFIG-home}/nvim
local data_home = vim.fn.substitute(vim.fn.stdpath("data"), "/nvim$", "", "") -- ${xdg-DATA-home}/nvim
local cache_home = vim.fn.substitute(vim.fn.stdpath("cache"), "/nvim$", "", "") -- ${xdg-CACHE-home}/nvim
local home = vim.env.HOME
local path = {}

vim.env.XDG_CONFIG_HOME = config_home
vim.env.XDG_DATA_HOME = data_home
vim.env.XDG_CACHE_HOME = cache_home

-- 基本環境設定:
vim.env.LANG = "ja_JP.UTF-8"
vim.env.COLORTERM = "xterm-256color"
vim.env.TERM = "xterm-256color"

-- 基本のPath設定:

path = {
    "/usr/local/bin",
    "/usr/local/sbin",
    vim.env.PATH,
    "/bin",
    "/usr/bin",
    "/sbin",
    "/usr/sbin",
}

local function push_path(new)
    table.insert(path, 1, new)
end

-- dotfiles自体の在り処を環境変数として設定
local dotfiles = home .. "/.config"
vim.env.DOTFILES = dotfiles
vim.env.DOTS = dotfiles

-- Zsh:
vim.env.ZDOTDIR = home .. "/.config/zsh"

-- Groovy:
vim.env.GROOVY_HOME = "/usr/local/opt/groovy/libexec"

-- Go:
vim.env.GO111MODULE = "on"
vim.env.GOPATH = home .. "/go"
push_path("/usr/local/go/bin")
push_path(vim.env.GOPATH .. "/bin")

-- Go AWS Library
vim.env.AWS_SDK_LOAD_CONFIG = 1

-- Generator-go-project:
vim.env.GO_PROJECT_ROOT = home .. "/Projects"

-- Python:
vim.env.ASDF_PYTHON_DEFAULT_PACKAGES_FILE = config_home .. "/asdf/python/default-packages"
-- (support sqlite3 and mysql library (used by mypy, etc...))
vim.env.LDFLAGS = "-L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib"
vim.env.CPPFLAGS = "-I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include"
local library_path = vim.env.LIBRARY_PATH
if library_path then
    library_path = library_path .. ":/usr/local/opt/openssl/lib/"
else
    library_path = "/usr/local/opt/openssl/lib/"
end
vim.env.LIBRARY_PATH = library_path

-- Node:
push_path("./node_modules/.bin")

-- GNU commands:
push_path("/usr/local/opt/gzip/bin")
push_path("/usr/local/opt/openssl/bin")

-- Yarn:
push_path(home .. "/.yarn/bin")

-- Perl:
push_path(home .. "/perl5/bin")

-- Git:
push_path("/usr/local/share/git-core/contrib/diff-highlight")

-- Rg:
vim.env.RIPGREP_CONFIG_PATH = dotfiles .. "/ripgrep/config"

-- Gigamoji:
vim.env.GIGAMOJI_BG = ":space:"

-- GnuPG:
vim.env.GNUPGHOME = config_home .. "/gnupg"

-- Docker:
if vim.fn.has("mac") then
    vim.env.DOCKER_CONFIG = config_home .. "/docker-osx"
    vim.env.MACHINE_STORAGE_PATH = data_home .. "/docker-machine-osx"
elseif vim.fn.has("linux") then
    vim.env.DOCKER_CONFIG = config_home .. "/docker-linux"
    vim.env.MACHINE_STORAGE_PATH = data_home .. "/docker-machine-linux"
end

-- Rust:
push_path(home .. "/.cargo/bin")

-- ASDF:
vim.env.ASDF_DATA_DIR = data_home .. "/asdf"
push_path(vim.env.ASDF_DATA_DIR .. "/shims")

-- .local/bin
push_path(home .. "/.local/bin")
push_path(home .. "/.local/sbin")

vim.env.PATH = table.concat(path, ":")
