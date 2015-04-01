Polymer
  is: 'aozora-background'
  domReady: ->
    @super()

  backgroundChanged: (oldValue, newValue) ->
    return unless newValue?

    # TODO refactor and improve animation calling
    fadeOutAnimation = @app.animations.fadeOut
    fadeOutAnimation.addEventListener 'core-animation-finish', (e) =>
      e.target.removeEventListener e.type, arguments.callee

      imagePath = @app.resources.backgrounds[newValue].imagePath
      # TODO url need to be replaced with 'resources/backgrounds...' (remove the leading '../') when building into phonegap and vulcanize is enabled
      @style.backgroundImage = "url('../resources/backgrounds/#{imagePath}')"

      fadeInAnimation = @app.animations.fadeIn
      fadeInAnimation.target = @
      fadeInAnimation.play()

    fadeOutAnimation.target = @
    fadeOutAnimation.play()
