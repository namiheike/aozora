fs = require 'fs'
readline = require 'readline'
CSON = require 'cson'

reader = readline.createInterface
  input: fs.createReadStream './script.txt'

script = []
current_type = undefined
current_role = undefined

reader.on 'line', (line) ->
  if line[0] is '#'
    return

  if line is ''
    current_type = undefined
    current_role = undefined
    return

  if current_type is undefined
    # waiting for a symbol
    switch line
      when 'v'
        current_type = 'video'
      when 'n'
        current_type = 'narrate'
      # TODO
      # when 'options'
      else
        current_type = 'line'
        current_role = line
    return
  else
    new_id = script.length + 1
    node =
      id: new_id
      type: current_type
      next: new_id + 1
    switch current_type
      when 'video'
        node.video = line
      when 'narrate'
        node.text = line
      when 'line'
        node.role = current_role
        node.text = line
      # TODO
      # when 'options'

    script.push node

reader.on 'close', ->
  # remove `next` for the last node
  delete script[script.length - 1].next

  fs.writeFile './script.cson', CSON.createCSONString(script), (err) ->
    if err?
      console.log err
    else
      console.log 'DONE'
