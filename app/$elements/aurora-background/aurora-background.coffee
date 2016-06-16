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

    imagePath = @app.resources.getResource('backgrounds', options.name).filePath
    @style.backgroundImage = "url(#{imagePath})"
