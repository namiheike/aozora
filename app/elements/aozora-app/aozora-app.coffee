Polymer
  is: 'aozora-app'
  behaviors: [ Aozora.behaviors.base ]
  ready: ->
    @elementInit()

    # init globals
    @resources = @.$.resources
    @story = @.$.story
    @background = @.$.background
    @conversationBox = @.$.conversationBox
    @tachies = @.$.tachies
    @video = @.$.video
    @openingScreen = @.$.openingScreen
    @loadingScreen = @.$.loadingScreen
    @bgm = @.$.bgm

    # init game
    ## set page title
    # TODO resources are not loaded at this time
    # @async () -> document.title = @resources.meta.title
