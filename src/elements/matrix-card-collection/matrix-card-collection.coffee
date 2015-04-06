Polymer 'matrix-card-collection',
  ready    : ->

  transform: (event, detail, sender) ->
    element = event.target

    # turn off any lingering events
  #    matrix.removeEventListener 'matrixUnstickEnd'
    $(element).off('matrixUnstickEnd matrixScaleEnd')

    # initialize a new ghost
    meta = document.querySelector('core-meta')

    # initialize a new transition element and place it in the DOM
    transformer = new MatrixFloatingTransform()

  #    element.appendChild(transformer)
  element.transformer = transformer

    if element.size is 'base'
      ghost = new MatrixGhost()
      ghost.assign(element)
      ghost.unstick()
      element.addEventListener 'matrixUnstickEnd', element.transformer.grow
      element.addEventListener 'matrixScaleEnd', element.ghost.stick
      return

    if element.size is 'expanded'
#      ghost.unstick()
#      element.addEventListener 'matrixUnstickEnd', transformer.shrink
#      element.addEventListener 'matrixScaleEnd', ghost.stick
    element.transformer.shrinkAlone(element)
      return