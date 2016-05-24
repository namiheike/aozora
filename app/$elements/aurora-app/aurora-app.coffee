Polymer
  is: 'aurora-app'
  behaviors: [ Aurora.behaviors.base ]
  listeners:
    'loader.loaded': 'resourcesLoaded'

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
    # TODO register each component onto @app by themselves

    # quick access instead of @$.component
    @screens = @$.screens
    @openingScreen = @$.openingScreen
    @loadingScreen = @$.loadingScreen
    @storyScreen = @$.storyScreen
    @video = @$.video
    @bgm = @$.bgm

  # TODO move to story screen
  openDrawer: ->
    drawerPanel = @$$ 'paper-drawer-panel'
    drawerPanel.openDrawer()

  resourcesLoaded: ->
    @_log "resourcesLoaded triggered"

    # initializing which need config and resources being loaded
    document.title = @config.meta.name

    @screens.select 'opening'
    # TODO remove loadingScreen DOM after fading out
    # TODO @loadingScreen.fire 'hide'

    @openingScreen.fire 'shown'
