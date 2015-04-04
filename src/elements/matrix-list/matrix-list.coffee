Polymer 'matrix-list',
  ready: ->
    unless @listTitle?
      listTitle = @querySelector('.title')
      @listTitle = listTitle.innerText if listTitle?

  created: ->