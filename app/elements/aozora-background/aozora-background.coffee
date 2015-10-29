Polymer
  is: 'aozora-background'
  behaviors: [
    Aozora.behaviors.base
    Polymer.NeonAnimationRunnerBehavior
  ]
  properties:
    background:
      type: Object
      observer: '_backgroundChanged'
    entryAnimation:
      value: 'fade-in-animation'
    exitAnimation:
      value: 'fade-out-animation'
  listeners:
    'neon-animation-finish': '_onNeonAnimationFinish'

  ready: ->

  _backgroundChanged: (newValue, oldValue) ->
    if oldValue?
      @_fadeOut()
    else
      @_changeImageSrcAndfadeIn()

  _onNeonAnimationFinish: (e) ->
    switch @_animationState
      when 'fading_in'
        @_animationState = undefined
        # TODO notify other elements that animation is finished
      when 'fading_out'
        @_changeImageSrcAndfadeIn()

  _fadeOut: () ->
    @_animationState = 'fading_out'
    @playAnimation 'exit'

  _fadeIn: () ->
    @_animationState = 'fading_in'
    @playAnimation 'entry'

  _changeImageSrcAndfadeIn: () ->
    imagePath = @app.resources.backgrounds[@background].imagePath
    # TODO url need to be replaced with 'resources/backgrounds...' (remove the leading '../') when building into phonegap and vulcanize is enabled
    # TODO wrap image path building into a method of resources
    @style.backgroundImage = "url('../resources/backgrounds/#{imagePath}')"

    @_fadeIn()
