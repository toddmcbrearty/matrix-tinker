###
  GET INSTANCE
    meta = document.createElement('core-meta')
    gridUtils = meta.byId('matrix-grid-utils')
###

Polymer 'matrix-grid-utilities',

  pixelsToEdge: (element) ->
    gridStyle = getComputedStyle(element.parentNode)
    elementStyle = getComputedStyle(element)
    usefulWidth = parseFloat(gridStyle.width) - (parseFloat(gridStyle.paddingLeft) or 0) - (parseFloat(gridStyle.paddingRight) or 0)
    widthThroughElement = element.offsetLeft + element.offsetWidth + (parseFloat(elementStyle.marginLeft) or 0)
    pixelsToEdge = usefulWidth - widthThroughElement
    return pixelsToEdge

  nextAvailableTop: (element) ->
    elementStyle = getComputedStyle(element)
    offsetTop = (parseFloat(element.offsetTop) or 0)
    offsetHeight = (parseFloat(element.offsetHeight) or 0)
    marginTop = (parseFloat(elementStyle.marginTop) or 0)
    return offsetTop - marginTop if @leftOffset(element) is 0
    return offsetTop + offsetHeight

  marginCompensation: (element) ->
    items = @leftOffset(element) + @rightOffset(element)
    remainder = (@rightOffset(element) / items unless @leftOffset(element) is 0 or @rightOffset(element) is 0) or 0
    return remainder * parseFloat(element.offsetHeight)

  ###
  # worker method for rightOffset and leftOffset
  ###
  rowOffset: (element, direction) ->
    neighbor = element["#{direction}ElementSibling"]
    return 0 unless neighbor?
    # ensure nodes are of the same type
    return 0 unless neighbor.localName is element.localName or neighbor.localName is 'matrix-card' or neighbor.className is 'matrix-ghost'

    # skip any absolutely positioned sibling
    return @rowOffset.apply(this, [neighbor, direction]) if neighbor.style.position is 'absolute'

    # ensure next node is not expanded
    return 0 if neighbor.size is 'expanded'

    # target has same or lower left-offset; it's the first in its list
    return 0 if element.offsetLeft <= neighbor.offsetLeft and direction is 'previous'
    return 0 if element.offsetLeft >= neighbor.offsetLeft and direction is 'next'

    # recurse over preceding elements in row
    return @rowOffset.apply(this, [neighbor, direction]) + 1

  ###
  # returns the number of elements preceding @element in the current row
  ###
  leftOffset: (element) ->
    return @rowOffset(element, 'previous')


  ###
  # returns the number of elements following @element in the current row
  ###
  rightOffset: (element) ->
    return @rowOffset(element, 'next')