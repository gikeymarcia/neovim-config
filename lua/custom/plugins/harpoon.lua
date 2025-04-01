-- Harpoon quick file swap

-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

-- disabled b/c: https://github.com/ThePrimeagen/harpoon/issues/627

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim"
  },
  init = function ()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
        end
        require("telescope.pickers").new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
        }):find()
    end
    vim.keymap.set("n", "<leader>ht", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
    vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, {desc = "Harpoon list quick menu"})

    vim.keymap.set("n", "<leader>A", function() harpoon:list():add() end, {desc = "Harpoon add file"})
    vim.keymap.set("n", "<leader>H", function() harpoon:list():select(1) end, {desc = "Harpoon buffer 1"})
    vim.keymap.set("n", "<leader>J", function() harpoon:list():select(2) end, {desc = "Harpoon buffer 2"})
    vim.keymap.set("n", "<leader>K", function() harpoon:list():select(3) end, {desc = "Harpoon buffer 3"})
    vim.keymap.set("n", "<leader>L", function() harpoon:list():select(4) end, {desc = "Harpoon buffer 4"})

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)


  end
}
