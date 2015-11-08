# TODO
# watch
# minify js, css, html
# uglify
# jslint
# optimize images
# handle fonts
# ver
# usemin
# polyserve

gulp = require('gulp')
$ = require('gulp-load-plugins')()
runSequence = require('run-sequence')
del = require('del')
gutil = require('gutil')

paths = 
  scripts:
    forElements: [ 'app/elements/*/*.coffee' ]
    forApp: [ 'app/scripts/*.coffee' ]
  pages:
    toCompile: [ 'app/elements/*/*.haml' ]
    compiled: [ 'dist/elements/*/*.html' ]
  styles:
    forElements:
      toCompile: [ 'app/elements/*/*.sass' ]
      compiled: [ 'dist/elements/*/*.css' ]
    forApp:
      [ 'app/styles/*.sass' ]
  resources:
    meta: [ 'app/resources/*/*.cson' ]
    content: [ 'app/resources/*/*.*', '!app/resources/*/*.cson' ]
  dependencies: [ 'bower_components/**/*' ]
  elements:
    toVulcanize: [ 'dist/elements/elements.html' ]
    vulcanized: [ 'dist/elements/elements.vulcanized.html' ]
  othersToCopy: [ 'app/*.*' ]

gulp.task 'clean', (cb) ->
  del [ '.tmp', 'dist/*' ], cb

gulp.task 'copy', ['copy-dependencies', 'copy-resources-content', 'copy-others']
gulp.task 'copy-dependencies', ->
  # TODO link instead of copy
  gulp
    .src paths.dependencies
    .pipe gulp.dest 'dist/bower_components'

gulp.task 'copy-resources-content', ->
  gulp
    .src paths.resources.content
    .pipe gulp.dest 'dist/resources'

gulp.task 'copy-others', ->
  gulp
    .src paths.othersToCopy
    .pipe gulp.dest 'dist'

gulp.task 'compile-resources-meta', ->
  gulp
    .src paths.resources.meta
    .pipe $.cson().on('error', gutil.log)
    .pipe gulp.dest('dist/resources')

gulp.task 'compile-scripts', ->
  runSequence [ 'compile-scripts-for-elements', 'compile-scripts-for-app' ]

gulp.task 'compile-scripts-for-elements', ->
  gulp
    .src paths.scripts.forElements
    .pipe $.coffee(bare: false).on('error', gutil.log)
    .pipe gulp.dest('dist/elements')

gulp.task 'compile-scripts-for-app', ->
  gulp
    .src paths.scripts.forApp
    .pipe $.coffee(bare: false).on('error', gutil.log)
    .pipe gulp.dest('dist/scripts')

gulp.task 'compile-pages', ->
  gulp
    .src paths.pages.toCompile
    .pipe $.rubyHaml().on('error', gutil.log)
    .pipe gulp.dest('dist/elements')

gulp.task 'handle-styles', (cb) ->
  runSequence [ 'compile-styles-for-elements', 'compile-styles-for-app' ], 'inject-styles', cb

gulp.task 'compile-styles-for-elements', ->
  $.rubySass paths.styles.forElements.toCompile
    .on 'error', gutil.log
    .pipe $.wrapper
      header: '<style>'
      footer: '</style>'
    .pipe gulp.dest 'dist/elements'

gulp.task 'compile-styles-for-app', ->
  $.rubySass paths.styles.forApp
    .on 'error', gutil.log
    .pipe gulp.dest 'dist/styles'

gulp.task 'inject-styles', ->
  gulp
    .src paths.pages.compiled
    .pipe $.fileInclude()
    .pipe gulp.dest 'dist/elements'

gulp.task 'compress-pages', ->
  runSequence 'compress-elements', 'replace-min'

gulp.task 'compress-elements', ->
  gulp
    .src 'app/elements/elements.html'
    .pipe gulp.dest 'dist/elements'
    .pipe $.vulcanize()
    .pipe $.rename 'elements.vulcanized.html'
    .pipe gulp.dest 'dist/elements/'

gulp.task 'replace-min', ->
  gulp
    .src 'dist/index.html'
    .pipe $.replace 'src=\"bower_components/webcomponentsjs/webcomponents-lite.js\"', 'src=\"bower_components/webcomponentsjs/webcomponents-lite.min.js\"'
    .pipe $.replace 'href=\"elements/elements.html\"', 'href=\"elements/elements.vulcanized.html\"'
    .pipe gulp.dest 'dist/'

gulp.task 'clean-phonegap', (cb) ->
  del(
    [ '../aozora-phonegap-build/*', '!../aozora-phonegap-build/.gitignore', '!../aozora-phonegap-build/README.md', '!../aozora-phonegap-build/LICENSE' ],
    {
      force: true
    },
    cb)

gulp.task 'copy-phonegap', ->
  gulp
    .src [
      'dist/**/*',
      'config.xml'
    ]
    .pipe gulp.dest '../aozora-phonegap-build'

gulp.task 'build', (cb) ->
  runSequence(
    'clean',
    'copy',
    ['compile-resources-meta', 'compile-scripts', 'compile-pages'],
    'handle-styles',
    'compress-pages'
    cb
  )

gulp.task 'build-phonegap', (cb) ->
  runSequence [ 'build', 'clean-phonegap' ], 'copy-phonegap'

gulp.task 'default', [ 'build' ]
