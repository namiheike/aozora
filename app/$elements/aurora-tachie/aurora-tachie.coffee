Polymer
  is: 'aurora-tachie'
  behaviors: [
    Aurora.behaviors.base
    Polymer.NeonAnimationRunnerBehavior
  ]
  properties:
    tachie:
      type: Object
      observer: '_tachieChanged'
    currentTachieResource:
      type: Object
    animationConfig:
      value: ->
        entry:
          name: 'fade-in-animation'
          node: @
        exit:
          name: 'fade-out-animation'
          node: @
  listeners:
    'neon-animation-finish': '_onNeonAnimationFinish'

  _tachieChanged: (newTachie, oldTachie) ->
    # build resource name
    characterName = Object.keys(@tachie)[0]
    tachieAlter = @tachie[characterName]
    resourceKey = "#{characterName}-#{tachieAlter}"

    @newTachieResource = @app.resources.getResource('tachies', resourceKey)

    if @newTachieResource isnt @currentTachieResource
      if not @currentTachieResource?
        @_setImageSrcAndfadeIn()
      else
        @_fadeOut()

  _onNeonAnimationFinish: (e) ->
    switch @_animationState
      when 'fading_in'
        @_animationState = undefined
        # TODO notify other elements that animation is finished
      when 'fading_out'
        @_setImageSrcAndfadeIn()

  _fadeOut: () ->
    @_animationState = 'fading_out'
    @playAnimation 'exit'

  _fadeIn: () ->
    @_animationState = 'fading_in'
    @playAnimation 'entry'

  _setImageSrcAndfadeIn: () ->
    @currentTachieResource = @newTachieResource
    @_fadeIn()
