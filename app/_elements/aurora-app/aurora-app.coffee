Polymer
  is: 'aurora-app'
  behaviors: [ Aurora.behaviors.base ]

  created: ->
    window.Aurora.app = @

    @config = {}
    @resources = {}
    @story =
      # TODO IMPORTANT PERFORMANCE very bad performance, integrate IndexedDB
      getNodeById: (id, script = 'main') =>
        @story.scripts[script].filter((node) -> node.id is id)[0]
      # TODO IMPORTANT PERFORMANCE very bad performance, integrate IndexedDB
      getNodeByAnchor: (anchor, script = 'main') =>
        @story.scripts[script].filter((node) -> node.anchor is anchor)[0]

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
