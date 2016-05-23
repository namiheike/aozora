Polymer
  is: 'aurora-story-screen'
  behaviors: [
    Aurora.behaviors.base
  ]
  listeners:
    shown: 'onShown'

  onShown: (e) ->
    @_log 'onShown'

    @app.storyController.startScript @app.story.scripts.main[0]

    # show topbar
    @app.topBar.fire 'show'
