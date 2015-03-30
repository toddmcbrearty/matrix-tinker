Polymer 'matrix-drawer',
  ready: ->
    console.log 'drawer loaded'
    for attr in @attributes
      values[attr.nodeName] = attr.value