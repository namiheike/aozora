Polymer
  is: 'aozora-story'
  behaviors: [ Aozora.behaviors.base ]
  properties:
    node:
      type: Object
      observer: '_nodeChanged'

  ready: ->
    @elementInit()

  _nodeChanged: (newNode, oldNode) ->
    @_render @node

  start: (node) ->
    @node = node

  _render: (node) ->
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

  jumpToNode: (node) ->
    @node = node

  jumpToNextNode: ->
    return unless @node?

    # TODO IMPORTANT very bad performance, integrate IndexedDB
    getNodeById = (id) =>
      @app.resources.script.filter((node) -> node.id is id)[0]

    @node = getNodeById @node.next
