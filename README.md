# news-nvim
A nifty plugin to get the latest news articles in a second powered by Telescope.

# Features
- Load the latest headlines from multiple sources.
- View a snippet in Telescope's previewer.
- Load the articles in your native browser.

# Setup
### Install
Install this package with whatever package manager you want. Be sure to include [plenary](https://github.com/nvim-lua/plenary.nvim) and [telescope](https://github.com/nvim-telescope/telescope.nvim) as `news-nvim` is dependent on both.
```lua
use {
  "wyattjsmith/news.nvim",
  requires {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  }
}
```

### Configure
Configuration is done by calling `setup` and passing a list of sources:
```lua
require'news'.setup {
   -- Sources and configuration go here
}
```

Below is an examle configuration that configures all avaliable news sources:
```lua
require'news'.setup {
  require'news.sources.new_york_times'.new {
    api_key = 'nyt_api_key',
    section = 'home',
  },
  require'news.sources.news_api'.new {
    api_key = 'news_api_key',
    country = 'us'
  },
}
```

# Usage
No commands or bindings are setup by default for this. This library exposes two functions on the result of the `setup` function:
| Function | Description |
| -------- | ----------- |
| `open_headlines_in_telescope()` | This is the primary function that will be used. This fetches all news articles and puts them in telescope. |
| `fetch_headlines` | This does nothing when run, and is intended to be used by other plugins. It can be used to fetch a list of headlines. |

Both of these functions live in the result of `setup`, so you can call them like:
```lua
require'news'.setup { --[[ your config here ]]-- }.open_headlines_in_telescope()
```

Optionally, you can create a command with:
```vimscript
:command News lua require'news'.setup {}.open_headlines_in_telescope()
```

# News Sources
`news.nvim` is designed so that users can select their own news sources to fetch articles from. As of now, there are only 2, but more are always welcome!

## Built in news sources
These news sources can be used easily out-of-the-box.

#### [The New York Times](https://developer.nytimes.com/apis)
| Field | Notes |
| ----- | ----- |
| `api_key` | Required. The api key from the Ny Times website. |
| `section` | Defaults to `"home"` if none is provided. Look at the [Top Stories](https://developer.nytimes.com/docs/top-stories-product/1/routes/%7Bsection%7D.json/get) endpoint documentation for possible values |

#### [News Api](https://newsapi.org/)
| Field | Notes |
| ----- | ----- |
| `api_key` | Required. The api key from the News Api website. |
| `country` | Required. The country code to fetch articles for. See the [Top Headlines](https://newsapi.org/docs/endpoints/top-headlines) api reference for possible values.


## Adding custom news sources
Additionally, you can add your own news sources with a bit of lua. The `setup` command expects an array of tables with a `fetch_headlines` function which returns an array of `Article`s. Checkout `lua/news/init.lua` for more information.

## Contributing a source
Like many projects, contributions are always appreciated. If you want to add a news source, simply create a new file: `lua/news/sources/my_new_source.lua`. It should provide a `new` function which takes parameters for this source and returns a table with a `fetch_headlines` function. Read more details in `lua/news/init.lua`. 

