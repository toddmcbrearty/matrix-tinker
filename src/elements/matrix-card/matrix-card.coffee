values = {}

Polymer 'matrix-card',
  ready: ->
    for attr in @attributes
      values[attr.nodeName] = attr.value

    @value = values.value


  expanded: false
  ghostVisible: false
  base: 200

  handleClick: (event, detail, sender) ->

    return if @unstuck

    unless @expanded
      @unstick()
      $(this).on 'matrixUnstickEnd', @grow
      $(this).on 'matrixScaleEnd', @stick
      return


    @unstick()
    $(this).on 'matrixScaleEnd', @stick
    $(this).on 'matrixUnstickEnd', @shrink


  #
  # Expands a card by keyframes.  Prior to calling this method, the card should be absolutely positioned above
  # a ghost element
  #
  grow: ->
    ghost = document.querySelector("#ghost-#{@id}")
    return unless ghost?

    @fromStyle = getComputedStyle(this)

    # blocker width, to push remaining elements off the end of the row
    remainingWidth = ghost.offsetWidth + (@rightOffset(ghost) * ghost.offsetWidth) + (@rightOffset(ghost) * (parseInt(ghost.style.marginLeft) or 0)) - 1

    # where will the top of the elements sit?
    elementTop = (parseInt(ghost.offsetTop) or 0) - (parseInt(ghost.style.marginTop) or 0) if @leftOffset(ghost) is 0
    elementTop ?= (parseInt(ghost.offsetTop) + parseInt(ghost.offsetHeight))

    marginOffset = (200 unless @leftOffset(ghost) is 0) or 0

    console.log @rightOffset(ghost)

    ghost.keyframeStack = [
      {transition: 'all 0.6s ease-in', marginLeft: '0px', width: "#{remainingWidth}px", marginBottom: "#{marginOffset}px"}
      {width: '100%', height: '400px', marginBottom: '0px'},
    ]

    @keyframeStack = [
      {transition: 'all 0.6s ease-out', left: '0px', width: "100%", marginLeft: '0px', height: '175px'},
      {top: "#{elementTop}px", height: '400px'}
    ]

    ghost.keyframeTransition = @keyframeTransition
    ghost.addEventListener('webkitTransitionEnd', ghost.keyframeTransition)
    ghost.keyframeTransition()

    @addEventListener('webkitTransitionEnd', @keyframeTransition)
    @keyframeTransition()

    @expanded = true

    return

  #
  #
  #
  shrink: ->
    ghost = document.querySelector("#ghost-#{@id}")
    return unless ghost?

    prev = ghost.previousElementSibling

    notFirstElementInSet = prev?.localName is @localName
    elementWidthRequired = (parseInt(@fromStyle.width) or 0) + (parseInt(@fromStyle.marginLeft) or 0)
    prevRowCapacity = (window.innerWidth - prev?.offsetLeft + prev?.offsetWidth) or 0
    prevRowCanFit = prevRowCapacity >= elementWidthRequired

    unless notFirstElementInSet or prevRowCanFit or not prev?.expanded
      top = (parseInt(@style.offsetTop) or 0)
      left = (parseInt(@style.offsetLeft) or 0)

    top ?= prev?.offsetTop
    left ?= prev?.offsetLeft + 200 + 40

    ghost.keyframeStack = [
      {transition: '0.6s all ease-out', width: '200px', height: '200px', marginLeft: '40px', marginTop: '40px'}
#      {transition: '1s all ease-out', width: @fromStyle.width, height: @fromStyle.height, marginLeft: @fromStyle.marginLeft, marginTop: @fromStyle.marginTop}
    ]

    @keyframeStack = [
      {transition: '0.6s all ease-out', width: '200px', height: '200px', marginLeft: '40px', left: "#{left}px"}
      {top: "#{top}px"}
      {transition: '', left: '0px'}
    ]

    ghost.keyframeTransition = @keyframeTransition

    ghost.addEventListener('webkitTransitionEnd', ghost.keyframeTransition)
    ghost.keyframeTransition()

    @addEventListener('webkitTransitionEnd', @keyframeTransition)
    @keyframeTransition()

    @expanded = false

  #
  # Sequentially applies CSS transitions to an element.  Input may be an element or an instance of
  # TransitionEvent referencing the element in its @target property
  #
  # Areas for improvement:
  # - string case conversion should be moved to String.prototype or its own class
  # - keyframe management should be its own class at the element level
  #
  keyframeTransition: (event = null) ->

    element = this if Object::toString.call(this) in ['[object HTMLElement]', '[object HTMLDivElement]']
    element ?= (event?.target if Object::toString.call(event) is "[object TransitionEvent]")

    return console.log('Unable to find element', event, this) unless element?
    return unless element.keyframeStack instanceof Array

    # fire end event if keyframeStack is empty now
    if element.keyframeStack.length is 0
      delete element.activeKeyframe if element.activeKeyframe?
      element.dispatchEvent(new Event('matrixScaleEnd'))
      element.removeEventListener('webkitTransitionEnd', element.keyframeTransition)
      return

    element.activeKeyframe ?= {}

    # if any properties were returned, process these.  Property names come as hyphen case, so we must convert
    if event?
      prop = (word.substring(0,1).toUpperCase() + (word.substring(1) or '') for  word in (event.propertyName or '').split('-')).join('')
      prop = prop.charAt(0).toLowerCase() + prop.slice(1)
      delete element.activeKeyframe[prop] if element.activeKeyframe[prop]?

    return unless Object.keys(element.activeKeyframe).length is 0

    # iterate over keyframe and set properties, applying immediately where possible
    element.activeKeyframe = element.keyframeStack.shift()
    computedStyle = getComputedStyle(element)

    for key, value of element.activeKeyframe
      prop = key.replace /([A-Z])/g, (match) -> return '-' + match.toLowerCase()
      element.style[key] = value
      delete element.activeKeyframe[key] if element.style[key] is computedStyle[prop] or key is 'transition'

    # if no properties remain, manually re-trigger this method
    element.keyframeTransition() if Object.keys(element.activeKeyframe).length is 0

  #
  # insert the floated card back into the grid, replacing the ghost
  #
  stick: ->

    # attempt to locate the ghost
    ghost = document.querySelector("#ghost-#{@id}")
    @typeCheck(ghost, ['HTMLElement', 'HTMLDivElement'])

    # apply the ghost's stylesheet to the element
    @mirrorStyle(ghost, this)

    # replace ghost with element and return element positioning to 'relative'
    ghost.parentNode.replaceChild(this, ghost)
    @style.transition = ''
    @style.position = 'relative'
    @style.zIndex = 'auto'
    @style.top = '0px'

    # gently resettle any shadows
    @setShadowZ(this, 1)

    # when the execution stack is finished, dispatch a new event
    setTimeout =>
      @dispatchEvent(new Event('matrixStickEnd'))
      @unstuck = false
    , 0


  #
  # allow a card to float above the grid, inserting a "ghost" placeholder to maintain its position
  #
  unstick: ->
    @unstuck = true

    # lift any paper shadow elements
    @setShadowZ(this, 5)

    # create the ghost and mirror element's computed style
    ghost = document.createElement('div')
    ghost.id = "ghost-#{@id}"
    ghost.className = 'matrix-ghost'
    ghost.style.background = "#999" if @ghostVisible
    @mirrorStyle(this, ghost)

    # detach element and float in place
    style = getComputedStyle(this)
    @style.zIndex = 10
    @style.top = "#{@offsetTop - (parseInt(style.marginTop) or 0)}px"
    @style.left = "#{@offsetLeft - (parseInt(style.marginLeft) or 0)}px"
    @style.position = 'absolute'

    # insert the ghost below element
    @parentNode.insertBefore(ghost, this)

    # after the execution stack terminates, dispatch an event
    setTimeout =>
      @dispatchEvent(new Event('matrixUnstickEnd'))
    , 0


  #
  # Attempts to apply Polymer z value to all elements in @element shadow DOM
  #
  setShadowZ: (element, value, tagName = 'paper-shadow') ->
    return unless parseInt(value) <= 5
    return unless @typeCheck(element, 'HTMLElement', false)
    return unless element.shadowRoot?
    item.setZ?(value) for item in element.shadowRoot.querySelectorAll(tagName)


  #
  # Applies all computed styles of @model to @target
  #
  # Optionally ignore blacklisted styles or only apply whitelisted styles
  #
  mirrorStyle: (model, target, blacklist = null, whitelist = null) ->
    @typeCheck model, ['HTMLElement', 'HTMLDivElement']
    @typeCheck target, ['HTMLElement', 'HTMLDivElement']

    modelStyle = getComputedStyle(model)
    targetStyle = getComputedStyle(target)

    blacklist ?= ['background', 'transition', 'position']
    whitelist ?= ['width', 'height', 'marginLeft', 'marginTop', 'padding', 'paddingLeft', 'paddingRight', 'paddingTop', 'paddingBottom']

    for prop, value of modelStyle
      continue unless typeof prop is 'string' and prop not in blacklist and targetStyle[prop] isnt value
      target.style[prop] = value if prop in whitelist


  #
  # ensures @value is an instance of @type, optionally throwing an exception if not
  #
  typeCheck: (value, types, throwError = true) ->
    valueType = Object::toString.call(value)
    types = [types] unless typeof types is 'string'
    return true if valueType.match(new RegExp("/#{type}/")) for type in types
    return false unless throwError is true
    throw new TypeError "expected [object #{types.join '/'}]; provided #{Object::toString.call(value)}"


  #
  # returns the number of elements preceding @element in the current row
  #
  leftOffset: (element) ->
    return @rowOffset(element, 'previous')


  #
  # returns the number of elements following @element in the current row
  #
  rightOffset: (element) ->
    return @rowOffset(element, 'next')


  #
  # worker method for rightOffset and leftOffset
  #
  rowOffset: (element, direction) ->
    neighbor = element["#{direction}ElementSibling"]
    return 0 unless neighbor?
    # ensure nodes are of the same type
    return 0 unless neighbor.localName is element.localName or neighbor.localName is 'matrix-card' or neighbor.className is 'matrix-ghost'

    # skip any absolutely positioned sibling
    return @rowOffset.apply(this, [neighbor, direction]) if neighbor.style.position is 'absolute'

    # ensure next node is not expanded
    return 0 if neighbor.expanded

    # target has same or lower left-offset; it's the first in its list
    return 0 if element.offsetLeft <= neighbor.offsetLeft and direction is 'previous'
    return 0 if element.offsetLeft >= neighbor.offsetLeft and direction is 'next'

    # recurse over preceding elements in row
    return @rowOffset.apply(this, [neighbor, direction]) + 1
