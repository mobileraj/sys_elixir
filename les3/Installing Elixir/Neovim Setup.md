I used a modified set of instructions from https://elixirforum.com/t/neovim-elixir-setup-configuration-from-scratch-guide/46310 to setup neovim on windows:
- Navigate to this path
- Run `mix deps.get`
	- If an error occurs, `mix deps.update --all
- `mix compile && mix elixir_ls.release2 -o release`
- Ensure the config file exists (`init.vim`)
	- Run `:echo stdpath('config')` in nvim; if the path returned does not exist, create it and create `init.vim` in there.
- Use your preffered plugin manager to install https://github.com/elixir-tools/elixir-tools.nvim (see their readme)
	- I used lazy.nvim (https://lazy.folke.io/installation)
- 