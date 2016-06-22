Polymer
  is: 'aurora-video'
  behaviors: [ Aurora.behaviors.base ]
  properties:
    video:
      type: Object
      observer: '_videoChanged'
    allowSkipping:
      type: Boolean
  listeners:
    tap: '_onTap'

  # ready: ->

  _videoChanged: (video) ->
    @_debug "video changed to: #{JSON.stringify video}"

    @_holdBgmPlaying()

    @$.videoElement.src = @app.resources.getResource('videos', video).url
    @$.videoElement.addEventListener 'ended', @_onVideoFinish.bind(@), false
    @$.videoElement.play()

  _onTap: (e) ->
    @_finish() if @allowSkipping

  _holdBgmPlaying: ->
    @app.bgm.pause()

  _onVideoFinish: (e) ->
    @_finish()

  _finish: () ->
    @_debug 'video playing finished'

    # stop video playing, resume bgm playing, fade out, and play next node in story

    # stop and hide video
    @$.videoElement.pause()

    # resume bgm playing
    # TODO consider if need auto resume bgm playing,
    # and what if the next node's bgm is a different one from the resuming one
    if @app.bgm?
      @app.bgm.play()

    @app.screens.select 'story'

    @app.storyController.jumpToNextNode()
