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
    @elementInit()

    # monkey patch since cannot @apply custom classes from iron-flex-layout
    # TODO remove later if iron-flex-layout works fine
    @toggleClass 'fit', true
    @toggleClass 'vertical', true
    @toggleClass 'layout', true
    @toggleClass 'center-justified', true

  _videoChanged: (newVideo, oldVideo) ->
    @toggleClass 'hide', false
    # TODO wrap path building into a method of resources
    videoFileName = this.app.resources.videos[newVideo]
    videoFilePath = "../../resources/videos/#{videoFileName}"
    @$.videoElement.src = videoFilePath
    @$.videoElement.addEventListener 'ended', @_onVideoFinish.bind(@), false
    @$.videoElement.play()

  _onTap: (e) ->
    @_hide() if @allowSkipping

  _onVideoFinish: (e) ->
    @_hide()

  _hide: () ->
    # fade out and play next node in story
    @toggleClass 'hide', true
    @app.story.jumpToNextNode()
