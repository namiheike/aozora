Aurora = window.Aurora

Aurora.utilities ||= {}

Aurora.utilities.log = (message) ->
  if Aurora.env.debugging
    console.log message
