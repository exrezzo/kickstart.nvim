# Brewfile — dipendenze esterne per questa configurazione Neovim.
#
# Uso:
#   cd ~/.config/nvim
#   brew bundle install
#
# Nota: Xcode Command Line Tools (xcode-select --install) sono richiesti per
# `make`/`cc` usati da telescope-fzf-native, nvim-treesitter (parser) e LuaSnip.
# LSP/formatter/debugger sono gestiti da Mason (vedi init.lua), non da brew.

# Editor
brew "neovim"

# CLI tool referenziati esplicitamente dalla config
brew "ripgrep"  # telescope: vimgrep_arguments + find_files (init.lua)
brew "fd"       # neo-tree: find_args (lua/kickstart/plugins/neo-tree.lua)
brew "node"     # copilot.vim + LSP node-based (ts_ls, jsonls, cucumber_language_server)
brew "tmux"     # plugin vim-tmux-navigator
brew "sqlcmd"   # plugin mssql.nvim
brew "git"      # lazy.nvim bootstrap + gitsigns (di solito già presente)

# Nerd Font per le icone (vim.g.have_nerd_font = true)
cask "font-jetbrains-mono-nerd-font"
