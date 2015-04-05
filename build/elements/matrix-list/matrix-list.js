Polymer('matrix-list', {
    ready  : function () {
        var listTitle;
        if (this.listTitle == null) {
            listTitle = this.querySelector('.title');
            if (listTitle != null) {
                return this.listTitle = listTitle.innerText;
            }
    }
    },
    created: function () {
    }
});
