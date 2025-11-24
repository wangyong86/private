return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
    },

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        config = function()
            require("nvim-tree").setup {}
        end
    }
}
