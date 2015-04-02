Polymer 'matrix-card',
  ready: ->

  publish:
    transformable: true
    fullSizeDims: {}
    size: 'base'
    debug: null

  handleClick: (event) ->

    return unless @transformable

    # turn off any lingering events
    $(this).off('matrixUnstickEnd matrixScaleEnd')

    # initialize a new ghost
    meta = document.querySelector('core-meta')
    ghost = new MatrixGhost()
    ghost.assign(this)

    # initialize a new transition element and place it in the DOM
    transformer = new MatrixFloatingTransform()
    @appendChild(transformer)

    if @size is 'base'
      ghost.unstick()
      $(this).on 'matrixUnstickEnd', transformer.grow
      $(this).on 'matrixScaleEnd', ghost.stick
      return

    if @size is 'expanded'
      ghost.unstick()
      $(this).on 'matrixUnstickEnd', transformer.shrink
      $(this).on 'matrixScaleEnd', ghost.stick
      return