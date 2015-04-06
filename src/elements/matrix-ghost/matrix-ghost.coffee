Polymer 'matrix-ghost',
  ready: ->

  publish:
    target: null
    debug: false


  assign: (element) ->
    @target = element
    element.ghost = this
    meta = document.createElement('core-meta')
    @style.background = "#999" unless @debug is false
    styleUtils = meta.byId('matrix-style-utils')
    styleUtils.mirrorStyle(@target, this)
  ###
  # allow a card to float above the grid, inserting a "ghost" placeholder to maintain its position
  ###
  unstick: ->
    return unless @target?
    meta = document.createElement('core-meta')

    # raise the element
    elUtils = meta.byId('matrix-element-utils')
    elUtils.setShadowZ(@target, 5)

    # copy the element's style attributes by value
    styleUtils = meta.byId('matrix-style-utils')
    @target.beginState = styleUtils.copyByValue(@target)
    @target.working = true

    # detach element and float in place
    style = getComputedStyle(@target)
    @target.style.top = "#{@target.offsetTop - (parseInt(style.marginTop) or 0)}px"
    @target.style.left = "#{@target.offsetLeft - (parseInt(style.marginLeft) or 0)}px"
    @target.style.position = 'absolute'
    @target.style.zIndex = 10

    # insert the ghost below element
    @target.parentNode.insertBefore(this, @target)

    # after the execution stack terminates, dispatch an event
    setTimeout =>
      @target.dispatchEvent(new Event('matrixUnstickEnd'))
    , 0

  ###
  # insert the floated card back into the grid, replacing the ghost
  ###
  stick: ->
    if this.localName is 'matrix-card'
      target = this

    if this.localName is 'matrix-ghost'
      target = this.target

    meta = document.createElement('core-meta')
    elUtils = meta.byId('matrix-element-utils')
    #    ghost = elUtils.findGhost(target)

    ghost = target.ghost


    # apply the ghost's stylesheet to the element
    styleUtils = meta.byId('matrix-style-utils')
    styleUtils.mirrorStyle(ghost, target)

    # replace ghost with element and return element positioning to 'relative'
    ghost.parentNode.replaceChild(target, ghost) if ghost.parentNode?
    target.style.transition = ''
    target.style.position = target.beginState.position
    target.style.zIndex = target.beginState.zIndex
    target.style.top = 'auto'
    target.style.left = 'auto'

    # gently resettle any shadows
    elUtils.setShadowZ(target, 1)

    # when the execution stack is finished, dispatch a new event
    setTimeout =>
      target.dispatchEvent(new Event('matrixStickEnd'))
      target.working = false
    , 0