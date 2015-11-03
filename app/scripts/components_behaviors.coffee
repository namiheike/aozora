# TODO currently behavios will pollute global environment, see PolymerLabs/IMD(friendly AMD) for more info

Aozora = window.Aozora
Aozora.behaviors = {} unless Aozora.behaviors?
Aozora.behaviors.base =
  properties: {}

  ready: () ->
    # get vars like @app
    unless @nodeName is 'AOZORA-APP'
      @app = Aozora.app

  _removeSelfDom: () ->
    Polymer.dom(@parentNode).removeChild @
