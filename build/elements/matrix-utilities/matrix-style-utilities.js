
/*
  GET INSTANCE
    meta = document.createElement('core-meta')
    styleUtils = meta.byId('matrix-style-utils')
 */
var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

Polymer('matrix-style-utilities', {

  /*
   * Applies all computed styles of @model to @target
  #
   * Optionally ignore blacklisted styles or only apply whitelisted styles
   */
  mirrorStyle: function(model, target, blacklist, whitelist) {
    var modelStyle, prop, results, targetStyle, typeUtils, value;
    if (blacklist == null) {
      blacklist = null;
    }
    if (whitelist == null) {
      whitelist = null;
    }
    typeUtils = new MatrixTypeUtilities();
    typeUtils.typeCheck(model, ['HTMLElement', 'HTMLDivElement']);
    typeUtils.typeCheck(target, ['HTMLElement', 'HTMLDivElement']);
    modelStyle = getComputedStyle(model);
    targetStyle = getComputedStyle(target);
    if (blacklist == null) {
      blacklist = ['background', 'transition', 'position'];
    }
    if (whitelist == null) {
      whitelist = ['width', 'height', 'marginLeft', 'marginTop', 'padding', 'paddingLeft', 'paddingRight', 'paddingTop', 'paddingBottom'];
    }
    results = [];
    for (prop in modelStyle) {
      value = modelStyle[prop];
      if (!(typeof prop === 'string' && indexOf.call(blacklist, prop) < 0 && targetStyle[prop] !== value)) {
        continue;
      }
      if (indexOf.call(whitelist, prop) >= 0) {
        results.push(target.style[prop] = value);
      } else {
        results.push(void 0);
      }
    }
    return results;
  },
  copyByValue: function(element) {
    var cs, key, result, value;
    cs = getComputedStyle(element);
    if (cs == null) {
      return null;
    }
    result = {};
    for (key in cs) {
      value = cs[key];
      result[key] = value;
    }
    return result;
  }
});
