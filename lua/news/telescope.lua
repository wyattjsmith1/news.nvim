-- Returns a table with:
-- `open_articles` (array of Article): Opens a list of articles in telescope.
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local string_entry_maker = require "telescope.make_entry".gen_from_string()
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local system = require'news.system'
local previewers = require'telescope.previewers.buffer_previewer'

local telescope = {}

local function generate_preview(article)
  return {
    article.title,
    article.byline,
    "",
    article.abstract,
  }
end

local function previewer(articles)
  return previewers.new_buffer_previewer {
    title = "Article",
    dyn_title = function (_, entry)
      local article = articles[entry.index]
      return article.source
    end,
    define_preview = function (self, entry, _)
      vim.api.nvim_win_set_option(self.state.winid, "wrap", true)
      vim.api.nvim_win_set_option(self.state.winid, "linebreak", true)
      local article = articles[entry.index]
      vim.api.nvim_buf_set_lines(
        self.state.bufnr,
	0, -- From the start of the buffer
	-1, -- To the end
	true,
	generate_preview(article)
      )
    end
  }
end

telescope.open_articles = function (opts, articles)
  pickers.new(opts, {
      prompt_title = "News",
      finder = finders.new_table {
        results = articles,
	entry_maker = function(article)
	  return string_entry_maker(article.title)
	end
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
	actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = articles[action_state.get_selected_entry().index]
          system.open_url(selection.url)
        end)
        return true
      end,
      previewer = previewer(articles)
    }):find()
end

return telescope

