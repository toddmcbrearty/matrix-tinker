var values,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

values = {};

Polymer('matrix-card', {
  ready: function() {
    var attr, i, len, ref;
    ref = this.attributes;
    for (i = 0, len = ref.length; i < len; i++) {
      attr = ref[i];
      values[attr.nodeName] = attr.value;
    }
    return this.value = values.value;
  },
  expanded: false,
  ghostVisible: false,
  base: 200,
  handleClick: function(event, detail, sender) {
    if (this.unstuck) {
      return;
    }
    if (!this.expanded) {
      this.unstick();
      $(this).on('matrixUnstickEnd', this.grow);
      $(this).on('matrixScaleEnd', this.stick);
      return;
    }
    this.unstick();
    $(this).on('matrixScaleEnd', this.stick);
    return $(this).on('matrixUnstickEnd', this.shrink);
  },
  grow: function() {
    var elementTop, ghost, marginOffset, remainingWidth;
    ghost = document.querySelector("#ghost-" + this.id);
    if (ghost == null) {
      return;
    }
    this.fromStyle = getComputedStyle(this);
    remainingWidth = ghost.offsetWidth + (this.rightOffset(ghost) * ghost.offsetWidth) + (this.rightOffset(ghost) * (parseInt(ghost.style.marginLeft) || 0)) - 1;
    if (this.leftOffset(ghost) === 0) {
      elementTop = (parseInt(ghost.offsetTop) || 0) - (parseInt(ghost.style.marginTop) || 0);
    }
    if (elementTop == null) {
      elementTop = parseInt(ghost.offsetTop) + parseInt(ghost.offsetHeight);
    }
    marginOffset = (this.leftOffset(ghost) !== 0 ? 200 : void 0) || 0;
    console.log(this.rightOffset(ghost));
    ghost.keyframeStack = [
      {
        transition: 'all 0.6s ease-in',
        marginLeft: '0px',
        width: remainingWidth + "px",
        marginBottom: marginOffset + "px"
      }, {
        width: '100%',
        height: '400px',
        marginBottom: '0px'
      }
    ];
    this.keyframeStack = [
      {
        transition: 'all 0.6s ease-out',
        left: '0px',
        width: "100%",
        marginLeft: '0px',
        height: '175px'
      }, {
        top: elementTop + "px",
        height: '400px'
      }
    ];
    ghost.keyframeTransition = this.keyframeTransition;
    ghost.addEventListener('webkitTransitionEnd', ghost.keyframeTransition);
    ghost.keyframeTransition();
    this.addEventListener('webkitTransitionEnd', this.keyframeTransition);
    this.keyframeTransition();
    this.expanded = true;
  },
  shrink: function() {
    var elementWidthRequired, ghost, left, notFirstElementInSet, prev, prevRowCanFit, prevRowCapacity, top;
    ghost = document.querySelector("#ghost-" + this.id);
    if (ghost == null) {
      return;
    }
    prev = ghost.previousElementSibling;
    notFirstElementInSet = (prev != null ? prev.localName : void 0) === this.localName;
    elementWidthRequired = (parseInt(this.fromStyle.width) || 0) + (parseInt(this.fromStyle.marginLeft) || 0);
    prevRowCapacity = (window.innerWidth - (prev != null ? prev.offsetLeft : void 0) + (prev != null ? prev.offsetWidth : void 0)) || 0;
    prevRowCanFit = prevRowCapacity >= elementWidthRequired;
    if (!(notFirstElementInSet || prevRowCanFit || !(prev != null ? prev.expanded : void 0))) {
      top = parseInt(this.style.offsetTop) || 0;
      left = parseInt(this.style.offsetLeft) || 0;
    }
    if (top == null) {
      top = prev != null ? prev.offsetTop : void 0;
    }
    if (left == null) {
      left = (prev != null ? prev.offsetLeft : void 0) + 200 + 40;
    }
    ghost.keyframeStack = [
      {
        transition: '0.6s all ease-out',
        width: '200px',
        height: '200px',
        marginLeft: '40px',
        marginTop: '40px'
      }
    ];
    this.keyframeStack = [
      {
        transition: '0.6s all ease-out',
        width: '200px',
        height: '200px',
        marginLeft: '40px',
        left: left + "px"
      }, {
        top: top + "px"
      }, {
        transition: '',
        left: '0px'
      }
    ];
    ghost.keyframeTransition = this.keyframeTransition;
    ghost.addEventListener('webkitTransitionEnd', ghost.keyframeTransition);
    ghost.keyframeTransition();
    this.addEventListener('webkitTransitionEnd', this.keyframeTransition);
    this.keyframeTransition();
    return this.expanded = false;
  },
  keyframeTransition: function(event) {
    var computedStyle, element, key, prop, ref, ref1, value, word;
    if (event == null) {
      event = null;
    }
    if ((ref = Object.prototype.toString.call(this)) === '[object HTMLElement]' || ref === '[object HTMLDivElement]') {
      element = this;
    }
    if (element == null) {
      element = (Object.prototype.toString.call(event) === "[object TransitionEvent]" ? event != null ? event.target : void 0 : void 0);
    }
    if (element == null) {
      return console.log('Unable to find element', event, this);
    }
    if (!(element.keyframeStack instanceof Array)) {
      return;
    }
    if (element.keyframeStack.length === 0) {
      if (element.activeKeyframe != null) {
        delete element.activeKeyframe;
      }
      element.dispatchEvent(new Event('matrixScaleEnd'));
      element.removeEventListener('webkitTransitionEnd', element.keyframeTransition);
      return;
    }
    if (element.activeKeyframe == null) {
      element.activeKeyframe = {};
    }
    if (event != null) {
      prop = ((function() {
        var i, len, ref1, results;
        ref1 = (event.propertyName || '').split('-');
        results = [];
        for (i = 0, len = ref1.length; i < len; i++) {
          word = ref1[i];
          results.push(word.substring(0, 1).toUpperCase() + (word.substring(1) || ''));
        }
        return results;
      })()).join('');
      prop = prop.charAt(0).toLowerCase() + prop.slice(1);
      if (element.activeKeyframe[prop] != null) {
        delete element.activeKeyframe[prop];
      }
    }
    if (Object.keys(element.activeKeyframe).length !== 0) {
      return;
    }
    element.activeKeyframe = element.keyframeStack.shift();
    computedStyle = getComputedStyle(element);
    ref1 = element.activeKeyframe;
    for (key in ref1) {
      value = ref1[key];
      prop = key.replace(/([A-Z])/g, function(match) {
        return '-' + match.toLowerCase();
      });
      element.style[key] = value;
      if (element.style[key] === computedStyle[prop] || key === 'transition') {
        delete element.activeKeyframe[key];
      }
    }
    if (Object.keys(element.activeKeyframe).length === 0) {
      return element.keyframeTransition();
    }
  },
  stick: function() {
    var ghost;
    ghost = document.querySelector("#ghost-" + this.id);
    this.typeCheck(ghost, ['HTMLElement', 'HTMLDivElement']);
    this.mirrorStyle(ghost, this);
    ghost.parentNode.replaceChild(this, ghost);
    this.style.transition = '';
    this.style.position = 'relative';
    this.style.zIndex = 'auto';
    this.style.top = '0px';
    this.setShadowZ(this, 1);
    return setTimeout((function(_this) {
      return function() {
        _this.dispatchEvent(new Event('matrixStickEnd'));
        return _this.unstuck = false;
      };
    })(this), 0);
  },
  unstick: function() {
    var ghost, style;
    this.unstuck = true;
    this.setShadowZ(this, 5);
    ghost = document.createElement('div');
    ghost.id = "ghost-" + this.id;
    ghost.className = 'matrix-ghost';
    if (this.ghostVisible) {
      ghost.style.background = "#999";
    }
    this.mirrorStyle(this, ghost);
    style = getComputedStyle(this);
    this.style.zIndex = 10;
    this.style.top = (this.offsetTop - (parseInt(style.marginTop) || 0)) + "px";
    this.style.left = (this.offsetLeft - (parseInt(style.marginLeft) || 0)) + "px";
    this.style.position = 'absolute';
    this.parentNode.insertBefore(ghost, this);
    return setTimeout((function(_this) {
      return function() {
        return _this.dispatchEvent(new Event('matrixUnstickEnd'));
      };
    })(this), 0);
  },
  setShadowZ: function(element, value, tagName) {
    var i, item, len, ref, results;
    if (tagName == null) {
      tagName = 'paper-shadow';
    }
    if (!(parseInt(value) <= 5)) {
      return;
    }
    if (!this.typeCheck(element, 'HTMLElement', false)) {
      return;
    }
    if (element.shadowRoot == null) {
      return;
    }
    ref = element.shadowRoot.querySelectorAll(tagName);
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      item = ref[i];
      results.push(typeof item.setZ === "function" ? item.setZ(value) : void 0);
    }
    return results;
  },
  mirrorStyle: function(model, target, blacklist, whitelist) {
    var modelStyle, prop, results, targetStyle, value;
    if (blacklist == null) {
      blacklist = null;
    }
    if (whitelist == null) {
      whitelist = null;
    }
    this.typeCheck(model, ['HTMLElement', 'HTMLDivElement']);
    this.typeCheck(target, ['HTMLElement', 'HTMLDivElement']);
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
  },
  leftOffset: function(element) {
    return this.rowOffset(element, 'previous');
  },
  rightOffset: function(element) {
    return this.rowOffset(element, 'next');
  },
  rowOffset: function(element, direction) {
    var neighbor;
    neighbor = element[direction + "ElementSibling"];
    if (neighbor == null) {
      return 0;
    }
    if (!(neighbor.localName === element.localName || neighbor.localName === 'matrix-card' || neighbor.className === 'matrix-ghost')) {
      return 0;
    }
    if (neighbor.style.position === 'absolute') {
      return this.rowOffset.apply(this, [neighbor, direction]);
    }
    if (neighbor.expanded) {
      return 0;
    }
    if (element.offsetLeft <= neighbor.offsetLeft && direction === 'previous') {
      return 0;
    }
    if (element.offsetLeft >= neighbor.offsetLeft && direction === 'next') {
      return 0;
    }
    return this.rowOffset.apply(this, [neighbor, direction]) + 1;
  }
});
