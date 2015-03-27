Polymer
  is: 'aozora-resources'

  # TODO load this list from sth like manifest file
  resourcesList: [
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
  ]

  domReady: ->
    @super()

    # perform all loaders xhr sync
    # TODO IMPORTANT Synchronous XMLHttpRequest on the main thread is deprecated because of its detrimental effects to the end user's experience.
    loaders = @.$.resourceLoaders.querySelectorAll('core-ajax')
    for loader in loaders
      xhrArgs = loader.xhrArgs or {}
      xhrArgs.sync = true
      loader.xhrArgs = xhrArgs
      resourceContent = loader.go()

  resourceLoaderResponse: (e) ->
    loader = e.currentTarget
    resourceName = loader.dataset.resourceName
    resourceContent = e.detail.response
    @[resourceName] = resourceContent
