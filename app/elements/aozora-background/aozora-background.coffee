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
    @elementInit()

    # monkey patch since cannot @apply custom classes from iron-flex-layout
    # TODO remove later if iron-flex-layout works fine
    @toggleClass 'vertical', true
    @toggleClass 'layout', true
    @toggleClass 'flex', true
    @toggleClass 'fit', true

  _backgroundChanged: (newValue, oldValue) ->
    @_animationState = 'fading_out'
    @_newBackground = newValue
    @playAnimation 'exit'

  _onNeonAnimationFinish: (e) ->
    switch @_animationState
      when 'fading_in'
        @_animationState = @_newBackground = undefined
      when 'fading_out'
        imagePath = @app.resources.backgrounds[@_newBackground].imagePath
        # TODO url need to be replaced with 'resources/backgrounds...' (remove the leading '../') when building into phonegap and vulcanize is enabled
        @style.backgroundImage = "url('../resources/backgrounds/#{imagePath}')"
        @_animationState = 'fading_in'
        @playAnimation 'entry'
