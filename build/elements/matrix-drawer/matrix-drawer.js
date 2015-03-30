Polymer('matrix-drawer', {
  ready: function() {
    var attr, i, len, ref, results;
    console.log('drawer loaded');
    ref = this.attributes;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      attr = ref[i];
      results.push(values[attr.nodeName] = attr.value);
    }
    return results;
  }
});
