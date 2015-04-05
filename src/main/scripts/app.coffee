icons = ['cloud', 'attachment', 'inbox', 'polymer', 'redeem', 'settings', 'thumb-up', 'translate', 'warning']
# some bs data
range = [0...100]
dims = {width: '100%', height: '500px'}
model = (value: ++item, icon: icons[Math.floor(Math.random()*icons.length)], dims: dims for item in range)

list = [
  {title: 'Author', body: 'Foobarious Fizz, Esq.'}
  {title: 'Document Name', body: 'Foo bar baz fizz: what do we really know?'}
  {title: 'Document Type', body: 'Contract'}
  {title: 'Effective Date', body: 'Unknown', icon: 'warning'}
  {title: 'Note', body: 'Now THIS is a note'}
]

document.addEventListener 'polymer-ready', ->
  matrix = new Matrix(model, list)
  matrix.display()

$(document).keyup (event) ->
  $('matrix-drawer[application]').toggleClass('active')
  $("div:not(.sharp)").toggleClass('blurry')
  $("matrix-drawer[right]").toggleClass('blurry')


class Matrix
  constructor: (@data, @list) ->
  display: ->
    document.querySelector('#test-card-collection').cards = @data
    document.querySelector('#test-bound-list').items = @list
