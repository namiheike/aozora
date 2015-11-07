# TODO currently behavios will pollute global environment, see PolymerLabs/IMD(friendly AMD) for more info

Aozora = window.Aozora
Aozora.behaviors = {} unless Aozora.behaviors?
Aozora.behaviors.base =
  properties: {}

  created: ->
    Aozora.utilities.log "component #{@nodeName} getting created"

    unless @nodeName is 'AOZORA-APP'
      @_getGlobalVars()

  _getGlobalVars: ->
    @app = Aozora.app

  _removeSelfDom: ->
    Polymer.dom(@parentNode).removeChild @
