'use strict'

PLUGIN_NAME = 'gulp-retina-sprites'

Stream  = require('stream').Stream

path    = require 'path'
fs      = require 'fs'

_       = require 'lodash'
through = require 'through2'
gm      = require 'gm'
VinylFile   = require 'vinyl'
deferred = require 'deferred'
chalk   = require 'chalk'

module.exports = (options = {}) ->

  through.obj (file, enc, next) ->
    basePath = file.base
    folder = basePath.match(/([^\//]+)\/$/)[1]
    filePath = file.path
    relative2xPath = path.join "#{folder}-2x", file.relative
    relative1xPath = path.join "#{folder}-1x", file.relative

    if not file.relative.match /\.png/ig
      # TODO: PluginError
      next null, file

    # TODO: Glob files as source
    gmFile = gm(filePath)
      .background('#ffffffff')
        .size((err, size) =>

          rootDef = deferred()
          promise = rootDef.promise()

          file2x = null
          file1x = null
          promise
            .then =>
              def = deferred()

              pixelFill gmFile, size.width, size.height

              gmFile.toBuffer null, (err, buffer) ->
                file2x = new VinylFile
                  base: basePath
                  path: path.join basePath, relative2xPath
                  contents: buffer
                def.resolve()

              def.promise()
            .then =>
              def = deferred()

              resize gmFile, size.width, size.height

              gmFile.toBuffer null, (err, buffer) ->
                file1x = new VinylFile
                  base: basePath
                  path: path.join basePath, relative1xPath
                  contents: buffer
                def.resolve()

              def.promise()
            .then =>
              @push file2x
              @push file1x
              next()

          rootDef.resolve()
          null
        )

pixelFill = (file, width, height) ->
  if height%2
    file
      .extent(width, ++height)
  else
    file

resize = (file, width, height) ->
  width *= 0.5
  height *= 0.5

  file
    .resize(width, height)