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
          { id: 'config-custom', src: 'custom.json' }
        ]
      story:
        path: 'story/'
        manifest: [
          { id: 'story-characters', src: 'characters.json' }
          { id: 'story-scripts-main', src: 'scripts/main.json' }
        ]

    @loadingQueue = new createjs.LoadQueue(true)
    @loadingQueue.on 'fileload', @_fileLoaded, @
    @loadingQueue.on 'complete', @_loadingCompleted, @

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

    @_log 'starting loading'
    @loadingQueue.load()

  _fileLoaded: (e) ->
    item = e.item
    fileId = item.id
    filePath = item.src
    fileContent = e.result

    @_log "file loaded: #{fileId}, #{filePath}"

    # resources meta
    if fileId.startsWith 'resources-meta-'
      category = _.replace fileId, 'resources-meta-', ''
      @_resourcesMetaLoaded( category, fileContent )
      return

    # resource content
    if fileId.startsWith 'resource-'
      category = fileId.split('-')[1]
      resourceKey = _.replace fileId, "resource-#{category}-", ''

      @_resourceContentLoaded( category, resourceKey, filePath, fileContent )
      return

    # others
    switch fileId
      # config
      when 'config-application'
        @app.config.application = fileContent
      # story
      when 'story-characters'
        @app.story.characters = fileContent
      when 'story-scripts-main'
        @app.story.scripts ?= {}
        @app.story.scripts.main = fileContent
      # else
        # TODO error handling system
        # throw 'unknown file loaded'

  _resourcesMetaLoaded: (category, metaContent) ->
    @_log "resources meta for #{category} loaded"

    # save meta
    @app.resources[category] ?= {}
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

    @_log "resources manifest for #{category} builded, starting loading"
    @loadingQueue.loadManifest
      path: "resources/#{category}/"
      manifest: filesToListInManifest

  _resourceContentLoaded: ( category, key, path, content ) ->
    @app.resources[category][key] ?= {}
    @app.resources[category][key]['filePath'] = path

    # merge other data from meta, like `displayName`
    _.merge @app.resources[category][key], @app.resources[category]['meta'][key]

  _loadingCompleted: (e) ->
    @_log 'loading queue completed'

    # create resources related methods
    @app.resources.getResource = ( category, key ) =>
      @_log "getting resources: #{category}, #{key}"

      @app.resources[category][key]

    @app.storyController.start()

  # ready: ->
  #   # TODO load this list from sth like manifest file
  #   @_resourcesCollections = [
  #     # story
  #     {
  #       name: 'meta'
  #       path: 'story/meta.json'
  #     }
  #     {
  #       name: 'script'
  #       path: 'story/script.json'
  #     }
  #     {
  #       name: 'characters'
  #       path: 'story/characters.json'
  #     }
  #     {
  #       name: 'custom'
  #       path: 'story/custom.json'
  #     }
  #     # backgrounds
  #     {
  #       name: 'backgrounds'
  #       path: 'backgrounds/backgrounds.json'
  #     }
  #     # videos
  #     {
  #       name: 'videos'
  #       path: 'videos/videos.json'
  #     }
  #     # music
  #     {
  #       name: 'music'
  #       path: 'music/music.json'
  #     }
  #     # tachies
  #     {
  #       name: 'tachies'
  #       path: 'tachies/tachies.json'
  #     }
  #   ]

  #   # TODO monkey patch since currently polymer still dont support sth like `url='../resource/{{item.path}}'`
  #   # TODO check if 1.2 support this feature
  #   # COMMENT app via phonegap relies on different path ( without '../' )
  #   for collection in @_resourcesCollections
  #     collection.fullPath = @_resourceFilePath collection.path

  #   @_unloadCollectionsCount = @_resourcesCollections.length

  # getResource: (collectionName, resourceName) ->
  #   @[collectionName][resourceName]

  # getResourcesCollection: (collectionName) ->
  #   @[collectionName]

  # _collectionLoaderResponse: (e) ->
  #   loader = e.currentTarget
  #   collectionName = loader.dataset.collectionName
  #   @[collectionName] = e.detail.response

  #   Aurora.utilities.log "resource collection #{collectionName} loaded"

  #   # build filePath for every entry in every collection
  #   switch collectionName
  #     when 'videos', 'music', 'backgrounds'
  #       @_buildFilePathsForCollection collectionName
  #     when 'tachies'
  #       @_buildFilePathsForTachies()

  #   @_unloadCollectionsCount -= 1
  #   if @_unloadCollectionsCount is 0
  #     @_allLoaded()

  # _buildFilePathsForCollection: (collectionName) ->
  #   collection = @getResourcesCollection collectionName
  #   for entryName of collection
  #     entry = collection[entryName]
  #     entry.filePath = @_resourceFilePath "#{collectionName}/#{entry.fileName}"

  # _buildFilePathsForTachies: ->
  #   collection = @getResourcesCollection 'tachies'

  #   newCollection = {}

  #   for character of collection
  #     tachies = collection[character]
  #     for tachieAlter of tachies
  #       tachie = tachies[tachieAlter]
  #       # rebuild structure
  #       resourceName = "#{character}_#{tachieAlter}"
  #       collection[resourceName] = tachie
  #       if tachie.type is 'static'
  #         # default value
  #         tachie.fileExt ||= 'png'
  #         tachie.fileName = "#{resourceName}.#{tachie.fileExt}"
  #         tachie.filePath = @_resourceFilePath "tachies/#{tachie.fileName}"
  #     delete collection[character]

  # _resourceFilePath: (relativePath) ->
  #   # relativePath like 'backgrounds/a.jpg'
  #   if window.Aurora.env.platform.isPhonegap
  #     # "../resources/#{relativePath}"
  #     # TODO figure out what happened with relative path after vulcanized
  #     "resources/#{relativePath}"
  #   else
  #     "resources/#{relativePath}"

  # _allLoaded: ->
  #   Aurora.utilities.log 'all resource collections loaded'
  #   @app.storyController.start()
