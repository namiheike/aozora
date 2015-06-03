Polymer
  is: 'aozora-resources'
  behaviors: [ Aozora.behaviors.base ]

  ready: ->
    @elementInit()

    # TODO load this list from sth like manifest file
    @resourcesList = [
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
    ]

    # TODO monkey patch since currently polymer still dont support sth like `url='../resource/{{item.path}}'`
    for resource in @resourcesList
      resource.fullPath = '../resources/' + resource.path

  resourceLoaderResponse: (e) ->
    loader = e.currentTarget
    resourceName = loader.dataset.resourceName
    resourceContent = e.detail.response
    @[resourceName] = resourceContent
