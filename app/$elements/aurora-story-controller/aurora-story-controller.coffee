Polymer
  is: 'aurora-story-controller'
  behaviors: [
    Aurora.behaviors.base
  ]
  properties:
    node:
      type: Object
      observer: '_nodeChanged'

  ready: ->

  startScript: (node) ->
    @node = node

  jumpToNode: (node) ->
    @node = node

  jumpToNextNode: ->
    return unless @node?
    return if @node.isEnding is true

    # get the next node
    if nodeWithNextId = @app.story.getNodeById ( @node.id + 1 )
      @node = nodeWithNextId

  _nodeChanged: (newNode, oldNode) ->
    @_renderNode @node

  _renderNode: (node) ->
    @_debug "rendering node: #{JSON.stringify node}"

    # video node
    if node.type is 'video'
      @app.video.allowSkipping = node.allowSkipping
      @app.video.video = node.video
      @app.screens.select 'video'
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
