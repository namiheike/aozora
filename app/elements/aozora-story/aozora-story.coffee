Polymer
  is: 'aozora-story'

  nodeChanged: (oldNode, newNode) ->
    @render newNode

  start: (node) ->
    @node = node

  render: (node) ->
    # background
    if node.background?
      @app.background.background = node.background

    # conversation-box
    @app.conversationBox.node = node

  jumpToNode: (node) ->
    @node = node

  jumpToNextNode: ->
    return unless @node?

    # TODO IMPORTANT very bad performance, integrate IndexedDB
    getNodeById = (id) =>
      @app.resources.script.filter((node) -> node.id is id)[0]

    @node = getNodeById @node.next
