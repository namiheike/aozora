Polymer
  is: 'aozora-splash-screen'

  startBtnOnTap: (e) ->
    @app.story.start @app.resources.script[0]
    @fadeOut()

  fadeOut: ->
    fadeOutAnimation = @app.animations.fadeOut
    fadeOutAnimation.addEventListener 'core-animation-finish', (e) =>
      e.target.removeEventListener e.type, arguments.callee
      @remove()

    fadeOutAnimation.target = @
    fadeOutAnimation.play()
