Polymer
  is: 'aozora-background'
  behaviors: [
    Aozora.behaviors.base
    Polymer.NeonAnimationRunnerBehavior
  ]
  properties:
    options:
      type: Object
      observer: '_optionsChanged'
    currentBackground:
      type: Object
    entryAnimation:
      value: 'fade-in-animation'
    exitAnimation:
      value: 'fade-out-animation'
  listeners:
    'neon-animation-finish': '_onNeonAnimationFinish'

  _optionsChanged: (newOptions, oldOptions) ->
    @newBackground = @app.resources.getResource('backgrounds', @options.name)
    if @newBackground isnt @currentBackground
      if not @currentBackground?
        @_setImageSrcAndfadeIn()
      else
        @_fadeOut()

  _setImageSrcAndfadeIn: () ->
    @currentBackground = @newBackground
    @style.backgroundImage = "url('#{@currentBackground.filePath}')"

    @_fadeIn()

  _onNeonAnimationFinish: (e) ->
    switch @_animationState
      when 'fading_in'
        @_animationState = undefined
        # TODO notify other elements that animation is finished
      when 'fading_out'
        @_setImageSrcAndfadeIn()

  _fadeOut: () ->
    @_animationState = 'fading_out'
    @playAnimation 'exit'

  _fadeIn: () ->
    @_animationState = 'fading_in'
    @playAnimation 'entry'
