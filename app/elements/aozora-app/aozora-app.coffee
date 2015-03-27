Polymer
  is: 'aozora-app'
  domReady: ->
    @super()

    @story = @.$.story
    @background = @.$.background
    @conversationBox = @.$.conversationBox

    @story.start @resources.script[0]
