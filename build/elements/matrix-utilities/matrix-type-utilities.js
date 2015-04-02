
/*
  GET INSTANCE
    meta = document.createElement('core-meta')
    typeUtils = meta.byId('matrix-type-utils')
 */
Polymer('matrix-type-utilities', {
  ready: function() {},

  /*
   * ensures @value is an instance of @type, optionally throwing an exception if not
   */
  typeCheck: function(value, types, throwError) {
    var type, valueType;
    if (throwError == null) {
      throwError = true;
    }
    valueType = Object.prototype.toString.call(value);
    if (typeof types !== 'string') {
      types = [types];
    }
    if ((function() {
      var i, len, results;
      results = [];
      for (i = 0, len = types.length; i < len; i++) {
        type = types[i];
        results.push(valueType.match(new RegExp("/" + type + "/")));
      }
      return results;
    })()) {
      return true;
    }
    if (throwError !== true) {
      return false;
    }
    throw new TypeError("expected [object " + (types.join('/')) + "]; provided " + (Object.prototype.toString.call(value)));
  }
});
