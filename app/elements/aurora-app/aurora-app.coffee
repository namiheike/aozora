Polymer
  is: 'aurora-app'
  behaviors: [ Aurora.behaviors.base ]

  created: ->
    window.Aurora.app = @

  ready: ->
    # init globals
    # TODO maybe register each component onto @app by themselves
    @resources = @.$.resources
    @story = @.$.story
    @background = @.$.background
    @conversationBox = @.$.conversationBox
    @tachies = @.$.tachies
    @video = @.$.video
    @openingScreen = @.$.openingScreen
    @loadingScreen = @.$.loadingScreen
    @topBar = @.$.topBar
    @bgm = @$.bgm

    # init game
    ## set page title
    # TODO resources are not loaded at this time
    # @async () -> document.title = @resources.meta.title

  openDrawer: ->
    drawerPanel = @$$ 'paper-drawer-panel'
    drawerPanel.openDrawer()
