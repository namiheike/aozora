Aurora = window.Aurora

Aurora.utilities ||= {}

Aurora.utilities.log = (message) ->
  if Aurora.env.env is 'dev'
    console.log message
