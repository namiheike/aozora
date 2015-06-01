Polymer
  is: 'aozora-conversation-box'
  behaviors: [ Aozora.behaviors.base ]
  properties:
    node:
      type: Object
  listeners:
    tap: 'onTapOnBox'

  ready: ->
    @elementInit()

  roleNameOfLine: (line) ->
    @app.resources.characters[line.role].name

  onTapOnBox: (e) ->
    switch @node.type
      when 'line', 'narrate'
        @app.story.jumpToNextNode()

  onTapOnOption: (e) ->
    # TODO IMPORTANT very bad performance, integrate IndexedDB
    getNodeById = (id) =>
      @app.resources.script.filter((node) -> node.id is id)[0]

    option = e.currentTarget.templateInstance.model.option
    @app.story.jumpToNode getNodeById option.next

