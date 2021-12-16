local curl = require'plenary.curl'
local util = require'news.util'

local function news_api_to_article(nyt_articles)
  local result = {}
  for k, v in pairs(nyt_articles) do
    result[k] = {
      title = v.title,
      url = v.url,
      abstract = v.description,
      byline = v.author,
      source = v.source.name,
    }
  end
  return result
end


local function fetch_headlines(args, callback)
  curl.get{
    url = 'https://newsapi.org/v2/top-headlines',
    query = {
      apiKey = util.get_app_id(args.api_key),
      country = args.country,
    },
    callback = function(response)
      vim.schedule(function()
        assert(response.exit == 0 and response.status < 400 and response.status >= 200, "Failed to fetch News Api articles")
        local response_table = vim.fn.json_decode(response.body)
        callback(news_api_to_article(response_table.articles))
      end)
    end,
  }
end

local function new(args)
  assert(args.api_key, "No `api_key` provided for News Api")
  assert(args.country, "No `country` provided for News Api")

  return {
    fetch_headlines = function(callback) return fetch_headlines(args, callback) end,
  }
end

return { new = new }

