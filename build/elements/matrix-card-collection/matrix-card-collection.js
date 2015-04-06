Polymer('matrix-card-collection', {
  ready: function() {},
  transform: function(event, detail, sender) {
    var element, ghost, meta, transformer;
    element = event.target;
    $(element).off('matrixUnstickEnd matrixScaleEnd');
    meta = document.querySelector('core-meta');
    transformer = new MatrixFloatingTransform();
    element.transformer = transformer;
    if (element.size === 'base') {
      ghost = new MatrixGhost();
      ghost.assign(element);
      ghost.unstick();
      element.addEventListener('matrixUnstickEnd', element.transformer.grow);
      element.addEventListener('matrixScaleEnd', element.ghost.stick);
      return;
    }
    if (element.size === 'expanded') {
      element.transformer.shrinkAlone(element);
    }
  }
});
