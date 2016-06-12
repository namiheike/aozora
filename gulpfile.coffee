# TODO

# watch
# jslint
# optimize images
# handle fonts

argv = require('yargs').argv
_ = require 'lodash'
gulp = require('gulp')
$ = require('gulp-load-plugins')()
runSequence = require('run-sequence')
gutil = require('gutil')
exec = require('child_process').exec
polylint = require 'polylint'
chalk = require 'chalk'
del = require 'del'
vinyl_paths = require 'vinyl-paths'

resourcesCategories = ['backgrounds', 'images', 'music', 'sounds', 'tachies', 'videos', 'voices']
paths =
  dependencies:
    bower:
      toCopy: [ 'bower_components/**' ]
      copyDest: 'dist/bower_components/'
      folderToCleanup: 'dist/bower_components'
  app:
    internal:
      index:
        toCdnize: [ 'dist/index.html' ]
        toBundle: [ 'dist/index.html' ]
        bundleDest: 'dist/'
      styles:
        toCompile: [ 'app/$styles/*.sass' ]
        compileDest: 'dist/$styles'
        compiled: [ 'dist/$styles/**/*' ]
        folderToCleanup: 'dist/$styles'
      scripts:
        toCompile: [ 'app/$scripts/*.coffee' ]
        compileDest: 'dist/$scripts'
        compiled: [ 'dist/$scripts/**/*' ]
        folderToCleanup: 'dist/$scripts'
  elements:
    internal:
      pages:
        toCompile: [ 'app/$elements/*/*.haml' ]
        compileDest: 'dist/$elements'
        compiled: [ 'dist/$elements/*/*.html' ]
      styles:
        toCompile: [ 'app/$elements/*/*.sass' ]
        compileDest: 'dist/$elements'
        compiled: [ 'dist/$elements/*/*.css' ]
      scripts:
        toCompile: [ 'app/$elements/*/*.coffee' ]
        compileDest: 'dist/$elements'
        compiled: [ 'dist/$elements/*/*.js' ]
      folderToCleanup: 'dist/$elements'
  resources:
    internal:
      toCopy: [ 'app/$resources/**/*' ]
      copyDest: 'dist/$resources'
    external:
      metas:
        toCompile: (category) -> [ "app/resources/#{category}/#{category}.cson" ]
        compileDest: (category) -> "dist/resources/#{category}"
      contents:
        toCopy: (category) -> [ "app/resources/#{category}/**/*", "!app/resources/#{category}/#{category}.cson" ]
        copyDest: (category) -> "dist/resources/#{category}"
  config:
    external:
      toCopy: [ 'app/config/application.json' ]
      copyDest: 'dist/config'
  story:
    characters:
      meta:
        toCompile: [ 'app/story/characters.cson' ]
        compileDest: 'dist/story/'
    mainScript:
      toParse: [ 'app/story/scripts/main.aurora-script' ]
      parseDestFile: 'dist/story/scripts/main.json'
  othersToCopy: [ 'app/index.html', 'app/favicon.ico' ]

gulp.task 'noop', (cb) ->
  gulp
    .src ''
    # .pipe gutil.noop()
    .pipe gulp.dest '/tmp'

gulp.task 'clean', (cb) ->
  del [ '.tmp', 'dist' ]

gulp.task 'copy-dependencies', ->
  # TODO link instead of copy
  gulp
    .src paths.dependencies.bower.toCopy
    .pipe gulp.dest paths.dependencies.bower.copyDest

gulp.task 'copy-config', ->
  gulp
    .src paths.config.external.toCopy
    .pipe gulp.dest paths.config.external.copyDest

gulp.task 'copy-others', ->
  # favicon, index.html
  # TODO refactor
  gulp
    .src paths.othersToCopy
    .pipe gulp.dest 'dist'

gulp.task 'compile-app-styles', (cb) ->
  $.rubySass paths.app.internal.styles.toCompile
    .on 'error', gutil.log
    .pipe $.debug()
    .pipe gulp.dest paths.app.internal.styles.compileDest

gulp.task 'compile-app-scripts', (cb) ->
  gulp
    .src paths.app.internal.scripts.toCompile
    .pipe $.debug()
    .pipe $.coffee(bare: false).on('error', gutil.log)
    .pipe gulp.dest paths.app.internal.scripts.compileDest

