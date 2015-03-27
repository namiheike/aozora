Polymer
  is: 'aozora-app'
  domReady: ->
    @super()

    # globals
    @resources = @.$.resources
    @animations = @.$.animations
    @story = @.$.story
    @background = @.$.background
    @conversationBox = @.$.conversationBox

    @story.start @resources.script[0]
