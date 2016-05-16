# TODO currently behavios will pollute global environment, see PolymerLabs/IMD(friendly AMD) for more info

Aurora = window.Aurora
Aurora.behaviors = {} unless Aurora.behaviors?
Aurora.behaviors.base =
  properties: {}

  created: ->
    Aurora.utilities.log "component #{@nodeName} getting created"

    unless @nodeName is 'AURORA-APP'
      @_getGlobalVars()

  ready: ->
    Aurora.utilities.log "component #{@nodeName} getting ready"    

  _getGlobalVars: ->
    @app = Aurora.app

  _removeSelfDom: ->
    Polymer.dom(@parentNode).removeChild @

  _log: (message) ->
   Aurora.utilities.log "#{@nodeName}: #{message}"
