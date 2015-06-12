Polymer
  is: 'aozora-topbar'
  behaviors: [
    Aozora.behaviors.base,
    Polymer.NeonAnimationRunnerBehavior
  ]
  properties:
    animationConfig:
      value: ->
        show: [
          {
            name: 'fade-in-animation'
            node: @
            timing:
              delay: 500
              duration: 1000
          }
        ]
  listeners:
    'neon-animation-finish': '_onAnimationFinish'

  ready: () ->
    @elementInit()

  show: () ->
    @style.opacity = 0
    @toggleClass 'hide', false
    @playAnimation 'show'

  _onAnimationFinish: (e) ->
    @style.opacity = 1

  _onDrawerBtnTap: (e) ->
    @app.openDrawer()
