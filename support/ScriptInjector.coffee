ElementBuilder = require './ElementBuilder.coffee'
CaseHelpers = require './CaseHelpers.coffee'
config = require './config.coffee'

# Builds injection strings from provided configuration
class ScriptInjector

  constructor: (@config) ->

    # return an array containing all injections for the given token, as specified in the configuration
  getInjection: (token) =>
    return unless @config[token]?

    # find resource attribute, if any
    for name, value of @config[token].attributes
      continue unless value == '@resource'
      resourceAttribute = name
      break

    # build element strings for each injection specified in the config
    injections = []
    for resource in @config[token].resources
      @config[token].attributes[resourceAttribute] = resource if resourceAttribute?
      element = new ElementBuilder @config[token].type
      element.pushAttribute name, value for name, value of @config[token].attributes
      element.singleton = true if @config[token].type in ['link']
      injections.push element.stringify()

    return injections.join "\n"

  getInjectionPatterns: (tokens) =>
    result = ((match: CaseHelpers.camelToHyphen(token), replacement: @getInjection(token)) for token in tokens)
    return result

module.exports = new ScriptInjector(config.injections)