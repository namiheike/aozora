Polymer
  is: 'aurora-loader'
  behaviors: [ Aurora.behaviors.base ]

  ready: ->
    manifests =
      config:
        path: 'config/'
        manifest: [
          { src: 'application.json' }
        ]

    loadingQueue = new createjs.LoadQueue(true)
    loadingQueue.loadManifest manifests.config, false
    loadingQueue.on 'fileload', @_fileLoaded, @
    loadingQueue.on 'complete', @_loadingCompleted, @
    loadingQueue.load()

  _fileLoaded: (e) ->
    item = e.item

    switch item.id
      when 'config/application.json'
        @app.config.application = item.result
      else
        # TODO error handling system
        throw 'unknown file loaded'

  _loadingCompleted: (e) ->
    Aurora.utilities.log 'AOZORA-LOADER: loading queue completed'
    @app.story.start()

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
  #   @app.story.start()
