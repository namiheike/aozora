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
    @nodeTypeIsDecision = @node.type is 'decision'

  _roleNameOfLine: (line) ->

    # dirty hack for this issue: https://github.com/Polymer/polymer/issues/1716
    # TODO remove after issue been solved
    return unless line.role?

    if ( character = @app.story.characters[line.role] )?
      character.name
    else
      line.role

  _onTapOnBox: (e) ->
    switch @node.type
      when 'line', 'narrate'
        @app.storyController.jumpToNextNode()

  _onChoicesMenuSelect: (e) ->
    choice = e.currentTarget.selectedItem.choice

    @app.storyController.jumpToNode @app.story.getNodeByAnchor choice.ref

    # prevent from triggering `_onTapOnBox` method
    e.stopPropagation()
