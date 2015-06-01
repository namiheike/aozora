# TODO coffeescript auto add `;` to generated js file, remove it via `replace`
`<script>`
Aozora = {} unless Aozora?
Aozora.behaviors = {} unless Aozora.behaviors?
Aozora.behaviors.base =
  properties: {}
  elementInit: () ->
    if @nodeName is 'AOZORA-APP'
      @app = @
      return

    while ( @app = @parentNode.host ).nodeName isnt 'AOZORA-APP'
      @app = @parentNode.host
`</script>`
