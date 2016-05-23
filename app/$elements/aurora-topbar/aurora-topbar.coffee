Polymer
  is: 'aurora-topbar'
  behaviors: [
    Aurora.behaviors.base,
    Polymer.NeonAnimationRunnerBehavior
  ]
  properties:
    animationConfig:
      value: ->
        entry: [
          {
            name: 'fade-in-animation'
            node: @
            timing:
              delay: 500
              duration: 1000
          }
        ]
  listeners:
    'show': 'onShow'
    'neon-animation-finish': '_onAnimationFinish'

  ready: () ->

  onShow: () ->
    @_log 'onShow'

    @style.opacity = 0
    @toggleClass 'hide', false
    @playAnimation 'entry'

  _onAnimationFinish: (e) ->
    @style.opacity = 1

  _onDrawerBtnTap: (e) ->
    @app.openDrawer()
