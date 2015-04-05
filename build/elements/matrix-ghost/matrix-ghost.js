Polymer('matrix-ghost', {
  ready: function() {},
  publish: {
    target: null,
    debug: false
  },
  assign: function(element) {
    var meta, styleUtils;
    this.target = element;
      element.ghost = this;
    meta = document.createElement('core-meta');
    if (this.debug !== false) {
      this.style.background = "#999";
    }
    styleUtils = meta.byId('matrix-style-utils');
    return styleUtils.mirrorStyle(this.target, this);
  },

  /*
   * allow a card to float above the grid, inserting a "ghost" placeholder to maintain its position
   */
  unstick: function() {
    var elUtils, meta, style, styleUtils;
    if (this.target == null) {
      return;
    }
    meta = document.createElement('core-meta');
    elUtils = meta.byId('matrix-element-utils');
    elUtils.setShadowZ(this.target, 5);
    styleUtils = meta.byId('matrix-style-utils');
    this.target.beginState = styleUtils.copyByValue(this.target);
    this.target.working = true;
    style = getComputedStyle(this.target);
    this.target.style.top = (this.target.offsetTop - (parseInt(style.marginTop) || 0)) + "px";
    this.target.style.left = (this.target.offsetLeft - (parseInt(style.marginLeft) || 0)) + "px";
    this.target.style.position = 'absolute';
      this.target.style.zIndex = 10;
    this.target.parentNode.insertBefore(this, this.target);
    return setTimeout((function(_this) {
      return function() {
        return _this.target.dispatchEvent(new Event('matrixUnstickEnd'));
      };
    })(this), 0);
  },

  /*
   * insert the floated card back into the grid, replacing the ghost
   */
  stick: function() {
    var elUtils, ghost, meta, styleUtils, target;
    if (this.localName === 'matrix-card') {
      target = this;
    }
    if (this.localName === 'matrix-ghost') {
      target = this.target;
    }
    meta = document.createElement('core-meta');
    elUtils = meta.byId('matrix-element-utils');
      ghost = target.ghost;
    styleUtils = meta.byId('matrix-style-utils');
    styleUtils.mirrorStyle(ghost, target);
    ghost.parentNode.replaceChild(target, ghost);
    target.style.transition = '';
      target.style.position = target.beginState.position;
      target.style.zIndex = target.beginState.zIndex;
      target.style.top = 'auto';
      target.style.left = 'auto';
    elUtils.setShadowZ(target, 1);
    return setTimeout((function(_this) {
      return function() {
        target.dispatchEvent(new Event('matrixStickEnd'));
        return target.working = false;
      };
    })(this), 0);
  }
});
