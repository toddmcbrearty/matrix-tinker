Polymer 'matrix-floating-transform',

  ###
  # Expands a card by keyframes.  Prior to calling this method, the card should be absolutely positioned above
  # a ghost element
  ###
  grow: (event) ->
    element = event.target
    dims = element?.fullSizeDims or {}

    meta = document.createElement('core-meta')
    elUtils = meta.byId('matrix-element-utils')
    ghost = elUtils.findGhost(element)
    return unless ghost?

    # make a by-value copy of the current style settings for rollback
    styleUtils = meta.byId('matrix-style-utils')
    element.fromStyle = styleUtils.copyByValue(element)

    # blocker width, to push remaining elements off the end of the row
    gridUtils = meta.byId('matrix-grid-utils')
    toEdge = gridUtils.pixelsToEdge(ghost)

    # where will the top of the elements sit?
    elementTop = gridUtils.nextAvailableTop(ghost)

    # use the bottom margin to push smooth the downward push of cells
    marginComp = gridUtils.marginCompensation(ghost)

    # new width and height provided?  If not, assume 100% width and 2x height
    dims.width ?= '100%'
    dims.marginLeft ?= '0px'
    dims.height ?= element.fromStyle.height

    ghost.keyframeStack = [
      {transition: 'all 0.3s linear', marginLeft: '0px', width: "#{toEdge + ghost.offsetWidth}px", marginBottom: "#{marginComp}px"}
      {transition: '', width: '100%', marginBottom: '0px'}
      {transition: 'all 0.3s linear', height: "#{dims.height}"},
    ]

    element.keyframeStack = [
      {
        transition: 'all 0.7s ease-in',
        left: '0px',
        width: "#{dims.width}",
        marginLeft: "#{dims.marginLeft}",
        height: "#{dims.height}",
        top: "#{elementTop}px"
      }
      {} # The ghost isn't having enough time to complete its transition...
    ]

    transformer = new MatrixFloatingTransform()
    ghost.keyframeTransition = transformer.keyframeTransition
    element.keyframeTransition = transformer.keyframeTransition

    ghost.addEventListener('webkitTransitionEnd', ghost.keyframeTransition)
    ghost.keyframeTransition(ghost)

    element.addEventListener('webkitTransitionEnd', element.keyframeTransition)
    element.keyframeTransition(element)

    element.size = 'expanded'

    return

  ###
  # Returns an element to its base size
  ###
  shrink: (event) ->
    element = event.target
    meta = document.createElement('core-meta')
    elUtils = meta.byId('matrix-element-utils')
    ghost = elUtils.findGhost(element)
    return unless ghost?

    # find the element immediately before the ghost, if one exists
    prev = ghost.previousElementSibling unless ghost.previousElementSibling?.localName isnt element.localName

    fullWidth = (parseFloat(element.fromStyle.width) or 0) + (parseFloat(element.fromStyle.marginLeft) or 0)
    isFirst = prev?.localName isnt element.localName
    available = element.parentNode.offsetWidth - ((prev?.offsetLeft or 0) + fullWidth)

    # Determine the element's target left
    col = 0 if isFirst or available <= fullWidth or prev?.size isnt 'base'
    col ?= ((prev?.offsetLeft or 0) + fullWidth) / fullWidth
    left = col * fullWidth
    left -= (parseFloat(element.fromStyle.marginLeft) or 0) unless col is 0

    # Determine the element's target top
    top = 0 if isFirst
    top ?= element.offsetTop - (parseFloat(element.fromStyle.marginTop) or 0) unless prev?.size is 'base'
    top ?= ((prev.offsetTop if available >= fullWidth) or element.offsetTop) - (parseFloat(element.fromStyle.marginTop) or 0)

    ghost.keyframeStack = [
      {
        transition: '0.6s all linear',
        width: element.fromStyle.width,
        height: element.fromStyle.height,
        marginLeft: element.fromStyle.marginLeft,
        marginTop: element.fromStyle.marginTop
      }
#      {transition: '1s all ease-out', width: @fromStyle.width, height: @fromStyle.height, marginLeft: @fromStyle.marginLeft, marginTop: @fromStyle.marginTop}
    ]

    element.keyframeStack = [
      {
        transition: "0.7s all ease-in",
        width: element.fromStyle.width,
        height: element.fromStyle.height,
        marginLeft: element.fromStyle.marginLeft
        top: "#{top}px",
        left: "#{left}px"
      },
      {transition: '', left: "0px"}
    ]

    transformer = new MatrixFloatingTransform()
    ghost.keyframeTransition = transformer.keyframeTransition
    element.keyframeTransition = transformer.keyframeTransition

    ghost.addEventListener('webkitTransitionEnd', ghost.keyframeTransition)
    ghost.keyframeTransition(ghost)

    element.addEventListener('webkitTransitionEnd', element.keyframeTransition)
    element.keyframeTransition(element)

    element.size = 'base'

  ###
  # Sequentially applies CSS transitions to an element.  Input may be an element or an instance of
  # TransitionEvent referencing the element in its @target property
  #
  # Areas for improvement:
  # - string case conversion should be moved to String.prototype or its own class
  # - keyframe management should be its own class at the element level
  ###
  keyframeTransition: (event = null) ->

    element = event if Object::toString.call(event) in ['[object HTMLElement]', '[object HTMLDivElement]']
    element ?= (event?.target if Object::toString.call(event) is "[object TransitionEvent]")

    return console.log('Unable to find element', event) unless element?
    return unless element.keyframeStack instanceof Array

    # fire end event if keyframeStack is empty now
    if element.keyframeStack.length is 0
      delete element.activeKeyframe if element.activeKeyframe?
      element.dispatchEvent(new Event('matrixScaleEnd'))
      element.removeEventListener('webkitTransitionEnd', element.keyframeTransition)
      return

    element.activeKeyframe ?= {}

    # if any properties were returned, process these.  Property names come as hyphen case, so we must convert
    if event isnt element
      prop = (word.substring(0,1).toUpperCase() + (word.substring(1) or '') for  word in (event.propertyName or '').split('-')).join('')
      prop = prop.charAt(0).toLowerCase() + prop.slice(1)
      delete element.activeKeyframe[prop] if element.activeKeyframe[prop]?

    # wait for further events to be emitted if not all transitions have completed
    return unless Object.keys(element.activeKeyframe).length is 0

    # iterate over keyframe and set properties, applying immediately where possible
    element.activeKeyframe = element.keyframeStack.shift()
    computedStyle = getComputedStyle(element)

    # computed styles are stored in hyphen-case, so we'll have to convert before testing
    meta = document.createElement('core-meta')
    stringUtils = meta.byId('matrix-string-utils')

    for key, value of element.activeKeyframe
      element.style[key] = value
      prop = stringUtils.hyphenToCamel(key)
      delete element.activeKeyframe[key] if element.style[key] is computedStyle[prop] or key is 'transition'
      # TODO: look into why this workaround is necessary
      # Since we are still position: absolute at this point, we're not computing 'width: 100%'?  weird..
      delete element.activeKeyframe[key] if key is 'width' and parseInt(computedStyle[prop]) is element.parentNode.offsetWidth

    # if no properties remain, manually re-trigger this method
    @keyframeTransition(element) if Object.keys(element.activeKeyframe).length is 0


