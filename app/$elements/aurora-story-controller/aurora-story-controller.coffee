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

    # handle opening screen custom config
    # TODO maybe should be moved to event callback in `opening-screen`
    ## bgm
    if ( music = @app.config?.custom?.opening?.bgm )?
      @app.bgm.musicName = music

  # TODO more beautiful events handling for element
  onOpeningScreenShown: ->
    # notify the animations in opening-screen
    # @app.openingScreen.onShown()

    # notify the app to show the drawer button
    @app.topBar.show()

  _nodeChanged: (newNode, oldNode) ->
    @_renderNode @node

  startScript: (node) ->
    @node = node

  jumpToNode: (node) ->
    @node = node

  jumpToNextNode: ->
    return unless @node?
    return if @node.isEnding is true

    # get the next node
    ## TODO if node got `next` option
    ## default is the one with the next incremental id
    if nodeWithNextId = @app.story.getNodeById ( @node.id + 1 )
      @node = nodeWithNextId

  _renderNode: (node) ->
    @_log "rendering node: #{JSON.stringify node}"

    # video node
    if node.type is 'video'
      @app.video.allowSkipping = node.allowSkipping
      @app.video.video = node.video
      return

    # background
    if (background = node.background)?
      switch typeof background
        # shortcut
        when 'string'
          @app.background.options = { name: background }
        when 'object'
          @app.background.options = background

    # tachies
    if (tachies = node.tachies)?
      @app.tachies.tachies = tachies

    # conversation-box
    @app.conversationBox.node = node

    # bgm
    if node.bgm?
      @app.bgm.musicName = node.bgm
