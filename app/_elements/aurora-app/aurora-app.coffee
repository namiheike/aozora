Polymer
  is: 'aurora-app'
  behaviors: [ Aurora.behaviors.base ]

  created: ->
    window.Aurora.app = @

    @config = {}
    @resources = {}
    @story = {}

  ready: ->
    # init globals
    # TODO maybe register each component onto @app by themselves

    # @loader = @.$.loader
    @storyController = @.$.storyController
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
    # TODO custom title
    # @async () -> document.title = @resources.meta.title

  openDrawer: ->
    drawerPanel = @$$ 'paper-drawer-panel'
    drawerPanel.openDrawer()
