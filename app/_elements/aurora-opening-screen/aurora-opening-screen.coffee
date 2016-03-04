Polymer
  is: 'aurora-opening-screen'
  behaviors: [
    Aurora.behaviors.base,
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

  _startBtnOnTap: (e) ->
    @_fadeOut()

  _fadeOut: ->
    @playAnimation 'exit'

  _onAnimationFinish: (e) ->
    @_log "event triggered: animation-finish"

    @app.storyController.startScript @app.story.scripts.main[0]
    @_removeSelfDom()
