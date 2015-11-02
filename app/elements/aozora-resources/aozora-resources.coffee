Polymer
  is: 'aozora-resources'
  behaviors: [ Aozora.behaviors.base ]

  ready: ->
    # TODO load this list from sth like manifest file
    @_resourcesList = [
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
    # COMMENT app via phonegap relies on different path ( without '../' ), will be auto replaced
    for resource in @_resourcesList
      resource.fullPath = '../resources/' + resource.path

    @_unloadResourcesCount = @_resourcesList.length

  getResource: (collection, key) ->
    @[collection][key]

  # TODO
  # getResourcePath: (collection, key) ->
  # getResourcesCollection: (collection) ->

  _resourceLoaderResponse: (e) ->
    loader = e.currentTarget
    resourceName = loader.dataset.resourceName
    resourceContent = e.detail.response
    @[resourceName] = resourceContent

    @_unloadResourcesCount -= 1
    if @_unloadResourcesCount is 0
      @_allLoaded()

  _allLoaded: ->
    @app.story.start()
