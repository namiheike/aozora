# TODO
# audio fade in/out
# TODO test for two bgms in close proximity to each other

Polymer
  is: 'aurora-bgm'
  behaviors: [
    Aurora.behaviors.base
  ]
  properties:
    musicName:
      type: String
      observer: '_musicNameChanged'
    music:
      type: Object
      observer: '_musicChanged'

  play: ->
    @_debug "start playing #{JSON.stringify @music}"
    @$.audioElement.play()

  pause: ->
    @$.audioElement.pause()

  _musicNameChanged: ->
    @_debug "music name changed to #{@musicName}"
    @_openToast()
    @music = @app.resources.getResource 'music', @musicName

  _musicChanged: ->
    @_debug "music changed to #{JSON.stringify @music}"
    @$.audioElement.src = @music.filePath
    @play()

  _openToast: ->
    @$.toast.open()
