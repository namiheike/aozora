Polymer
  is: 'aurora-opening-screen'
  behaviors: [
    Aurora.behaviors.base
  ]

  # ready: ->

  _startBtnOnTap: (e) ->
    @_log "startBtnTap triggered"

    @app.screens.select 'story'

    # TODO should be moved to `animation finish` or `select` event on `storyScreen`
    @app.storyController.startScript @app.story.scripts.main[0]
