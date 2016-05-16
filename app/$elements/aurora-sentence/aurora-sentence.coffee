Polymer
  is: 'aurora-sentence'
  behaviors: [ Aurora.behaviors.base ]
  properties:
    sentence:
      type: String
      observer: '_onSentenceChanged'

  attached: ->
    # TODO now @elementInit will be called in ready

    # put @elementInit() in attached instead of ready,
    # since it's rendered via a template and @parentNode.host is null until inserted to dom

    # TODO figure out how to determine the future parentNode of this element in `ready` instead of `attached`

    # @elementInit()

  _onSentenceChanged: (newSentence) ->
