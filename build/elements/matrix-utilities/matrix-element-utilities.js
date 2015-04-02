
/*
  GET INSTANCE
    meta = document.createElement('core-meta')
    elUtils = meta.byId('matrix-element-utils')
 */
Polymer('matrix-element-utilities', {

  /*
   * Locate a ghost attached to `element`
   */
  findGhost: function(element) {
    var ghost, ghosts, i, len;
    ghosts = document.querySelectorAll('matrix-ghost');
    for (i = 0, len = ghosts.length; i < len; i++) {
      ghost = ghosts[i];
      if (ghost.target === element) {
        return ghost;
      }
    }
    return null;
  },
  injectGhost: function(element) {
    var ghost;
    ghost = document.createElement('matrix-ghost');
    return ghost.assign(element);
  },

  /*
   * Attempts to apply Polymer z value to all elements in @element shadow DOM
   */
  setShadowZ: function(element, value, tagName) {
    var target;
    if (tagName == null) {
      tagName = 'paper-shadow';
    }
    if (!(parseInt(value) <= 5)) {
      return;
    }
    if (element.shadowRoot == null) {
      return;
    }
    target = element.shadowRoot.querySelector(tagName);
    return target != null ? typeof target.setZ === "function" ? target.setZ(value) : void 0 : void 0;
  }
});
