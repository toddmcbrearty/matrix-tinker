icons = ['cloud', 'attachment', 'inbox', 'polymer', 'redeem', 'settings', 'thumb-up', 'translate', 'warning']
# some bs data
range = [0...100]
model = (value: ++item, icon: icons[Math.floor(Math.random()*icons.length)] for item in range)

document.addEventListener 'polymer-ready', ->
  matrix = new Matrix(model)
  matrix.display()

$(document).keyup (event) ->
  $('matrix-drawer[application]').toggleClass('active')
  $("div:not(.sharp)").toggleClass('blurry')


class Matrix
  constructor: (@data) ->
  display: ->
    document.querySelector('template[is="auto-binding"]').activeCollection = @data