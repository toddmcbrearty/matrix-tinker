config = require './config.coffee'
through = require 'through2'
fse = require 'fs-extra'
path = require 'path'
gutil = require 'gulp-util'


PLUGIN_NAME = 'gulp-collect-dependencies';


module.exports = (opts) ->

  return through.obj (file, enc, cb) ->

    if file.isNull()
      @push file
      return cb.call()

    if file.isStream()
      @emit 'error', new gutil.PluginError(PLUGIN_NAME, 'Streaming not supported')
      return cb.call()

    opts ?= {}
    opts.pattern = new RegExp("(@@bower)/([^/\r\n]+)/") unless opts.pattern instanceof RegExp
    opts.from ?= 'vendor/bower_components'
    opts.to ?= 'build/elements'
    opts.rel ?= 'src/elements'

#    libs = (line.match(opts.pattern)[2] for line in file.contents.toString().split('\n') when line.match(opts.pattern))
#
#    for lib in libs
#      continue unless lib?
#      fse.copy path.resolve("#{opts.from}/#{lib}"), path.resolve("#{opts.to}/#{lib}"), (err) -> console.log err if err?

#    fse.copy path.resolve("#{opts.from}"), path.resolve("#{opts.to}/"), (err) -> console.log err if err?
#
    relPath = path.relative(path.dirname(file.path), path.resolve("#{opts.from}"))

    contents = file.contents.toString()
    while matches = contents.match(opts.pattern)
      contents = contents.replace(opts.pattern, "#{relPath}/#{matches[2]}/")
    file.contents = new Buffer(contents)

    @push file

    cb.call()
