# TODO

# - read & parse config at first
# - vulcanize index
# - use `title` option in gulp-debug, https://stackoverflow.com/questions/27161903/how-to-get-task-name-inside-task-in-gulp
# - use `usemin` for app scripts deps like webcomponentsjs, lodash, etc.

# watch
# minify js, css, html
# uglify
# jslint
# optimize images
# handle fonts
# ver
# usemin
# polyserve

argv = require('yargs').argv
gulp = require('gulp')
$ = require('gulp-load-plugins')()
runSequence = require('run-sequence')
gutil = require('gutil')
exec = require('child_process').exec

resourcesCategories = ['backgrounds', 'images', 'music', 'sounds', 'tachies', 'videos', 'voices']
paths =
  dependencies:
    bower:
      toCopy: [ 'bower_components/**' ]
      copyDest: 'dist/bower_components/'
      copied: [ 'dist/bower_components/**/*' ]
      reservedFiles: [ '!dist/bower_components/webcomponentsjs/webcomponents-lite.min.js', '!dist/bower_components/lodash/lodash.min.js' ]
  app:
    internal:
      index:
        compileDest: 'dist/'
        compiled: [ 'dist/index.html' ]
      styles:
        toCompile: [ 'app/$styles/*.sass' ]
        compileDest: 'dist/$styles'
      scripts:
        toCompile: [ 'app/$scripts/*.coffee' ]
        compileDest: 'dist/$scripts'
  elements:
    internal:
      inventory:
        toCopy: [ 'app/$elements/elements.html' ]
        copyDest: 'dist/$elements/'
        copied: [ 'dist/$elements/elements.html' ]
        toVulcanize: [ 'dist/$elements/elements.html' ]
        vulcanizeDest: 'dist/$elements/'
        vulcanized: [ 'dist/$elements/elements.vulcanized.html' ]
      pages:
        toCompile: [ 'app/$elements/*/*.haml' ]
        compileDest: 'dist/$elements'
        compiled: 'dist/$elements/*/*.html'
      styles:
        toCompile: [ 'app/$elements/*/*.sass' ]
        compileDest: 'dist/$elements'
        compiled: 'dist/$elements/*/*.css'
      scripts:
        toCompile: [ 'app/$elements/*/*.coffee' ]
        compileDest: 'dist/$elements'
      folders:
        compiled: [ 'dist/$elements/*', '!dist/$elements/*.*' ]
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

gulp.task 'clean', (cb) ->
  gulp
    .src [ '.tmp', 'dist' ], { read: false }
    .pipe $.rimraf()

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
  switch options.env
    when 'dev'
      runSequence(
        [ 'compile-internal-elements-pages', 'compile-internal-elements-styles', 'compile-internal-elements-scripts' ]
        'inject-internal-elements-styles'
        'clean-internal-elements-injected-styles'
        'copy-internal-elements-inventory'
        cb
      )
    when 'prod'
      runSequence(
        [ 'compile-internal-elements-pages', 'compile-internal-elements-styles', 'compile-internal-elements-scripts' ]
        'inject-internal-elements-styles'
        'clean-internal-elements-injected-styles'
        'copy-internal-elements-inventory'
        'vulcanize-internal-elements-inventory'
        'replace-internal-elements-inventory-to-vulcanized'
        'cleanup-after-handling-internal-elements'
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
    .pipe $.rimraf()

gulp.task 'copy-internal-elements-inventory', ->
  gulp
    .src paths.elements.internal.inventory.toCopy
    .pipe $.debug()
    .pipe gulp.dest paths.elements.internal.inventory.copyDest

gulp.task 'vulcanize-internal-elements-inventory', ->
  gulp
    .src paths.elements.internal.inventory.toVulcanize
    .pipe $.debug()
    .pipe $.vulcanize { inlineScripts: true, stripComments: true }
    .pipe $.rename 'elements.vulcanized.html'
    .pipe gulp.dest paths.elements.internal.inventory.vulcanizeDest

gulp.task 'replace-internal-elements-inventory-to-vulcanized', ->
  # also will replace webcomponents-lite.js to min version, thought should not be placed in this task
  # TODO consider use some gulp plugin like gulp-usemin, instead of gulp-replace
  gulp
    .src paths.app.internal.index.compiled
    .pipe $.debug()
    .pipe $.replace 'src=\"bower_components/webcomponentsjs/webcomponents-lite.js\"', 'src=\"bower_components/webcomponentsjs/webcomponents-lite.min.js\"'
    .pipe $.replace 'href=\"$elements/elements.html\"', 'href=\"$elements/elements.vulcanized.html\"'
    .pipe gulp.dest paths.app.internal.index.compileDest

gulp.task 'cleanup-after-handling-internal-elements', ->
  # clean up individual elements, bower components
  gulp
    .src [].concat( paths.elements.internal.folders.compiled, paths.dependencies.bower.copied, paths.dependencies.bower.reservedFiles ), { read: false }
    .pipe $.debug()
    .pipe $.rimraf()

  # clean up former inventory(elements.html)
  gulp
    .src paths.elements.internal.inventory.copied
    .pipe $.debug()
    .pipe $.rimraf()

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
    cb
  )

gulp.task 'default', [ 'build' ]
