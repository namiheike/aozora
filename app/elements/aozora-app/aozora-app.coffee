Polymer
  is: 'aozora-app'
  behaviors: [ Aozora.behaviors.base ]
  ready: ->
    @elementInit()

    # monkey patch since cannot @apply custom classes from iron-flex-layout
    # TODO remove later if iron-flex-layout works fine
    @toggleClass 'vertical', true
    @toggleClass 'layout', true
    @toggleClass 'flex', true
    @toggleClass 'fit', true

    # globals
    @resources = @.$.resources
    @story = @.$.story
    @background = @.$.background
    @conversationBox = @.$.conversationBox
    @splashScreen = @.$.splashScreen

