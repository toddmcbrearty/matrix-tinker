Polymer('matrix-floating-transform', {

  /*
   * Expands a card by keyframes.  Prior to calling this method, the card should be absolutely positioned above
   * a ghost element
   */
  grow: function(event) {
      var dims, element, elementTop, ghost, gridUtils, marginComp, meta, styleUtils, toEdge, transformer;
    element = event.target;
    dims = (element != null ? element.fullSizeDims : void 0) || {};
    meta = document.createElement('core-meta');
      ghost = element.ghost;
    if (ghost == null) {
      return;
    }
    styleUtils = meta.byId('matrix-style-utils');
    element.fromStyle = styleUtils.copyByValue(element);
    gridUtils = meta.byId('matrix-grid-utils');
    toEdge = gridUtils.pixelsToEdge(ghost);
    elementTop = gridUtils.nextAvailableTop(ghost);
    marginComp = gridUtils.marginCompensation(ghost);
    if (dims.width == null) {
      dims.width = '100%';
    }
    if (dims.marginLeft == null) {
      dims.marginLeft = '0px';
    }
    if (dims.height == null) {
      dims.height = element.fromStyle.height;
    }
    ghost.keyframeStack = [
      {
        transition: 'all 0.3s linear',
        marginLeft: '0px',
        width: (toEdge + ghost.offsetWidth) + "px",
        marginBottom: marginComp + "px"
      }, {
        transition: '',
        width: '100%',
        marginBottom: '0px'
      }, {
        transition: 'all 0.3s linear',
        height: "" + dims.height
      }
    ];
    element.keyframeStack = [
      {
        transition: 'all 0.7s ease-in',
        left: '0px',
        width: "" + dims.width,
        marginLeft: "" + dims.marginLeft,
        height: "" + dims.height,
        top: elementTop + "px"
      }, {}
    ];
    transformer = new MatrixFloatingTransform();
      if (element.keyframeTransition == null) {
          element.keyframeTransition = transformer.keyframeTransition;
      }
      if (ghost.keyframeTransition == null) {
          ghost.keyframeTransition = transformer.keyframeTransition;
      }
    ghost.addEventListener('webkitTransitionEnd', ghost.keyframeTransition);
    ghost.keyframeTransition(ghost);
    element.addEventListener('webkitTransitionEnd', element.keyframeTransition);
    element.keyframeTransition(element);
    element.size = 'expanded';
  },
    shrinkAlone: function (element) {
        var transformer;
        element.keyframeStack = [
            {
                transition: "0.5s all ease-in",
                width     : element.fromStyle.width,
                height    : element.fromStyle.height,
                marginLeft: element.fromStyle.marginLeft
            }
        ];
        transformer = new MatrixFloatingTransform();
        if (element.keyframeTransition == null) {
            element.keyframeTransition = transformer.keyframeTransition;
        }
        element.addEventListener('webkitTransitionEnd', element.keyframeTransition);
        element.keyframeTransition(element);
        return element.size = 'base';
    },

  /*
   * Returns an element to its base size
   */
  shrink: function(event) {
      var available, col, element, fullWidth, ghost, isFirst, left, meta, prev, ref, top, transformer;
    element = event.target;
    meta = document.createElement('core-meta');
      ghost = element.ghost;
    if (ghost == null) {
      return;
    }
    if (((ref = ghost.previousElementSibling) != null ? ref.localName : void 0) === element.localName) {
      prev = ghost.previousElementSibling;
    }
    fullWidth = (parseFloat(element.fromStyle.width) || 0) + (parseFloat(element.fromStyle.marginLeft) || 0);
    isFirst = (prev != null ? prev.localName : void 0) !== element.localName;
    available = element.parentNode.offsetWidth - (((prev != null ? prev.offsetLeft : void 0) || 0) + fullWidth);
    if (isFirst || available <= fullWidth || (prev != null ? prev.size : void 0) !== 'base') {
      col = 0;
    }
    if (col == null) {
      col = (((prev != null ? prev.offsetLeft : void 0) || 0) + fullWidth) / fullWidth;
    }
    left = col * fullWidth;
    if (col !== 0) {
      left -= parseFloat(element.fromStyle.marginLeft) || 0;
    }
    if (isFirst) {
      top = 0;
    }
    if ((prev != null ? prev.size : void 0) !== 'base') {
      if (top == null) {
        top = element.offsetTop - (parseFloat(element.fromStyle.marginTop) || 0);
      }
    }
    if (top == null) {
      top = ((available >= fullWidth ? prev.offsetTop : void 0) || element.offsetTop) - (parseFloat(element.fromStyle.marginTop) || 0);
    }
    ghost.keyframeStack = [
      {
          transition: '0.5s all linear',
        width: element.fromStyle.width,
        height: element.fromStyle.height,
        marginLeft: element.fromStyle.marginLeft,
        marginTop: element.fromStyle.marginTop
      }
    ];
    element.keyframeStack = [
      {
        transition: "0.7s all ease-in",
        width: element.fromStyle.width,
        height: element.fromStyle.height,
          marginLeft: element.fromStyle.marginLeft
      }, {
        transition: '',
            top: '0px',
        left: "0px"
      }
    ];
    transformer = new MatrixFloatingTransform();
      if (element.keyframeTransition == null) {
          element.keyframeTransition = transformer.keyframeTransition;
      }
      if (ghost.keyframeTransition == null) {
          ghost.keyframeTransition = transformer.keyframeTransition;
      }
    ghost.addEventListener('webkitTransitionEnd', ghost.keyframeTransition);
    ghost.keyframeTransition(ghost);
    element.addEventListener('webkitTransitionEnd', element.keyframeTransition);
    element.keyframeTransition(element);
    return element.size = 'base';
  },

  /*
   * Sequentially applies CSS transitions to an element.  Input may be an element or an instance of
   * TransitionEvent referencing the element in its @target property
  #
   * Areas for improvement:
   * - string case conversion should be moved to String.prototype or its own class
   * - keyframe management should be its own class at the element level
   */
  keyframeTransition: function(event) {
    var computedStyle, element, key, meta, prop, ref, ref1, stringUtils, value, word;
    if (event == null) {
      event = null;
    }
      if (event.localName != null) {
          if (event.localName === 'matrix-card') {
              element = event;
          }
          if (event.localName === 'matrix-ghost') {
              element = event;
          }
    }
    if (element == null) {
      element = (Object.prototype.toString.call(event) === "[object TransitionEvent]" ? event != null ? event.target : void 0 : void 0);
    }
    if (element == null) {
        return;
    }
      if ((ref = element.localName) !== 'matrix-card' && ref !== 'matrix-ghost') {
          return console.log('bullshit element', element);
      }
      if (element == null) {
      return console.log('Unable to find element', event);
    }
    if (!(element.keyframeStack instanceof Array)) {
      return;
    }
    if (element.keyframeStack.length === 0) {
      if (element.activeKeyframe != null) {
        delete element.activeKeyframe;
      }
        if (element.keyframeStack != null) {
            delete element.keyframeStack;
        }
      element.dispatchEvent(new Event('matrixScaleEnd'));
      element.removeEventListener('webkitTransitionEnd', element.keyframeTransition);
    }
    if (element.activeKeyframe == null) {
      element.activeKeyframe = {};
    }
    if (event !== element) {
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
      if (element.keyframeStack == null) {
          return;
      }
    element.activeKeyframe = element.keyframeStack.shift();
    computedStyle = getComputedStyle(element);
    meta = document.createElement('core-meta');
    stringUtils = meta.byId('matrix-string-utils');
    ref1 = element.activeKeyframe;
    for (key in ref1) {
      value = ref1[key];
      element.style[key] = value;
      prop = stringUtils.hyphenToCamel(key);
      if (element.style[key] === computedStyle[prop] || key === 'transition') {
        delete element.activeKeyframe[key];
      }
      if (key === 'width' && parseInt(computedStyle[prop]) === element.parentNode.offsetWidth) {
        delete element.activeKeyframe[key];
      }
    }
    if (Object.keys(element.activeKeyframe).length === 0) {
        return element.keyframeTransition(element);
    }
  }
});
