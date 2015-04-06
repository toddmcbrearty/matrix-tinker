Polymer('matrix-list-item', {
    created: function () {
        var base, base1, body, el, icon, meta, stringUtils, title;
        if (this.data == null) {
            this.data = {};
    }
        if (this.data.title == null) {
            title = this.querySelector('.title');
            if (title != null) {
                this.data.title = title.innerText;
            }
    }
        if (this.data.body == null) {
            body = (function () {
                var i, len, ref, results;
                ref = this.querySelectorAll(':not(.title)');
                results = [];
                for (i = 0, len = ref.length; i < len; i++) {
                    el = ref[i];
                    if (el.innerText !== '') {
                        results.push(el.innerText);
                    }
        }
                return results;
            }).call(this);
            meta = document.createElement('core-meta');
            stringUtils = meta.byId('matrix-string-utils');
            this.data.body = stringUtils.escapeHtml(body.join(''));
    }
        if (this.data.icon == null) {
            icon = this.querySelector('core-icon');
            this.data.icon = icon != null ? icon.getAttribute('icon') : void 0;
        }
        if ((base = this.data).name == null) {
            base.name = '';
        }
        return (base1 = this.data).label != null ? base1.label : base1.label = '';
    }
});
