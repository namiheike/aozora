Polymer
  is: 'aozora-opening-screen'
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

  _startBtnOnTap: (e) ->
    @app.story.startScript @app.resources.script[0]
    @fadeOut()

  fadeOut: ->
    @playAnimation 'exit'

  _onAnimationFinish: (e) ->
    @removeSelfDom()
