Polymer
  is: 'aozora-conversation-box'
  # nodeChanged: (oldNode, newNode) ->    
    # switch node.type
    #   when 'line'
    #   when 'narrate'
    #   when 'options'

  roleName: (line) ->
    @resources.characters[line.role].name

  onTap: (e) ->
    switch @node.type
      when 'line', 'narrate'
        @app.story.toNextNode()