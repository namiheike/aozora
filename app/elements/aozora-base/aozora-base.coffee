Polymer
  is: 'aozora-base'
  domReady: ->
    # get global `app` object

    if @nodeName is 'AOZORA-APP'
      @app = @
      return

    while ( @app = @parentNode.host ).nodeName isnt 'AOZORA-APP'
      @app = @parentNode.host
