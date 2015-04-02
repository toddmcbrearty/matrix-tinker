'use strict'

# DEPENDENCIES
config    = require './config.coffee'
CaseHelpers = require './CaseHelpers.coffee'
ElementBuilder = require './ElementBuilder.coffee'
injector = require './ScriptInjector.coffee'
deps = require './gulpDependencies.coffee'
gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
sass    = require 'gulp-sass'
vulcanize  = require 'gulp-vulcanize'
replace = require 'gulp-replace-task'
runSequence = require 'run-sequence'
browserSync = require 'browser-sync'
del = require 'del'
fs = require 'fs'
path = require 'path'
gutil = require 'gulp-util'
prettify = require 'gulp-prettify'

### PROPERTIES ###
serve = gutil.env.serve?
silent = gutil.env.silent?
ssh = process.env['SSH_CONNECTION']?

# pattern builder for gulp-replace-task patterns
patternBuilder = (match, replacement) ->
  return {match: match, replacement: replacement}

### GULP TASKS AND WORKFLOW COLLECTIONS ###
# WIPE existing data
gulp.task 'clean-build', (callback) ->
  del path.resolve(config.build), callback

gulp.task 'clean-dist', (callback) ->
  del path.resolve(config.dist), callback

# copy all html, compile all coffeescript and scss, copy libraries, fix polymer dependencies
gulp.task 'build', ->
  gulp.src path.resolve("#{config.src}/main/index.html")
  .pipe replace patterns: injector.getInjectionPatterns ['polymerImports', 'stylesheetMain', 'scriptsHigh', 'scriptsLow']
  .pipe prettify(indent_size: 4)
  .pipe gulp.dest path.resolve("#{config.build}")

  elements = path.resolve("#{config.build}/elements")
  gulp.src path.resolve("#{config.src}/elements/**/*.html")
  .pipe deps
    pattern: new RegExp('(@@bower)/([^/\r\n]+)/')
    from: config.bower
    to: "#{config.build}/elements"
    rel: "#{config.src}/elements"
  .pipe prettify(indent_size: 4)
  .pipe gulp.dest elements

  gulp.src path.resolve("#{config.src}/elements/**/*.scss")
  .pipe sass bare: true
  .pipe gulp.dest elements

  gulp.src path.resolve("#{config.src}/elements/**/*.coffee")
  .pipe coffee bare: true
  .pipe gulp.dest elements

  gulp.src path.resolve("#{config.bower}/webcomponentsjs/**/*")
  .pipe gulp.dest path.resolve("#{config.build}/elements/webcomponentsjs")

  gulp.src path.resolve("#{config.bower}/polymer/**/*")
  .pipe gulp.dest path.resolve("#{config.build}/elements/polymer")

#  gulp.src path.resolve("#{config.src}/elements/matrix-dependencies.html")
#  .pipe gulp.dest path.resolve("#{config.build}/elements")

  gulp.src path.resolve("#{config.node}/jquery/dist/jquery.js")
  .pipe gulp.dest path.resolve("#{config.build}/scripts")

  gulp.src path.resolve("#{config.src}/main/**/*.scss")
  .pipe sass bare: true
  .pipe gulp.dest path.resolve("#{config.build}")

  gulp.src path.resolve("#{config.src}/main/**/*.coffee")
  .pipe coffee bare: true
  .pipe gulp.dest path.resolve("#{config.build}")


gulp.task 'dist', ->
  gulp.src path.resolve("#{config.build}/index.html")
  .pipe gulp.dest path.resolve("#{config.dist}")
  gulp.src path.resolve("#{config.build}/scripts/**/*")
  .pipe gulp.dest path.resolve("#{config.dist}/scripts")
  gulp.src path.resolve("#{config.build}/style/**/*")
  .pipe gulp.dest path.resolve("#{config.dist}/style")

  gulp.src path.resolve("#{config.build}/elements/matrix-dependencies.html")
  .pipe vulcanize
    dest: path.resolve("#{config.build}/elements")
    excludes:
      imports: ['polymer.html$']
    inline: true
    csp: false
  .pipe gulp.dest path.resolve("#{config.dist}/elements")

  gulp.src path.resolve("#{config.build}/elements/webcomponentsjs/**/*")
  .pipe gulp.dest path.resolve("#{config.dist}/elements/webcomponentsjs")

  gulp.src path.resolve("#{config.build}/elements/polymer/**/*")
  .pipe gulp.dest path.resolve("#{config.dist}/elements/polymer")


# DEFAULT TASKS - These will be run sequentially when 'gulp' is invoked with no arguments
gulp.task 'default', ->
  runSequence 'clean-build', 'clean-dist', 'build', ->
    runSequence 'dist'



### WATCHERS ###
gulp.task 'watch', ->
  gulp.watch path.resolve(config.paths.src.scss.root, '**/*.scss'), ['styles']
  gulp.watch path.resolve(config.paths.src.coffee.root, '**/*.coffee'), ['coffee']
  gulp.watch path.resolve(config.paths.src.elements.root, '**/*.html'), ['vulcanize', 'copy']
  gulp.watch path.resolve(config.paths.src.assets, '/index.html'), ['copy']

# BrowserSync server
gulp.task 'serve', ->
  unless ssh == false
    console.log 'FATAL: SERVE task only available locally.'
    return

  browserSync
    proxy: 'matrix.app'
    notify: true
    injectChanges: false
    files:
      [
        path.resolve("#{config.dist}/style/*.css"),
        path.resolve("#{config.dist}/scripts/*.js"),
        path.resolve("#{config.dist}/index.html")
      ]

gulp.task 'serve-local', ->
  unless ssh == false
    console.log 'FATAL: SERVE task only available locally.'
    return

  browserSync
    server:
      baseDir: 'public'
      index: 'index.html'
      online: false
      browser: 'google chrome'
      notify: true
