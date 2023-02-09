P = function(value)
  print(vim.inspect(value))
  return value
end

RELOAD = function(name)
  return require("plenary.reload").reload_module(name)
end

R = function(name)
  RELOAD(name)
  return require(name)
end
