Polymer
  is: 'aurora-background'
  behaviors: [
    Aurora.behaviors.base
  ]
  properties:
    options:
      type: Object
      observer: '_optionsChanged'

  _optionsChanged: (options) ->
    # Currently setting background-image manually instead of via binding in css,
    # Because of some url-relative-path relative issue

    @_debug "optionsChanged to #{JSON.stringify options}"

    imageUrl = @app.resources.getResource('backgrounds', options.name).url
    @style.backgroundImage = "url(#{imageUrl})"
