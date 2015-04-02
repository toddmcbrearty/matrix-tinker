###
  GET INSTANCE
    meta = document.createElement('core-meta')
    typeUtils = meta.byId('matrix-type-utils')
###

Polymer 'matrix-type-utilities',
  ready: ->

  ###
  # ensures @value is an instance of @type, optionally throwing an exception if not
  ###
  typeCheck: (value, types, throwError = true) ->
    valueType = Object::toString.call(value)
    types = [types] unless typeof types is 'string'
    return true if valueType.match(new RegExp("/#{type}/")) for type in types
    return false unless throwError is true
    throw new TypeError "expected [object #{types.join '/'}]; provided #{Object::toString.call(value)}"