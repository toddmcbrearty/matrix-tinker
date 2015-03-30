# Collection of helper methods to deal with string case
class CaseHelpers

  @camelToHyphen: (camel) ->
    return null unless typeof camel == 'string'
    return camel.replace /([A-Z])/g, (match) ->
      return '-' + match.toLowerCase()

  @hyphenToCamel: (hyphen) ->
    return null unless typeof hyphen == 'string'
    return hyphen.replace /(\-[a-z])/g, (match) ->
      return match.toUpperCase().replace('-', '')


module.exports = CaseHelpers