###
  GET INSTANCE
    meta = document.createElement('core-meta')
    styleUtils = meta.byId('matrix-style-utils')
###

Polymer 'matrix-style-utilities',

  ###
  # Applies all computed styles of @model to @target
  #
  # Optionally ignore blacklisted styles or only apply whitelisted styles
  ###
  mirrorStyle: (model, target, blacklist = null, whitelist = null) ->
#    meta = document.createElement('core-meta')
#    console.log meta.list
#    typeUtils = meta.byId('matrix-type-utils')
    typeUtils = new MatrixTypeUtilities()
    typeUtils.typeCheck model, ['HTMLElement', 'HTMLDivElement']
    typeUtils.typeCheck target, ['HTMLElement', 'HTMLDivElement']

    modelStyle = getComputedStyle(model)
    targetStyle = getComputedStyle(target)

    blacklist ?= ['background', 'transition', 'position']
    whitelist ?= ['width', 'height', 'marginLeft', 'marginTop', 'padding', 'paddingLeft', 'paddingRight', 'paddingTop', 'paddingBottom']

    for prop, value of modelStyle
      continue unless typeof prop is 'string' and prop not in blacklist and targetStyle[prop] isnt value
      target.style[prop] = value if prop in whitelist

  copyByValue: (element) ->
    cs = getComputedStyle(element)
    return null unless cs?
    result = {}
    result[key] = value for key, value of cs
    return result