Polymer
  is: 'aurora-story-screen'
  behaviors: [
    Aurora.behaviors.base
    Polymer.NeonAnimationRunnerBehavior
  ]
  listeners:
    shown: 'onShown'
  properties:
    config: Object
    animationConfig:
      value: ->
        'show-topbar':
          name: 'fade-in-animation'
          node: @$.topBar
          timing:
            delay: 1000

  ready: ->
    # register components on @app
    @app.storyController = @$.storyController
    @app.background = @$.background
    @app.conversationBox = @$.conversationBox
    @app.tachies = @$.tachies
    @app.topBar = @$.topBar

  onShown: (e) ->
    @_debug 'onShown'

    @app.storyController.startScript @app.story.scripts.main[0]

    # show topbar
    @playAnimation 'show-topbar'
