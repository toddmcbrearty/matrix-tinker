Polymer('matrix-sheet', {
    offset  : '0',
    size    : '100%',
    sequence: null,
    origin  : 'left',
    ready   : function () {
        this.style.width = (this.size != null ? "" + this.size : void 0) || '100%';
        if (this.offset.substr(this.offset.length - 1) === '%') {
            this.offset = parseInt(window.innerWidth) * (parseFloat(this.offset) / 100);
    }
        if (this.origin != null) {
            return this.style[this.origin] = this.offset + "px";
    }
    }
});
