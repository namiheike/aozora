Polymer
  is: 'aozora-background'
  domReady: ->
    @super()

  backgroundChanged: (oldValue, newValue) ->
    return unless newValue?

    fadeOutAnimation = @app.animations.fadeOut
    fadeOutAnimation.addEventListener 'core-animation-finish', (e) =>
      e.target.removeEventListener e.type, arguments.callee

      imagePath = @app.resources.backgrounds[newValue].imagePath
      @style.backgroundImage = "url('../resources/backgrounds/#{imagePath}')"

      fadeInAnimation = @app.animations.fadeIn
      fadeInAnimation.target = @
      fadeInAnimation.play()

    fadeOutAnimation.target = @
    fadeOutAnimation.play()
