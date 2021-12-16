-- In all the functions returned, `news_configuration` is the following:
-- news_configuration (table): An array of news sources. A news source is a table with these fields:
--   fetch_headlines (function()): Fetches all headlines for this source. Should return an array of Articles
--
-- In all function below, an Article is a table with the following:
--   title (string): The title of the article.
--   url (string): The url to this article.
--   abstract (string): The abstract the article provides.
--   byline (string): The credits for the article.
--   source (string): The name of the news prodider. For single news providers (e.g. NY Times, CNN) this should always be the same. For aggregate providers, this should be the true publisher if possible.
local news = {}

-- Fetches headlines for a list of news sources and returns them async.
-- Args:
--   news_configuration (table): see module documentation
--   callback (function(array(Article)): Called each time a news source returns headlines to display.
local fetch_headlines = function(news_configuration, callback)
  for _, source in pairs(news_configuration) do
    if source.fetch_headlines then
      source.fetch_headlines(callback)
    end
  end
end

-- Fetches headlines and displays them in telescope.
-- news_configuration(table): See module documentation.
-- telescope_opts(table): Any opts to forward to telescope.
local open_headlines_in_telescope = function(news_configuration, telescope_opts)
  print('Fetching news articles...')
  local telescope = require'news.telescope'
  local articles = {}

  fetch_headlines(news_configuration, function(updates)
    for _, v in pairs(updates) do
      table.insert(articles, v)
    end
    telescope.open_articles(telescope_opts, articles)
  end)
end

news.setup = function(args)
  return {
    open_headlines_in_telescope = function(callback) return open_headlines_in_telescope(args, callback) end,
    fetch_headlines = function(callback) return fetch_headlines(args, callback) end,
  }
end

return news

