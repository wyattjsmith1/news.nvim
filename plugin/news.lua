if vim.g.loaded_news then
  return
end
vim.g.loaded_news = true
return require'news'

