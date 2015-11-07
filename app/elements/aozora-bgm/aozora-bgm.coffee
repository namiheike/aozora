# TODO
# audio fade in/out
# show the bgm title and composer ( via a toast maybe? )
# TODO test for two bgms in close proximity to each other

Polymer
  is: 'aozora-bgm'
  behaviors: [
    Aozora.behaviors.base
    Polymer.NeonAnimationRunnerBehavior
  ]
  properties:
    musicName:
      type: String
      observer: '_musicNameChanged'
    music:
      type: Object
      observer: '_musicChanged'
    showed:
      type: Boolean
      value: false
    animationConfig:
      value: ->
        entry:
          name: 'fade-in-animation'
          node: @
          timing:
            delay: 0
            duration: 500
        exit:
          name: 'fade-out-animation'
          node: @
          timing:
            delay: 0
            duration: 500

  play: ->
    @$.audioElement.play()
    @_showMusicName()

  pause: ->
    @$.audioElement.pause()

  _showMusicName: ->
    # remove arranged hiding animation in the future
    if @exitAnimationTask?
      @cancelAsync @exitAnimationTask

    unless @showed is true
      @toggleAttribute 'hidden', false
      @playAnimation 'entry'
      @showed = true

    # arrange hiding animation
    @exitAnimationTask = @async =>
      @_hideMusicName()
    , 5000

  _hideMusicName: ->
    @playAnimation 'exit'
    @async =>
      @toggleAttribute 'hidden', true
      @showed = false
    , 475 # TODO HACK should use a callback event instead of async

  _musicNameChanged: ->
    @music = @app.resources.getResource 'music', @musicName

  _musicChanged: ->
    @music.fileName
    # TODO wrap path building into a method of resources
    musicFileName = @music.fileName
    musicFilePath = "../../resources/music/#{musicFileName}"
    @$.audioElement.src = musicFilePath
    @play()
