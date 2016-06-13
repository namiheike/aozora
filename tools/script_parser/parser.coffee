# TODO separate into an individual repo
# TODO command usage via yargs

argv = require('yargs').argv

console.log argv

fs = require 'fs'
readline = require 'readline'
CSON = require 'cson'

reader = readline.createInterface
  input: fs.createReadStream argv.inputFile

script = []
current_type = undefined
current_role = undefined
current_node = undefined
current_options = undefined

reader.on 'line', (line) ->
  # comment
  if line.startsWith '#'
    return

  # conclude options block for the current node
  # wont return, will continue to parse the line
  if current_options? and not ( line.startsWith(' ') or line.startsWith("\t") )
    parsed_options = CSON.parse current_options
    for key of parsed_options
      current_node[key] = parsed_options[key]

  # line breaker means a new nodes block
  if line is ''
    current_type = undefined
    current_role = undefined
    current_node = undefined
    current_options = undefined
    return

  # first line of a nodes group block, define the type, wont really create the node
  if current_type is undefined
    # waiting for a symbol
    switch line
      when 'VIDEO', 'V'
        current_type = 'video'
      when 'NARRATION', 'N'
        current_type = 'narration'
      when 'DECISION', 'D'
        current_type = 'decision'
      else
        current_type = 'line'
        current_role = line
    return
  else
    # setting options for the last node
    if line.startsWith(' ') or line.startsWith("\t")
      current_options ?= ''
      current_options += ( line + "\n" )
      return

    # creating another node, in the same block, with the same type and character
    else
      # clear current options
      current_options = undefined

      node =
        id: script.length + 1
        type: current_type
      switch current_type
        when 'video'
          node.video = line
        when 'narration'
          node.text = line
        when 'line'
          node.role = current_role
          node.text = line
        when 'decision'
          node.text = line

      script.push node
      current_node = script[script.length - 1]

reader.on 'close', ->
  # remove `next` for the last node
  delete script[script.length - 1].next

  # create folder if doesn't exist
  mkdirp = require 'mkdirp'
  mkdirp require('path').dirname(argv.outputFile), (err) ->

    fs.writeFile argv.outputFile, CSON.createJSONString(script), (err) ->
      if err?
        console.log err
      else
        console.log 'AURORA-SCRIPT-PARSER: DONE'
