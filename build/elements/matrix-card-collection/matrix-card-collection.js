Polymer('matrix-card-collection', {
    ready    : function () {
    },
    transform: function (event, detail, sender) {
        var element, ghost, meta, transformer;
        element = event.target;
        $(element).off('matrixUnstickEnd matrixScaleEnd');
        meta = document.querySelector('core-meta');
        transformer = new MatrixFloatingTransform();
        element.appendChild(transformer);
        if (element.size === 'base') {
            ghost = new MatrixGhost();
            ghost.assign(element);
            ghost.unstick();
            $(element).on('matrixUnstickEnd', transformer.grow);
            $(element).on('matrixScaleEnd', ghost.stick);
            return;
        }
        if (element.size === 'expanded') {
            transformer.shrinkAlone(element);
        }
    }
});
