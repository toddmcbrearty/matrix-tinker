
/*
  GET INSTANCE
    meta = document.createElement('core-meta')
    stringUtils = meta.byId('matrix-string-utils')
 */
Polymer('matrix-string-utilities', {
  hyphenToCamel: function(string) {
    return string.replace(/([A-Z])/g, function(match) {
      return '-' + match.toLowerCase();
    });
  }
});
