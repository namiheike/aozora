# TODO currently behavios will pollute global environment, see PolymerLabs/IMD(friendly AMD) for more info

window.Aozora = {} unless window.Aozora?
Aozora = window.Aozora
Aozora.behaviors = {} unless Aozora.behaviors?
Aozora.behaviors.base =
  properties: {}

  elementInit: () ->
    unless @nodeName is 'AOZORA-APP'
      @app = Aozora.app

  removeSelfDom: () ->
    Polymer.dom(@parentNode).removeChild @
