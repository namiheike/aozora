Aurora = window.Aurora

Aurora.utilities ||= {}

Aurora.utilities.log = (message, level = 'log') ->
  return if ( Aurora.env.env isnt 'dev' ) and ( ( level isnt 'warn' ) and ( level isnt 'error' ) )

  switch level
    when 'log'
      console.log message
    when 'debug'
      console.debug message
    when 'info'
      console.info message
    when 'warn'
      console.warn message
    when 'error'
      console.error message
