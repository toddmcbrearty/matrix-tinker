Polymer 'matrix-list-item',

  created: ->
    @data ?= {}

    unless @data.title?
      title = @querySelector('.title')
      @data.title = title.innerText if title?

    unless @data.body?
      body = (el.innerText for el in @querySelectorAll(':not(.title)') when el.innerText isnt '')
      meta = document.createElement('core-meta')
      stringUtils = meta.byId('matrix-string-utils')
      @data.body = stringUtils.escapeHtml body.join('')

    unless @data.icon?
      icon = @querySelector('core-icon')
      @data.icon = icon?.getAttribute('icon')