gulp.task 'copy-internal-resources', ->
  gulp
    .src paths.resources.internal.toCopy
    .pipe $.debug()
    .pipe gulp.dest paths.resources.internal.copyDest

gulp.task 'handle-internal-elements', (cb) ->
  runSequence(
    [ 'compile-internal-elements-pages', 'compile-internal-elements-styles', 'compile-internal-elements-scripts' ]
    'inject-internal-elements-styles'
    'clean-internal-elements-injected-styles'
    cb
  )

gulp.task 'compile-internal-elements-pages', (cb) ->
  gulp
    .src paths.elements.internal.pages.toCompile
    .pipe $.debug()
    .pipe $.rubyHaml().on('error', gutil.log)
    .pipe gulp.dest paths.elements.internal.pages.compileDest

gulp.task 'compile-internal-elements-styles', (cb) ->
  $.rubySass paths.elements.internal.styles.toCompile
    .pipe $.debug()
    .pipe $.wrapper
      header: '<style>\n'
      footer: '</style>\n'
    .pipe gulp.dest paths.elements.internal.styles.compileDest

gulp.task 'compile-internal-elements-scripts', ->
  gulp
    .src paths.elements.internal.scripts.toCompile
    .pipe $.debug()
    .pipe $.coffee(bare: false).on('error', gutil.log)
    .pipe gulp.dest paths.elements.internal.scripts.compileDest

gulp.task 'inject-internal-elements-styles', ->
  gulp
    .src paths.elements.internal.pages.compiled
    .pipe $.debug()
    .pipe $.fileInclude()
    .pipe gulp.dest paths.elements.internal.pages.compileDest

gulp.task 'clean-internal-elements-injected-styles', ->
  gulp
    .src paths.elements.internal.styles.compiled, { read: false }
    .pipe $.debug()
    .pipe vinyl_paths del

gulp.task 'handle-external-resources', (cb) ->
  runSequence(
    'compile-external-resources-metas'
    'copy-external-resources-contents'
    cb
  )

gulp.task 'compile-external-resources-metas', ->
  for category in resourcesCategories
    gulp
      .src paths.resources.external.metas.toCompile(category)
      .pipe $.debug()
      .pipe $.cson().on('error', gutil.log)
      .pipe gulp.dest paths.resources.external.metas.compileDest(category)

gulp.task 'copy-external-resources-contents', ->
  for category in resourcesCategories
    gulp
      .src paths.resources.external.contents.toCopy(category), { dot: true }
      .pipe $.debug()
      .pipe gulp.dest paths.resources.external.contents.copyDest(category)

gulp.task 'handle-story', [ 'compile-story-characters', 'parse-story-script' ]

gulp.task 'compile-story-characters', ->
  gulp
    .src paths.story.characters.meta.toCompile
    .pipe $.debug()
    .pipe $.cson().on('error', gutil.log)
    .pipe gulp.dest paths.story.characters.meta.compileDest

gulp.task 'parse-story-script', (cb) ->
  path = require 'path'

  exec "coffee #{path.join __dirname, 'tools/script_parser/parser.coffee'} --input-file #{path.join __dirname, paths.story.mainScript.toParse[0]} --output-file #{path.join __dirname, paths.story.mainScript.parseDestFile}", (err, stdout, stderr) ->
    gutil.log stdout
    gutil.log stderr
    cb err

gulp.task 'cdnize-after-build', (cb) ->
  # TODO currently not that flexible and robust with string replacing
  # TODO currently lib version via CDN is hardcoded

  if options.cdn is false
    return runSequence('noop', cb)

  # 1. index: external libs like lodash, polyfills in index -> jsdelivr
  # 2. elements: external libs like proloadjs, -> jsdelivr
  # 2. elements: external polymer-related components in internal elements -> polygit
  # 3. TODO aurora components

  runSequence [ 'cdnize-index', 'cdnize-elements' ], cb

gulp.task 'cdnize-index', ->
  gulp
    .src paths.app.internal.index.toCdnize
    .pipe $.debug()
    .pipe $.replace "bower_components/lodash/dist/lodash.js", "https://cdn.jsdelivr.net/lodash/4.13.1/lodash.min.js"
    .pipe $.replace "bower_components/webcomponentsjs/webcomponents-lite.js", "https://cdn.jsdelivr.net/webcomponentsjs/0.7.22/webcomponents.min.js"
    # the same place
    .pipe gulp.dest (file) -> file.base

