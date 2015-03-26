Polymer
  is: 'aozora-background'
  domReady: ->
    @super()

  backgroundChanged: (oldValue, newValue) ->
    # TODO this is a little dirty hack to prevent run the method before resources was loaded
    return unless @resources?

    imagePath = @resources.backgrounds[newValue]
    @style.backgroundImage = "url('../resources/backgrounds/#{imagePath}')"
