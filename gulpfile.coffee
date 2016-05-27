# TODO

# watch
# jslint
# optimize images
# handle fonts

argv = require('yargs').argv
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

gulp.task 'optimize-after-build', (cb) ->
  sequence = []
  switch options.env
    when 'dev'
      sequence.push 'noop'
    when 'prod'
      sequence.push 'bundle-index'
      sequence.push 'cleanup-after-bundle'
  sequence.push cb

  runSequence.apply @, sequence

gulp.task 'bundle-index', (cb) ->
  gulp
    .src paths.app.internal.index.toBundle
    .pipe $.debug()
    .pipe $.vulcanize { inlineScripts: true, inlineCss: true, stripComments: true }
    .pipe $.htmlMinifier { collapseWhitespace: true, minifyCSS: true, minifyJS: true }
    .pipe gulp.dest paths.app.internal.index.bundleDest

gulp.task 'cleanup-after-bundle', (cb) ->
  # clean up bundled bower_components, aurora_components, app internal scripts, styles
  src = []
    .concat paths.dependencies.bower.folderToCleanup
    .concat paths.elements.internal.folderToCleanup
    .concat paths.app.internal.styles.folderToCleanup
    .concat paths.app.internal.scripts.folderToCleanup

  del src

gulp.task 'lint-after-build', (cb) ->
  sequence = []
  switch options.env
    when 'dev'
      sequence.push 'polylint'
    when 'prod'
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

  cb()

options = {}

gulp.task 'build', (cb) ->
  # PARAMS:
  # --env: prod/dev

  options.env = argv.env || 'dev'

  console.log options

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
    'optimize-after-build'
    'lint-after-build'
    cb
  )

gulp.task 'default', [ 'build' ]
