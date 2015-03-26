Polymer
  is: 'aozora-base'
  domReady: ->
    # get global objects
    if @nodeName isnt 'AOZORA-APP'
      while ( @app = @parentNode.host ).nodeName isnt 'AOZORA-APP'
        @app = @parentNode.host
    else
      @app = @

    @resources = @app.$.resources
