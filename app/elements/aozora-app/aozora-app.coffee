Polymer
  is: 'aozora-app'
  behaviors: [ Aozora.behaviors.base ]

  created: ->
    window.Aozora.app = @

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
    @topBar = @.$.topBar

    # init game
    ## set page title
    # TODO resources are not loaded at this time
    # @async () -> document.title = @resources.meta.title

  openDrawer: ->
    drawerPanel = @$$ 'paper-drawer-panel'
    drawerPanel.openDrawer()
