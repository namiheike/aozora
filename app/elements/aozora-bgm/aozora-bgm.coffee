# TODO
# fade in and out
# show the bgm title and composer ( via a toast maybe? )

Polymer
  is: 'aozora-bgm'
  behaviors: [ Aozora.behaviors.base ]
  properties:
    music:
      type: String
      observer: '_musicChanged'

  ready: ->
    @elementInit()

  pause: ->
    @$.audioElement.pause()

  play: ->
    @$.audioElement.play()

  _musicChanged: (newMusic, oldMusic) ->
    # TODO wrap path building into a method of resources
    musicFileName = this.app.resources.music[newMusic]
    musicFilePath = "../../resources/music/#{musicFileName}"
    @$.audioElement.src = musicFilePath
    @play()
