Polymer
  is: 'aurora-conversation-box'
  behaviors: [ Aurora.behaviors.base ]
  properties:
    node:
      type: Object
      observer: '_nodeChanged'
  listeners:
    tap: '_onTapOnBox'

  ready: ->

  _nodeChanged: ->
    # dirty hack for this issue: https://github.com/Polymer/polymer/issues/1716
    # and for cannot do sth like if={{ node.type == 'line' }}
    # TODO remove after issues been solved
    @nodeTypeIsLine = @node.type is 'line'
    @nodeTypeIsNarrate = @node.type is 'narrate'
    @nodeTypeIsOptions = @node.type is 'options'

  _roleNameOfLine: (line) ->

    # dirty hack for this issue: https://github.com/Polymer/polymer/issues/1716
    # TODO remove after issue been solved
    return unless line.role?

    @app.story.characters[line.role].name

  _onTapOnBox: (e) ->
    switch @node.type
      when 'line', 'narrate'
        @app.storyController.jumpToNextNode()

  _onTapOnOption: (e) ->
    # TODO IMPORTANT very bad performance, integrate sth like IndexedDB, or LoveField maybe
    getNodeById = (id) =>
      @app.story.scripts.main.filter((node) -> node.id is id)[0]

    option = e.model.option
    @app.storyController.jumpToNode getNodeById option.next

    # prevent from triggering `_onTapOnBox` method
    e.stopPropagation()
