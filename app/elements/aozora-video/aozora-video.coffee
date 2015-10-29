Polymer
  is: 'aozora-video'
  behaviors: [ Aozora.behaviors.base ]
  properties:
    video:
      type: Object
      observer: '_videoChanged'
    allowSkipping:
      type: Boolean
  listeners:
    tap: '_onTap'

  ready: ->

  _videoChanged: (newVideo, oldVideo) ->
    @_holdBgmPlaying()
    @_show()
    # TODO wrap path building into a method of resources
    videoFileName = this.app.resources.videos[newVideo]
    videoFilePath = "../../resources/videos/#{videoFileName}"
    @$.videoElement.src = videoFilePath
    @$.videoElement.addEventListener 'ended', @_onVideoFinish.bind(@), false
    @$.videoElement.play()

  _onTap: (e) ->
    @_finish() if @allowSkipping

  _holdBgmPlaying: ->
    @app.bgm.pause()

  _onVideoFinish: (e) ->
    @_finish()

  _finish: () ->
    # stop video playing, resume bgm playing, fade out, and play next node in story

    # TODO consider if need auto resume bgm playing,
    # and what if the next node's bgm is a different one from the resuming one

    @$.videoElement.pause()
    @app.bgm.play()
    @_hide()

    @app.story.jumpToNextNode()

  _show: () ->
    # TODO fade in
    @toggleClass 'hide', false

  _hide: () ->
    @toggleClass 'hide', true
