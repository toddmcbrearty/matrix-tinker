injections =
  polymerImports:
    type: 'link'
    attributes:
      rel: 'import'
      href: '@resource'
    resources:
      [
        "elements/polymer/polymer.html"
#        "elements/matrix-card/matrix-card.html"
        "elements/matrix-dependencies.html"
      ]
  stylesheetMain:
    type: 'link'
    attributes:
      rel: 'stylesheet'
      href: '@resource'
    resources:
      [
        "style/app.css"
      ]
  scriptsHigh:
    type: 'script'
    attributes:
      src: '@resource'
    resources:
      [
        "elements/webcomponentsjs/webcomponents.js"
      ]
  scriptsLow:
    type: 'script'
    attributes:
      src: '@resource'
    resources:
      [
        "scripts/jquery.js"
        "scripts/app.js"
      ]

config =
  src: 'src'
  build: 'build'
  dist: 'public'
  node: 'node_modules'
  bower: 'vendor/bower_components'
  injections: injections

module.exports = config