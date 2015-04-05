Polymer('matrix-sheet-controller', {
    publish: {
        group  : null,
        minZ   : 100,
        reverse: true
    },
    ready  : function () {
        var attribute, group, i, index, item, j, k, len, len1, len2, ref, results, scope, selector, sequence, sequenced, set, unsequenced;
        attribute = (this.group != null ? "[group=" + group + "]" : void 0) || '';
        selector = "matrix-sheet" + attribute;
        scope = this.parentNode || document;
        group = scope.querySelectorAll(selector);
        if (!(group.length > 0)) {
            return;
    }
        for (i = 0, len = group.length; i < len; i++) {
            item = group[i];
            if (item.sequence != null) {
                sequenced = item;
            }
        }
        if (sequenced == null) {
            sequenced = [];
        }
        set = {
            items: {},
            keys : []
        };
        for (j = 0, len1 = sequenced.length; j < len1; j++) {
            item = sequenced[j];
            sequence = (parseInt(item.sequence) || 0) * 10 + this.minZ;
            while (set.items[sequence++] != null) {
                continue;
            }
            set.items[sequence] = item;
            set.keys.push(sequence);
        }
        sequence = (set.keys.length !== 0 ? Math.max.apply(this, set.keys) : void 0) || this.minZ;
        unsequenced = (function () {
            var k, len2, results;
            results = [];
            for (k = 0, len2 = group.length; k < len2; k++) {
                item = group[k];
                if ((item.sequence != null) === false) {
                    results.push(item);
        }
            }
            return results;
        })();
        if (unsequenced == null) {
            unsequenced = [];
    }
        if (this.reverse !== false) {
            unsequenced = unsequenced.reverse();
        }
        for (k = 0, len2 = unsequenced.length; k < len2; k++) {
            item = unsequenced[k];
            set.items[++sequence] = item;
        }
        ref = set.items;
        results = [];
        for (index in ref) {
            item = ref[index];
            results.push(item.style.zIndex = index);
        }
        return results;
    }
});
