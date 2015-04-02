###
  GET INSTANCE
    meta = document.createElement('core-meta')
    stringUtils = meta.byId('matrix-string-utils')
###

Polymer 'matrix-string-utilities',

  hyphenToCamel: (string) ->
    return string.replace /([A-Z])/g, (match) ->
      return '-' + match.toLowerCase()