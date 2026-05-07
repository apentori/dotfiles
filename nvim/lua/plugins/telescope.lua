return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '*',
    dependencies = {
      'nvim-lua/plenary.nvim'}
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },
}
