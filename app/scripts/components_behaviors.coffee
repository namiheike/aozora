# TODO currently behavios will pollute global environment, see PolymerLabs/IMD(friendly AMD) for more info

Aozora = {} unless Aozora?
Aozora.behaviors = {} unless Aozora.behaviors?
Aozora.behaviors.base =
  properties: {}

  elementInit: () ->
    # get @app in every element
    @app = @
    while @app?.nodeName isnt 'AOZORA-APP'
      @app = @app.domHost or @app.parentNode.host

  removeSelfDom: () ->
    Polymer.dom(@parentNode).removeChild @

window.Aozora = Aozora
