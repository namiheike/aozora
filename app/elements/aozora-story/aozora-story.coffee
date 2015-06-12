Polymer
  is: 'aozora-story'
  behaviors: [ Aozora.behaviors.base ]
  properties:
    node:
      type: Object
      observer: '_nodeChanged'

  ready: ->
    @elementInit()

  start: ->
    # triggered after all resources are ready

    # hide the loading-screen
    @app.loadingScreen.tryFadeOut()

    # handle opening screen custom
    ## bgm
    if ( music = @app.resources.custom?.opening?.bgm )?
      @app.bgm.music = music

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
      @app.background.background = node.background

    # tachies
    if node.tachies?
      @app.tachies.tachies = node.tachies

    # conversation-box
    @node.typeIsLine = @node.type is 'line'
    @node.typeIsNarrate = @node.type is 'narrate'
    @node.typeIsOptions = @node.type is 'options'
    @app.conversationBox.node = node

    # bgm
    if node.bgm?
      @app.bgm.music = node.bgm

  jumpToNode: (node) ->
    @node = node

  jumpToNextNode: ->
    return unless @node?

    # TODO IMPORTANT very bad performance, integrate IndexedDB or just use array index
    getNodeById = (id) =>
      @app.resources.script.filter((node) -> node.id is id)[0]

    @node = getNodeById @node.next
