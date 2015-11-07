Polymer
  is: 'aozora-resources'
  behaviors: [ Aozora.behaviors.base ]

  ready: ->
    # TODO load this list from sth like manifest file
    @_resourcesCollections = [
      # story
      {
        name: 'meta'
        path: 'story/meta.json'
      }
      {
        name: 'script'
        path: 'story/script.json'
      }
      {
        name: 'characters'
        path: 'story/characters.json'
      }
      {
        name: 'custom'
        path: 'story/custom.json'
      }
      # backgrounds
      {
        name: 'backgrounds'
        path: 'backgrounds/backgrounds.json'
      }
      # videos
      {
        name: 'videos'
        path: 'videos/videos.json'
      }
      # music
      {
        name: 'music'
        path: 'music/music.json'
      }
    ]

    # TODO monkey patch since currently polymer still dont support sth like `url='../resource/{{item.path}}'`
    # TODO check if 1.2 support this feature
    # COMMENT app via phonegap relies on different path ( without '../' )
    if window.Aozora.env.isPhonegap
      for collection in @_resourcesCollections
        collection.fullPath = '../resources/' + collection.path
    else
      for collection in @_resourcesCollections
        collection.fullPath = 'resources/' + collection.path

    @_unloadCollectionsCount = @_resourcesCollections.length

  getResource: (collectionName, resourceName) ->
    @[collectionName][resourceName]

  getResourcesCollection: (collectionName) ->
    @[collectionName]

  _collectionLoaderResponse: (e) ->
    loader = e.currentTarget
    collectionName = loader.dataset.collectionName
    @[collectionName] = e.detail.response

    # build filePath for every entry in every collection
    if collectionName in [ 'videos', 'music', 'backgrounds' ]
      @_buildFilePathsForCollection collectionName

    @_unloadCollectionsCount -= 1
    if @_unloadCollectionsCount is 0
      @_allLoaded()

  _buildFilePathsForCollection: (collectionName) ->
    collection = @getResourcesCollection collectionName
    if window.Aozora.env.isPhonegap
      for entryName of collection
        entry = collection[entryName]
        entry.filePath = "../resources/#{collectionName}/#{entry.fileName}"
    else
      for entryName of collection
        entry = collection[entryName]
        entry.filePath = "resources/#{collectionName}/#{entry.fileName}"

  _allLoaded: ->
    @app.story.start()
