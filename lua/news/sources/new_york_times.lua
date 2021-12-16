local curl = require'plenary.curl'
local util = require'news.util'

local function nyt_to_article(nyt_articles)
  local result = {}
  for k, v in pairs(nyt_articles) do
    result[k] = {
      title = v.title,
      url = v.short_url,
      abstract = v.abstract,
      byline = v.byline,
      source = "New York Times",
    }
  end
  return result
end

local function fetch_headlines(args, callback)
  curl.get{
    url = 'https://api.nytimes.com/svc/topstories/v2/'..(args.section or 'home')..'.json',
    query = {
      ['api-key'] = util.get_app_id(args.api_key),
    },
    callback = function(response)
      vim.schedule(function()
        assert(response.exit == 0 and response.status < 400 and response.status >= 200, "Failed to fetch new york times articles")
        local response_table = vim.fn.json_decode(response.body)
        callback(nyt_to_article(response_table.results))
      end)
    end,
  }
  end

local function new(args)
  assert(args.api_key, "No `api_key` provided for NYT")
  return {
    fetch_headlines = function(callback) return fetch_headlines(args, callback) end,
  }
end

return {
  new = new
}

