Polymer 'matrix-sheet',
  offset: '0'
  size  : '100%'

  sequence: null
  origin  : 'left'


  ready: ->
    @style.width = ("#{@size}" if @size?) or '100%'

    if @offset.substr(@offset.length - 1) is '%'
      @offset = parseInt(window.innerWidth) * (parseFloat(@offset) / 100)

    @style[@origin] = "#{@offset}px" if @origin?
