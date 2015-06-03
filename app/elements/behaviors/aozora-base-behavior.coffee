# TODO coffeescript auto add `;` to generated js file, remove it via `replace`
`<script>`
Aozora = {} unless Aozora?
Aozora.behaviors = {} unless Aozora.behaviors?
Aozora.behaviors.base =
  properties: {}
  elementInit: () ->
    # get @app in every element
    @app = @
    while @app?.nodeName isnt 'AOZORA-APP'
      @app = @app.domHost or @app.parentNode.host
`</script>`
