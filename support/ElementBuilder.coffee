# builds a string representation of a DOM element for injection and replacement.
# NOTE: no validation is applied to input data, and invalid elements may thus be
# requested without triggering any warning.
class ElementBuilder

  constructor: (@name, attributes = []) ->
    @pushAttribute(attribute.name, attribute.value) for attribute in attributes
    @singleton = false

  # adds an attribute and its (optional) value to the list
  pushAttribute: (name, value) =>
    @attributes = {} unless @attributes?
    @attributes[name] = value ? null

  # returns a string representation of attribute list, allowing for valueless attributes
  getAttributeString: =>
    result = ((("#{name}=\"#{value}\"" if value?) ? name) for name, value of @attributes)
    result.unshift null unless result.length == 0
    return result.join ' '

  # returns a string representation of the element
  stringify: =>
    closingTag = "</#{@name}>" unless @singleton
    return "<#{@name}#{@getAttributeString()}>#{@text or ''}#{closingTag or ''}"


module.exports = ElementBuilder