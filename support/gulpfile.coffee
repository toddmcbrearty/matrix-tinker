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
rimraf = require 'rimraf'

### PROPERTIES ###
serve = gutil.env.serve?
silent = gutil.env.silent?
ssh = process.env['SSH_CONNECTION']?

# pattern builder for gulp-replace-task patterns
patternBuilder = (match, replacement) ->
  return {match: match, replacement: replacement}

###

  BUILD TASKS

  ###

gulp.task 'build-clean', ->
#  rimraf path.resolve(config.build)
  rimraf.sync './build', -> (error) console.log error

gulp.task 'build-index', ->
  gulp.src path.resolve("#{config.src}/main/index.html")
  .pipe replace patterns: injector.getInjectionPatterns ['polymerImports', 'stylesheetMain', 'scriptsHigh', 'scriptsLow']
  .pipe prettify(indent_size: 4)
  .pipe gulp.dest path.resolve("#{config.build}")

gulp.task 'build-component-html', ->
  elements = path.resolve("#{config.build}/elements")
  gulp.src path.resolve("#{config.src}/elements/**/*.html")
  .pipe deps
    pattern: new RegExp('(@@bower)/([^/\r\n]+)/')
    from: config.bower
    to: "#{config.build}/elements"
    rel: "#{config.src}/elements"
  .pipe prettify(indent_size: 4)
  .pipe gulp.dest elements

gulp.task 'build-component-sass', ->
  elements = path.resolve("#{config.build}/elements")
  gulp.src path.resolve("#{config.src}/elements/**/*.scss")
  .pipe sass bare: true
  .pipe gulp.dest elements

gulp.task 'build-component-coffee', ->
  elements = path.resolve("#{config.build}/elements")
  gulp.src path.resolve("#{config.src}/elements/**/*.coffee")
  .pipe coffee bare: true
  .pipe gulp.dest elements

gulp.task 'build-polymer-core', ->
  gulp.src path.resolve("#{config.bower}/webcomponentsjs/**/*")
  .pipe gulp.dest path.resolve("#{config.build}/elements/webcomponentsjs")
  gulp.src path.resolve("#{config.bower}/polymer/**/*")
  .pipe gulp.dest path.resolve("#{config.build}/elements/polymer")

gulp.task 'build-script-dependencies', ->
  gulp.src path.resolve("#{config.node}/jquery/dist/jquery.js")
  .pipe gulp.dest path.resolve("#{config.build}/scripts")

gulp.task 'build-application-sass', ->
  gulp.src path.resolve("#{config.src}/main/**/*.scss")
  .pipe sass bare: true
  .pipe gulp.dest path.resolve("#{config.build}")

gulp.task 'build-application-coffee', ->
  gulp.src path.resolve("#{config.src}/main/**/*.coffee")
  .pipe coffee bare: true
  .pipe gulp.dest path.resolve("#{config.build}")

gulp.task 'build-all', -> runSequence 'build-clean',
  'build-index',
  'build-component-html',
  'build-component-sass',
  'build-component-coffee',
  'build-polymer-core',
  'build-script-dependencies',
  'build-application-sass',
  'build-application-coffee'

###

  DIST TASKS

  ###

gulp.task 'dist-clean', ->
  rimraf.sync './public', -> (error) console.log error

gulp.task 'dist-copy-main', ->
  gulp.src path.resolve("#{config.build}/index.html")
  .pipe gulp.dest path.resolve("#{config.dist}")

gulp.task 'dist-copy-style', ->
  gulp.src path.resolve("#{config.build}/style/**/*")
  .pipe gulp.dest path.resolve("#{config.dist}/style")

gulp.task 'dist-copy-scripts', ->
  gulp.src path.resolve("#{config.build}/scripts/**/*")
  .pipe gulp.dest path.resolve("#{config.dist}/scripts")

gulp.task 'dist-dependencies', ->
  gulp.src path.resolve("#{config.build}/elements/webcomponentsjs/**/*")
  .pipe gulp.dest path.resolve("#{config.dist}/elements/webcomponentsjs")
  gulp.src path.resolve("#{config.build}/elements/polymer/**/*")
  .pipe gulp.dest path.resolve("#{config.dist}/elements/polymer")

gulp.task 'dist-vulcanize', ->
  gulp.src path.resolve("#{config.build}/elements/matrix-dependencies.html")
  .pipe vulcanize
    dest: path.resolve("#{config.build}/elements")
    excludes:
      imports: ['polymer.html$']
    inline: true
    csp: false
  .pipe gulp.dest path.resolve("#{config.dist}/elements")

gulp.task 'dist-all', -> runSequence 'dist-clean',
  'dist-copy-main',
  'dist-copy-style',
  'dist-copy-scripts',
  'dist-dependencies',
  'dist-vulcanize'


###
  COMPILED TASKS
  ###

gulp.task 'build-dist-all', -> runSequence 'build-clean',
  'build-index',
  'build-component-html',
  'build-component-sass',
  'build-component-coffee',
  'build-polymer-core',
  'build-script-dependencies',
  'build-application-sass',
  'build-application-coffee',
  'dist-clean',
  'dist-copy-main',
  'dist-copy-style',
  'dist-copy-scripts',
  'dist-dependencies',
  'dist-vulcanize'

# DEFAULT TASKS - These will be run sequentially when 'gulp' is invoked with no arguments
gulp.task 'default', -> runSequence 'build-dist-all'


###
  WATCHER TASKS
  ###

gulp.task 'rebuild-components', -> runSequence 'build-component-html',
  'build-component-sass',
  'build-component-coffee',
  'dist-vulcanize'

gulp.task 'rebuild-sass', -> runSequence 'build-application-sass', 'dist-copy-style'

gulp.task 'rebuild-coffee', -> runSequence 'build-application-coffee', 'dist-copy-scripts'

gulp.task 'rebuild-main', -> runSequence 'build-index', 'dist-copy-main'


### WATCHERS ###
gulp.task 'watch', ->
  gulp.watch path.resolve("#{config.src}/elements/**/*"), ['rebuild-components']
  gulp.watch path.resolve("#{config.src}/main/**/*.scss"), ['rebuild-sass']
  gulp.watch path.resolve("#{config.src}/main/**/*.coffee"), ['rebuild-coffee']
  gulp.watch path.resolve("#{config.src}/main/**/*.html"), ['rebuild-coffee']


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
        path.resolve("#{config.dist}/**/*{.html,.js,.css}")
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