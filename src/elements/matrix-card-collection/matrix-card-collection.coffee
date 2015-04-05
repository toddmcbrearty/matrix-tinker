Polymer 'matrix-card-collection',
  ready    : ->

  transform: (event, detail, sender) ->
    element = event.target

    # turn off any lingering events
    $(element).off('matrixUnstickEnd matrixScaleEnd')

    # initialize a new ghost
    meta = document.querySelector('core-meta')

    # initialize a new transition element and place it in the DOM
    transformer = new MatrixFloatingTransform()
    element.appendChild(transformer)

    if element.size is 'base'
      ghost = new MatrixGhost()
      ghost.assign(element)
      ghost.unstick()
      $(element).on 'matrixUnstickEnd', transformer.grow
      $(element).on 'matrixScaleEnd', ghost.stick
      return

    if element.size is 'expanded'
#      ghost.unstick()
#      $(element).on 'matrixUnstickEnd', transformer.shrink
#      $(element).on 'matrixScaleEnd', ghost.stick
      transformer.shrinkAlone(element)
      return