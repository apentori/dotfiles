return {
	"arsham/arshamiser.nvim",
	dependencies = {
		"arsham/arshlib.nvim",
		"rebelot/heirline.nvim",
		"kyazdani42/nvim-web-devicons",
		"lewis6991/gitsigns.nvim",
	},
	config = function()
		-- ignore any parts you don't want to use
		--vim.cmd.colorscheme("arshamiser_light")
		require("arshamiser.heirliniser")

		_G.custom_foldtext = require("arshamiser.folding").foldtext
		vim.opt.foldtext = "v:lua.custom_foldtext()"
		-- if you want to draw a tabline:
		vim.opt.tabline = [[%{%v:lua.require("arshamiser.tabline").draw()%}]]
	end,
}
