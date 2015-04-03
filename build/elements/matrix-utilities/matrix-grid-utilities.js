
/*
  GET INSTANCE
    meta = document.createElement('core-meta')
    gridUtils = meta.byId('matrix-grid-utils')
 */
Polymer('matrix-grid-utilities', {
  pixelsToEdge: function(element) {
    var elementStyle, gridStyle, pixelsToEdge, usefulWidth, widthThroughElement;
    gridStyle = getComputedStyle(element.parentNode);
    elementStyle = getComputedStyle(element);
    usefulWidth = parseFloat(gridStyle.width) - (parseFloat(gridStyle.paddingLeft) || 0) - (parseFloat(gridStyle.paddingRight) || 0);
    widthThroughElement = element.offsetLeft + element.offsetWidth + (parseFloat(elementStyle.marginLeft) || 0);
    pixelsToEdge = usefulWidth - widthThroughElement;
    return pixelsToEdge;
  },
  nextAvailableTop: function(element) {
    var elementStyle, marginTop, offsetHeight, offsetTop;
    elementStyle = getComputedStyle(element);
    offsetTop = parseFloat(element.offsetTop) || 0;
    offsetHeight = parseFloat(element.offsetHeight) || 0;
    marginTop = parseFloat(elementStyle.marginTop) || 0;
    if (this.leftOffset(element) === 0) {
      return offsetTop - marginTop;
    }
    return offsetTop + offsetHeight;
  },
  marginCompensation: function(element) {
    var items, remainder;
    items = this.leftOffset(element) + this.rightOffset(element);
    remainder = (!(this.leftOffset(element) === 0 || this.rightOffset(element) === 0) ? this.rightOffset(element) / items : void 0) || 0;
    return remainder * parseFloat(element.offsetHeight);
  },

  /*
   * worker method for rightOffset and leftOffset
   */
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
    if (neighbor.size === 'expanded') {
      return 0;
    }
    if (element.offsetLeft <= neighbor.offsetLeft && direction === 'previous') {
      return 0;
    }
    if (element.offsetLeft >= neighbor.offsetLeft && direction === 'next') {
      return 0;
    }
    return this.rowOffset.apply(this, [neighbor, direction]) + 1;
  },

  /*
   * returns the number of elements preceding @element in the current row
   */
  leftOffset: function(element) {
    return this.rowOffset(element, 'previous');
  },

  /*
   * returns the number of elements following @element in the current row
   */
  rightOffset: function(element) {
    return this.rowOffset(element, 'next');
  }
});