gulp.task 'cdnize-elements', ->
  switch options.cdn
    when 'wcdn'
      cdn_prefix = "https://cdn.wcdn.io/"
    when 'azure'
      cdn_prefix = "https://projectyorucdn.blob.core.windows.net/project-yoru-cdn/"
    when 'polygit'
      cdn_prefix = "https://polygit.org/components/"

  gulp
    .src paths.elements.internal.pages.compiled
    .pipe $.debug()
    # TODO PreloadJS on jsdelivr is still v0.3, the one on cdnjs is still v0.6.0, while the latest is v0.6.2
    .pipe $.replace "../../bower_components/PreloadJS/lib/preloadjs-0.6.2.combined.js", "https://cdnjs.cloudflare.com/ajax/libs/PreloadJS/0.6.0/preloadjs.min.js"
    .pipe $.replace "../../bower_components/", cdn_prefix
    .pipe gulp.dest (file) -> file.base # the same place

gulp.task 'bundle-after-build', (cb) ->
  sequence = []
  if options.bundle
    sequence.push 'bundle-index'
  else
    sequence.push 'noop'
  sequence.push cb

  runSequence.apply @, sequence

gulp.task 'bundle-index', (cb) ->
  gulp
    .src paths.app.internal.index.toBundle
    .pipe $.debug()
    .pipe $.vulcanize { inlineScripts: true, inlineCss: true, stripComments: true }
    .pipe $.htmlMinifier { collapseWhitespace: true, minifyCSS: true, minifyJS: true }
    .pipe gulp.dest paths.app.internal.index.bundleDest

gulp.task 'cleanup-after-build', (cb) ->
  src = []

  # clean up bundled app internal scripts, styles, aurora_components
  if options.bundle is true
    src = src
      .concat paths.elements.internal.folderToCleanup
      .concat paths.app.internal.styles.folderToCleanup
      .concat paths.app.internal.scripts.folderToCleanup

  # clean up bower dependencies, if they've been bundled, or they will be served via cdn
  if ( options.cdn is true ) or ( options.bundle is true )
    src = src.concat paths.dependencies.bower.folderToCleanup

  del src

gulp.task 'lint-after-build', (cb) ->
  sequence = []
  if options.lint
    sequence.push 'polylint'
  else
    sequence.push 'noop'
  sequence.push cb

  runSequence.apply @, sequence

gulp.task 'polylint', (cb) ->
  # TODO use gulp-polylint when it becomes mature
  # TODO use paths var
  errors = polylint 'dist/index.html'

  errors.then (errors) ->
    for warning in errors
      console.log "#{chalk.red(warning.filename)}:#{warning.location.line}:#{warning.location.column}\n#{chalk.gray(warning.message)}"

    # should put cb() here, but would cause some weird Promise related bug
    # cb()
  cb()

gulp.task 'build', (cb) ->

  runSequence(
    'clean'
    ['copy-dependencies', 'copy-config', 'copy-others']
    # TODO compile-app-pages compile-app-favicon
    [
      'compile-app-styles'
      'compile-app-scripts'
      'copy-internal-resources'
      'handle-internal-elements'
      'handle-external-resources'
      'handle-story'
    ]
    'cdnize-after-build'
    'bundle-after-build'
    'cleanup-after-build'
    'lint-after-build'
    cb
  )

gulp.task 'list-all-dependencing-components', ->
  # TODO list weirdly misses some components
  gulp
    .src paths.elements.internal.pages.compiled
    .pipe $.debug()
    .pipe $.replace /\.\.\/\.\.\/bower_components\/.*/, (component) -> console.log(component); component

gulp.task 'default', [ 'build' ]

# PARAMS:
# --bundle: true/false(nonexistent), default to false
# --cdn: false(nonexistent)/'polygit'/'azure'/'wcdn', default to undefined
# --lint: true/false(nonexistent), default to false

options =
  bundle: argv.bundle || false
  cdn: argv.cdn || false
  lint: argv.lint || false

console.log options
