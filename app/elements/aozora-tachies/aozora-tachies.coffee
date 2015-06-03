Polymer
  is: 'aozora-tachies'
  behaviors: [ Aozora.behaviors.base ]
  properties:
    tachies:
      type: Array
      observer: '_tachiesChanged'

  ready: ->
    @elementInit()

    # monkey patch since cannot @apply custom classes from iron-flex-layout
    # TODO remove later if iron-flex-layout works fine
    @toggleClass 'horizontal', true
    @toggleClass 'layout', true
    @toggleClass 'around-justified', true

  _tachiesChanged: (newTachies, oldTachies) ->
    # lots TODO
    # say the proper transition
    # say same character's different tachies should still be the same position
