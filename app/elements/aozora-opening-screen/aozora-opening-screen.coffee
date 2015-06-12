Polymer
  is: 'aozora-opening-screen'
  behaviors: [
    Aozora.behaviors.base,
    Polymer.NeonAnimationRunnerBehavior
  ]
  properties:
    animationConfig:
      value: ->
        exit:
          name: 'fade-out-animation'
          node: @
  listeners:
    'neon-animation-finish': '_onAnimationFinish'

  ready: () ->
    @elementInit()

  _startBtnOnTap: (e) ->
    @_fadeOut()

  _fadeOut: ->
    @playAnimation 'exit'

  _onAnimationFinish: (e) ->
    @app.story.startScript @app.resources.script[0]
    @removeSelfDom()
