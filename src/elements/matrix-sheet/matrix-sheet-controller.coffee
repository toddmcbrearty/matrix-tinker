Polymer 'matrix-sheet-controller',
  publish:
    group: null
    minZ: 100
    reverse: true

  ready: ->
    attribute = ("[group=#{group}]" if @group?) or ''
    selector = "matrix-sheet#{attribute}"

    scope = @parentNode or document
    group = scope.querySelectorAll(selector)

    return unless group.length > 0

    sequenced = item for item in group when item.sequence?
    sequenced ?= []

    set = items: {}, keys: []

    # Add all pages with declared sequence as close to the declared sequence as practicable
    for item in sequenced
      sequence = (parseInt(item.sequence) or 0) * 10 + @minZ
      continue while set.items[sequence++]?
      set.items[sequence] = item
      set.keys.push sequence

    # add unsequenced pages, reversing the list so as to prefer elements declared earlier over later
    sequence = (Math.max.apply(this, set.keys) unless set.keys.length is 0) or @minZ

    unsequenced = (item for item in group when item.sequence? is false)
    unsequenced ?= []

    unsequenced = unsequenced.reverse() unless @reverse is false
    set.items[++sequence] = item for item in unsequenced

    # iterate over re-sequenced list, applying z-index values
    item.style.zIndex = index for index, item of set.items







