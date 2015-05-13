Polymer 'matrix-card',
  ready: ->
    @style.background = @background
    icon = @querySelector('core-icon')
    toolbar = @querySelector('.toolbar')
    @toolbar = true if icon? or toolbar?

  publish:
    transformable: true
    fullSizeDims: {}
    size: 'base'
    debug: null
    background: 'white'

  created  : ->


  transform: (event) ->