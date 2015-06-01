Polymer
  is: 'aozora-splash-screen'
  behaviors: [
    Aozora.behaviors.base,
    Polymer.NeonAnimationRunnerBehavior
  ]
  properties:
    exitAnimation:
      value: 'fade-out-animation'
  listeners:
    'neon-animation-finish': '_onAnimationFinish'

  ready: () ->
    @elementInit()

    # monkey patch since cannot @apply custom classes from iron-flex-layout
    # TODO remove later if iron-flex-layout works fine
    @toggleClass 'vertical', true
    @toggleClass 'layout', true
    @toggleClass 'flex', true
    @toggleClass 'fit', true
    @toggleClass 'center', true
    @toggleClass 'center-justified', true

  startBtnOnTap: (e) ->
    @app.story.start @app.resources.script[0]
    @fadeOut()

  fadeOut: ->
    @playAnimation 'exit'

  _onAnimationFinish: (e) ->
    Polymer.dom(@app.root).removeChild(@app.splashScreen)
