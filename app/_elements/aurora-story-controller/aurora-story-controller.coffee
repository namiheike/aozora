Polymer
  is: 'aurora-story-controller'
  behaviors: [ Aurora.behaviors.base ]
  properties:
    node:
      type: Object
      observer: '_nodeChanged'

  ready: ->

  start: ->
    # triggered after all resources are ready

    # hide the loading-screen
    @app.loadingScreen.tryFadeOut()

    # handle opening screen custom
    ## bgm
    if ( music = @app.resources.custom?.opening?.bgm )?
      @app.bgm.musicName = music

  onOpeningScreenShown: ->
    # notify the animations in opening-screen
    # @app.openingScreen.onShown()

    # notify the app to show the drawer button
    @app.topBar.show()

  _nodeChanged: (newNode, oldNode) ->
    @_renderNode @node

  startScript: (node) ->
    @node = node

  _renderNode: (node) ->
    if node.type is 'video'
      @app.video.allowSkipping = node.allowSkipping
      @app.video.video = node.video
      return

    # background
    if node.background?
      @app.background.options = node.background

    # tachies
    if node.tachies?
      @app.tachies.tachies = node.tachies

    # conversation-box
    @app.conversationBox.node = node

    # bgm
    if node.bgm?
      @app.bgm.musicName = node.bgm

  jumpToNode: (node) ->
    @node = node

  jumpToNextNode: ->
    return unless @node? and @node.next?

    # TODO IMPORTANT very bad performance, integrate IndexedDB or just use array index
    getNodeById = (id) =>
      @app.story.scripts.main.filter((node) -> node.id is id)[0]

    @node = getNodeById @node.next
