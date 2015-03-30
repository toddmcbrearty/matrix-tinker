var Matrix, i, icons, item, model, range, results;

icons = ['cloud', 'attachment', 'inbox', 'polymer', 'redeem', 'settings', 'thumb-up', 'translate', 'warning'];

range = (function() {
  results = [];
  for (i = 0; i < 100; i++){ results.push(i); }
  return results;
}).apply(this);

model = (function() {
  var j, len, results1;
  results1 = [];
  for (j = 0, len = range.length; j < len; j++) {
    item = range[j];
    results1.push({
      value: ++item,
      icon: icons[Math.floor(Math.random() * icons.length)]
    });
  }
  return results1;
})();

document.addEventListener('polymer-ready', function() {
  var matrix;
  matrix = new Matrix(model);
  return matrix.display();
});

$(document).keyup(function(event) {
  return console.log(event);
});

Matrix = (function() {
  function Matrix(data) {
    this.data = data;
  }

  Matrix.prototype.display = function() {
    return document.querySelector('template[is="auto-binding"]').activeCollection = this.data;
  };

  return Matrix;

})();
