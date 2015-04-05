var Matrix, dims, i, icons, item, list, model, range, results;

icons = ['cloud', 'attachment', 'inbox', 'polymer', 'redeem', 'settings', 'thumb-up', 'translate', 'warning'];

range = (function() {
  results = [];
  for (i = 0; i < 100; i++){ results.push(i); }
  return results;
}).apply(this);

dims = {
  width: '100%',
  height: '500px'
};

model = (function() {
  var j, len, results1;
  results1 = [];
  for (j = 0, len = range.length; j < len; j++) {
    item = range[j];
    results1.push({
      value: ++item,
      icon: icons[Math.floor(Math.random() * icons.length)],
      dims: dims
    });
  }
  return results1;
})();

list = [
    {
        title: 'Author',
        body : 'Foobarious Fizz, Esq.'
    }, {
        title: 'Document Name',
        body : 'Foo bar baz fizz: what do we really know?'
    }, {
        title: 'Document Type',
        body : 'Contract'
    }, {
        title: 'Effective Date',
        body : 'Unknown',
        icon : 'warning'
    }, {
        title: 'Note',
        body : 'Now THIS is a note'
    }
];

document.addEventListener('polymer-ready', function() {
    var matrix;
    matrix = new Matrix(model, list);
  return matrix.display();
});

$(document).keyup(function(event) {
  $('matrix-drawer[application]').toggleClass('active');
  $("div:not(.sharp)").toggleClass('blurry');
  return $("matrix-drawer[right]").toggleClass('blurry');
});

Matrix = (function() {
    function Matrix(data, list1) {
    this.data = data;
        this.list = list1;
  }

  Matrix.prototype.display = function() {
      document.querySelector('#test-card-collection').cards = this.data;
      return document.querySelector('#test-bound-list').items = this.list;
  };

  return Matrix;

})();
