# TODO CODE CONVENTION event name should be present tense
# TODO rename component to aurora-resources-loader

Polymer
  is: 'aurora-loader'
  behaviors: [ Aurora.behaviors.base ]

  ready: ->
    @_resourcesCategories = ['backgrounds', 'images', 'music', 'sounds', 'tachies', 'videos', 'voices']
    # @_resourcesMetasPaths = @_resourcesCategories.map (category) -> "resources/#{category}/#{category}.json"

    manifests =
      config:
        path: 'config/'
        manifest: [
          { id: 'config-application', src: 'application.json' }
        ]
      story:
        path: 'story/'
        manifest: [
          { id: 'story-characters', src: 'characters.json' }
          { id: 'story-scripts-main', src: 'scripts/main.json' }
        ]

    @loadingQueue = new createjs.LoadQueue(true)
    @loadingQueue.on 'fileload', @_fileLoaded, @
    @loadingQueue.on 'complete', @_loadingComplete, @

    # load config
    @loadingQueue.loadManifest manifests.config, false
    # load story
    @loadingQueue.loadManifest manifests.story, false
    # load resources metas
    for category in @_resourcesCategories
      @loadingQueue.loadFile(
        {
          id: "resources-meta-#{category}"
          src: "resources/#{category}/#{category}.json"
        }
        , false
      )

    @_debug 'starting loading'
    @loadingQueue.load()

  _fileLoaded: (e) ->
    item = e.item
    fileId = item.id
    fileType = item.type
    filePath = item.src
    fileContent = e.result
    fileRawContent = e.rawResult

    @_debug "file loaded: #{fileId}, #{filePath}"

    # resources meta
    if fileId.startsWith 'resources-meta-'
      category = _.replace fileId, 'resources-meta-', ''
      @_resourcesMetaLoaded( category, fileContent )
      return

    # resource content
    if fileId.startsWith 'resource-'
      category = fileId.split('-')[1]
      resourceKey = _.replace fileId, "resource-#{category}-", ''

      @_resourceContentLoaded( category, resourceKey, fileType, filePath, fileContent, fileRawContent )
      return

    # others
    switch fileId
      # config
      when 'config-application'
        @app.config = fileContent
      # story
      when 'story-characters'
        @app.story.characters = fileContent
      when 'story-scripts-main'
        @app.story.scripts ||= {}
        @app.story.scripts.main = fileContent
      # else
        # TODO error handling system
        # throw 'unknown file loaded'

  _resourcesMetaLoaded: (category, metaContent) ->
    @_debug "resources meta for #{category} loaded"

    # save meta
    @app.resources[category] ||= {}
    @app.resources[category]['meta'] = metaContent

    # build manifest object for PreloadJS
    unless category is 'tachies'
      filesToListInManifest = []
      for resourceKey of metaContent
        filesToListInManifest.push
          id: "resource-#{category}-#{resourceKey}"
          src: metaContent[resourceKey].fileName
    else
      filesToListInManifest = []
      for character of metaContent
        for tachieAlter of metaContent[character]
          filesToListInManifest.push
            id: "resource-tachies-#{character}-#{tachieAlter}"
            src: "#{character}/#{metaContent[character][tachieAlter].fileName}"

    @_debug "resources manifest for #{category} builded, starting loading"
    @loadingQueue.loadManifest
      path: "resources/#{category}/"
      manifest: filesToListInManifest

  _resourceContentLoaded: ( category, key, type, path, content, rawContent ) ->
    # type is sth like createjs.LoadQueue.IMAGE

    @app.resources[category][key] ||= {}
    @app.resources[category][key]['filePath'] = path

    switch type
      when createjs.AbstractLoader.IMAGE, createjs.AbstractLoader.SOUND, createjs.AbstractLoader.VIDEO
        @app.resources[category][key]['url'] = URL.createObjectURL rawContent

    # merge other data from meta, like `displayName`
    _.merge @app.resources[category][key], @app.resources[category]['meta'][key]

  _loadingComplete: (e) ->
    @_debug 'loading queue completed'

    # create resources related methods
    @app.resources.getResource = ( category, key ) =>
      @_debug "getting resources: #{category}, #{key}"

      @app.resources[category][key]

    # notify app
    @fire 'loaded'
