Polymer('matrix-card', {
  ready: function() {
    var icon, toolbar;
    this.style.background = this.background;
    icon = this.querySelector('core-icon');
    toolbar = this.querySelector('.toolbar');
    if ((icon != null) || (toolbar != null)) {
      return this.toolbar = true;
    }
  },
  publish: {
    transformable: true,
    fullSizeDims: {},
    size: 'base',
    debug: null,
    background: 'white'
  },
  created: function() {},
  transform: function(event) {}
});
