Polymer
  is: 'aozora-tachie'
  behaviors: [
    Aozora.behaviors.base
    Polymer.NeonAnimationRunnerBehavior
  ]
  properties:
    tachie:
      type: Object
      observer: '_tachieChanged'
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

  attached: ->
    # TODO now @elementInit will be called in ready

    # put @elementInit() in attached instead of ready,
    # since it's rendered via a template and @parentNode.host is null until inserted to dom
    # @elementInit()

  _tachieChanged: (newTachie, oldTachie) ->
    if oldTachie?
      @_fadeOut()
    else
      @_changeImageSrcAndfadeIn()

  _onNeonAnimationFinish: (e) ->
    switch @_animationState
      when 'fading_in'
        @_animationState = undefined
        # TODO notify other elements that animation is finished
      when 'fading_out'
        @_changeImageSrcAndfadeIn()

  _fadeOut: () ->
    @_animationState = 'fading_out'
    @playAnimation 'exit'

  _fadeIn: () ->
    @_animationState = 'fading_in'
    @playAnimation 'entry'

  _changeImageSrcAndfadeIn: () ->
    # build image url
    # TODO wrap url building into a wrapper method in app.resources 
    characterName = Object.keys(@tachie)[0]
    tachieAlter = @tachie[characterName]
    tachieFileName = "#{characterName}_#{tachieAlter}"
    imageUrl = "../../resources/tachies/#{tachieFileName}.png"

    # show image
    # TODO animation
    @$.image.src = imageUrl

    @_fadeIn()
