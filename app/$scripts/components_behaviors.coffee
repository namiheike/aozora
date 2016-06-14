# TODO currently behavios will pollute global environment, see PolymerLabs/IMD(friendly AMD) for more info

Aurora = window.Aurora
Aurora.behaviors = {} unless Aurora.behaviors?
Aurora.behaviors.base =
  properties: {}

  created: ->
    @_debug "component #{@nodeName} getting created"

    unless @nodeName is 'AURORA-APP'
      @_setGlobalApp()

  ready: ->
    @_debug "component #{@nodeName} getting ready"

  _setGlobalApp: ->
    @app = Aurora.app

  _removeSelfDom: ->
    Polymer.dom(@parentNode).removeChild @

  _log: (message) ->
   Aurora.utilities.log "#{@nodeName}: #{message}"

  _debug: (message) ->
   Aurora.utilities.log "#{@nodeName}: #{message}", 'debug'

  _warn: (message) ->
   Aurora.utilities.log "#{@nodeName}: #{message}", 'warn'
