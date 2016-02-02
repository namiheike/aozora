Polymer
  is: 'aurora-loading-screen'
  behaviors: [
    Aurora.behaviors.base,
    Polymer.NeonAnimationRunnerBehavior
  ]
  properties:
    animationConfig:
      value: ->
        show: [
          {
            name: 'fade-in-animation'
            node: @$.auroraLogo
            timing:
              duration: 500
          },{
            name: 'fade-in-animation'
            node: @$.spinner
            timing:
              delay: 300
          }
        ]
        exit:
          name: 'fade-out-animation'
          node: @
          timing:
            duration: 400

  listeners:
    'neon-animation-finish': '_onAnimationFinish'

  ready: () ->

    @_waitedEnoughTimeBeforeFadeOut = false
    @_triedToFadeOut = false
    @async =>
      if @_triedToFadeOut
        @fadeOut()
        return
      else
        @_waitedEnoughTimeBeforeFadeOut = true
    , 1000

  attached: ->
    @playAnimation 'show'

  tryFadeOut: ->
    if @_waitedEnoughTimeBeforeFadeOut
      @fadeOut()
      return
    else
      @_triedToFadeOut = true

  fadeOut: ->
    @_animationStatus = 'fading_out'
    @playAnimation 'exit'

  _onAnimationFinish: (e) ->
    return unless @_animationStatus is 'fading_out'

    # notify the opening screen it has been shown
    @app.story.onOpeningScreenShown()

    @_removeSelfDom()
