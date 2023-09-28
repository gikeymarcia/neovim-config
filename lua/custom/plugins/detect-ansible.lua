-- https://neovim.discourse.group/t/filetype-lua-autodetection-of-ansible-yaml-files-filetype-yaml-ansible/3133 

return {
  vim.filetype.add({ pattern = { [".*/tasks/.*.yml"] = "yaml.ansible" }, }),
  vim.filetype.add({ pattern = { [".*/defaults/.*.yml"] = "yaml.ansible" }, }),
  vim.filetype.add({ pattern = { [".*/main/.*.yml"] = "yaml.ansible" }, }),
  vim.filetype.add({ pattern = { [".*/vars/.*.yml"] = "yaml.ansible" }, }),
  vim.filetype.add({ pattern = { [".*/playbooks/.*.yml"] = "yaml.ansible" }, })
}
-- :h vim.filetype.match() 
