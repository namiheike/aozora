Polymer
  is: 'aozora-conversation-box'
  behaviors: [ Aozora.behaviors.base ]
  properties:
    node:
      type: Object
  listeners:
    tap: '_onTapOnBox'

  ready: ->
    @elementInit()

  _roleNameOfLine: (line) ->

    # dirty hack for this issue: https://github.com/Polymer/polymer/issues/1716
    # TODO remove after issue been solved
    return unless line.role?

    @app.resources.characters[line.role].name

  _onTapOnBox: (e) ->
    switch @node.type
      when 'line', 'narrate'
        @app.story.jumpToNextNode()

  _onTapOnOption: (e) ->
    # TODO IMPORTANT very bad performance, integrate IndexedDB
    getNodeById = (id) =>
      @app.resources.script.filter((node) -> node.id is id)[0]

    option = e.currentTarget.templateInstance.model.option
    @app.story.jumpToNode getNodeById option.next

