Aozora = window.Aozora

Aozora.utilities ||= {}

Aozora.utilities.log = (message) ->
  if Aozora.env.debugging
    console.log message
