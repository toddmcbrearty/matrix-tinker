Polymer('matrix-card', {
  ready: function() {},
  publish: {
    transformable: true,
    fullSizeDims: {},
    size: 'base',
    debug: null
  },
  handleClick: function(event) {
    var ghost, meta, transformer;
    if (!this.transformable) {
      return;
    }
    $(this).off('matrixUnstickEnd matrixScaleEnd');
    meta = document.querySelector('core-meta');
    ghost = new MatrixGhost();
    ghost.assign(this);
    transformer = new MatrixFloatingTransform();
    this.appendChild(transformer);
    if (this.size === 'base') {
      ghost.unstick();
      $(this).on('matrixUnstickEnd', transformer.grow);
      $(this).on('matrixScaleEnd', ghost.stick);
      return;
    }
    if (this.size === 'expanded') {
      ghost.unstick();
      $(this).on('matrixUnstickEnd', transformer.shrink);
      $(this).on('matrixScaleEnd', ghost.stick);
    }
  }
});
