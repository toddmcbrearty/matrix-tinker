###
  GET INSTANCE
    meta = document.createElement('core-meta')
    elUtils = meta.byId('matrix-element-utils')
###

Polymer 'matrix-element-utilities',
  ###
  # Locate a ghost attached to `element`
###
  findGhost: (element) ->
    ghosts = document.querySelectorAll('matrix-ghost')
    for ghost in ghosts
      return ghost if ghost.target is element

    # no ghost located
    return null

  injectGhost: (element) ->
    ghost = document.createElement('matrix-ghost')
    ghost.assign(element)

  ###
  # Attempts to apply Polymer z value to all elements in @element shadow DOM
  ###
  setShadowZ: (element, value, tagName = 'paper-shadow') ->
    return unless parseInt(value) <= 5
    return unless element.shadowRoot?
    target = element.shadowRoot.querySelector(tagName)
    target?.setZ?(value)