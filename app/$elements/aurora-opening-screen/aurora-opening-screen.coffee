Polymer
  is: 'aurora-opening-screen'
  behaviors: [
    Aurora.behaviors.base
  ]
  listeners:
    shown: 'onShown'

  # ready: ->

  _startBtnOnTap: (e) ->
    @_log "startBtnTap triggered"

    @app.screens.select 'story'
    @app.storyScreen.fire 'shown'

  onShown: (e) ->
    # handle opening screen custom config
    ## bgm
    if ( music = @app.config?.custom?.opening?.bgm )?
      @app.bgm.musicName = music
