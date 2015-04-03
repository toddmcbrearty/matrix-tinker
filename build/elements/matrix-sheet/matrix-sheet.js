Polymer('matrix-sheet', {
    publish: {
        size    : 100,
        sequence: null,
        origin  : 'left',
        offset  : '0'
    },
    ready  : function () {
        this.style.width = (parseInt(this.size) || 0) + "%";
        if (this.offset.substr(this.offset.length - 1) === '%') {
            this.offset = parseInt(window.innerWidth) * (parseFloat(this.offset) / 100);
        }
        return this.style[this.origin] = this.offset + "px";
    }
});
