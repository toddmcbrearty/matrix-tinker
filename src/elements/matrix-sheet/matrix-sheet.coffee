Polymer 'matrix-sheet',
  publish:
    size: 100
    sequence: null
    origin: 'left'
    offset: '0'


  ready: ->
    @style.width = "#{(parseInt(@size) or 0)}%"

    if @offset.substr(@offset.length - 1) is '%'
      @offset = parseInt(window.innerWidth) * (parseFloat(@offset) / 100)

    @style[@origin] = "#{@offset}px"
