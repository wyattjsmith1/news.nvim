local system = {}

system.open_url = function(url)
  local command
  if vim.fn.has('mac') == 1 then
    command = 'open'
  elseif vim.fn.has("unix") == 1 then
    command = "xdg-open"
  elseif vim.fn.has('win32') == 1 then
    command = "start"
  else
    print("Unsupported system for news")
  end
  io.popen(command..' '..url)
end

return system

