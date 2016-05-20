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

    @loader = @$.loader
    @screens = @$.screens
    @openingScreen = @$.openingScreen
    @loadingScreen = @$.loadingScreen
    @storyScreen = @$.storyScreen
    @storyController = @$.storyController
    @background = @$.background
    @conversationBox = @$.conversationBox
    @tachies = @$.tachies
    @video = @$.video
    @topBar = @$.topBar
    @bgm = @$.bgm

  # TODO move to story screen
  openDrawer: ->
    drawerPanel = @$$ 'paper-drawer-panel'
    drawerPanel.openDrawer()

  resourcesLoad: ->
    @_log "resources loaded"

    # initializing which need config and resources being loaded
    document.title = @config.meta.name

    @screens.select('opening')

    # notify the opening screen it has been shown
    # @app.storyController.onOpeningScreenShown()

    # TODO remove loadingScreen DOM after fading out

    # triggered after all resources are ready

    # handle opening screen custom config
    # TODO maybe should be moved to event callback in `opening-screen`
    ## bgm
    # if ( music = @app.config?.custom?.opening?.bgm )?
    #   @app.bgm.musicName = music
