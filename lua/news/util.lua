local result = {}


result.get_app_id = function(app_id)
  if type(app_id) == 'table' then
    local var = os.getenv(app_id.var_name or "")
    if var and var ~= "" then
      return var
    else
      return app_id.value
    end
  else
    vim.notify("app_id should no longer be a string, but a table", vim.log.levels.WARN)
    return app_id
  end
end

return result
