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
    @_log "start playing #{JSON.stringify @music}"
    @$.audioElement.play()
    @_openToast()

  pause: ->
    @$.audioElement.pause()

  _musicNameChanged: ->
    @_log "music name changed to #{@musicName}"
    @music = @app.resources.getResource 'music', @musicName

  _musicChanged: ->
    @_log "music changed to #{JSON.stringify @music}"
    @$.audioElement.src = @music.filePath
    @play()

  _openToast: ->
    @$.toast.open()
