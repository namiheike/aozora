# TODO

# del -> gulp-rimraf

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
gutil = require('gutil')

paths = 
  dependencies:
    bower:
      toCopy: [ 'bower_components/**' ]
      copyDest: 'dist/bower_components/'
      copied: [ 'dist/bower_components' ]
  # scripts:
  #   internal:
  #     forElements:
  #       files: [ 'app/_elements/*/*.coffee' ]
  #     forApp:
  #       folder: [ 'app/_scripts' ]
  #       files: [ 'app/_scripts/*.coffee' ]
  # pages:
  #   internal:
  #     toCompile: [ 'app/elements/*/*.haml' ]
  #     compiled: [ 'dist/elements/*/*.html' ]
  # styles:
  #   internal:
  #     forElements:
  #       toCompile: [ 'app/elements/*/*.sass' ]
  #       compiled: [ 'dist/elements/*/*.css' ]
  #     forApp:
  #       [ 'app/styles/*.sass' ]
  app:
    internal:
      index:
        compileDest: 'dist/'
        compiled: [ 'dist/index.html' ]
      styles:
        toCompile: [ 'app/_styles/*.sass' ]
        compileDest: 'dist/_styles'
      scripts:
        toCompile: [ 'app/_scripts/*.coffee' ]
        compileDest: 'dist/_scripts'
  elements:
    internal:
      inventory:
        toCopy: [ 'app/_elements/elements.html' ]
        copyDest: 'dist/_elements/'
        copied: [ 'dist/_elements/elements.html' ]
        toVulcanize: [ 'dist/_elements/elements.html' ]
        vulcanizeDest: 'dist/_elements/'
        vulcanized: [ 'dist/_elements/elements.vulcanized.html' ]
      pages:
        toCompile: [ 'app/_elements/*/*.haml' ]
        compileDest: 'dist/_elements'
        compiled: 'dist/_elements/*/*.html'
      styles:
        toCompile: [ 'app/_elements/*/*.sass' ]
        compileDest: 'dist/_elements'
        compiled: 'dist/_elements/*/*.css'
      scripts:
        toCompile: [ 'app/_elements/*/*.coffee' ]
        compileDest: 'dist/_elements'
      folders:
        compiled: [ 'dist/_elements/*', '!dist/_elements/*.*' ]
  resources:
    internal:
      toCopy: [ 'app/_resources/**/*' ]
      copyDest: 'dist/_resources'

  # resources:
  #   internal:
  #     folder: [ 'app/_resources' ]
  #   external:
  #     meta: [ 'app/resources/*/*.cson' ]
  #     content: [ 'app/resources/*/*.*', '!app/resources/*/*.cson' ]
  # config:
  #   external: []
  # story:
  #   external: []
  # externalContents:
  #   source: [ 'app/config', 'app/resources', 'app/story' ]
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

gulp.task 'copy-others', ->
  # favicon, index.html
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
    [ 'compile-internal-elements-pages', 'compile-internal-elements-styles', 'compile-internal-elements-scripts' ],
    'inject-internal-elements-styles',
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
    .pipe $.replace 'href=\"_elements/elements.html\"', 'href=\"_elements/elements.vulcanized.html\"'
    .pipe gulp.dest paths.app.internal.index.compileDest

gulp.task 'cleanup-after-handling-internal-elements', ->
  # clean up individual elements, bower components
  gulp
    .src [].concat( paths.elements.internal.folders.compiled, paths.dependencies.bower.copied ), { read: false }
    .pipe $.debug()
    .pipe $.rimraf()

  # clean up former inventory(elements.html)
  gulp
    .src paths.elements.internal.inventory.copied
    .pipe $.debug()
    .pipe $.rimraf()

# gulp.task 'compile-resources-meta', ->
#   gulp
#     .src paths.resources.meta
#     .pipe $.cson().on('error', gutil.log)
#     .pipe gulp.dest('dist/resources')

# gulp.task 'compile-scripts', ->
#   runSequence [ 'compile-scripts-for-elements', 'compile-scripts-for-app' ]

# gulp.task 'compile-scripts-for-elements', ->
#   gulp
#     .src paths.scripts.forElements
#     .pipe $.coffee(bare: false).on('error', gutil.log)
#     .pipe gulp.dest('dist/elements')

# gulp.task 'compile-scripts-for-app', ->
#   gulp
#     .src paths.scripts.forApp
#     .pipe $.coffee(bare: false).on('error', gutil.log)
#     .pipe gulp.dest('dist/_scripts')

# gulp.task 'compile-pages', ->
#   gulp
#     .src paths.pages.toCompile
#     .pipe $.rubyHaml().on('error', gutil.log)
#     .pipe gulp.dest('dist/elements')

# gulp.task 'handle-styles', (cb) ->
#   runSequence [ 'compile-styles-for-elements', 'compile-styles-for-app' ], 'inject-styles', cb

# gulp.task 'compile-styles-for-elements', ->
#   $.rubySass paths.styles.forElements.toCompile
#     .on 'error', gutil.log
#     .pipe $.wrapper
#       header: '<style>'
#       footer: '</style>'
#     .pipe gulp.dest 'dist/elements'

# gulp.task 'compile-styles-for-app', ->
#   $.rubySass paths.styles.forApp
#     .on 'error', gutil.log
#     .pipe gulp.dest 'dist/styles'

# gulp.task 'inject-styles', ->
#   gulp
#     .src paths.pages.compiled
#     .pipe $.fileInclude()
#     .pipe gulp.dest 'dist/elements'

# gulp.task 'compress-pages', (cb) ->
#   runSequence 'compress-elements', 'replace-min', cb

# gulp.task 'compress-elements', ->
#   gulp
#     .src path.elements.internal.toVulcanize
#     .pipe gulp.dest path.elements.internal.vulcanized
#     .pipe $.vulcanize { inlineScripts: true }
#     .pipe $.rename 'elements.vulcanized.html'
#     .pipe gulp.dest 'dist/elements/'

# gulp.task 'replace-min', ->
#   gulp
#     .src 'dist/index.html'
#     .pipe $.replace 'src=\"bower_components/webcomponentsjs/webcomponents-lite.js\"', 'src=\"bower_components/webcomponentsjs/webcomponents-lite.min.js\"'
#     .pipe $.replace 'href=\"_elements/elements.html\"', 'href=\"_elements/elements.vulcanized.html\"'
#     .pipe gulp.dest 'dist/'

# TODO rename phonegap-build repo name with prefix aurora
# gulp.task 'clean-phonegap', (cb) ->
#   del(
#     [ '../aozora-phonegap-build/*', '!../aozora-phonegap-build/.gitignore', '!../aozora-phonegap-build/README.md', '!../aozora-phonegap-build/LICENSE' ],
#     {
#       force: true
#     },
#     cb)

# gulp.task 'copy-phonegap', ->
#   gulp
#     .src [
#       'dist/**/*',
#       'config.xml'
#     ]
#     .pipe gulp.dest '../aozora-phonegap-build'

gulp.task 'build', (cb) ->
  runSequence(
    'clean'
    ['copy-dependencies', 'copy-others']
    # TODO compile-app-pages compile-app-favicon
    ['compile-app-styles', 'compile-app-scripts', 'copy-internal-resources', 'handle-internal-elements']
    # ['compile-resources-meta', 'compile-scripts', 'compile-pages']
    # 'handle-styles'
    # 'compress-pages'
    # clean up to remove bower depends
    cb
  )

# gulp.task 'build-phonegap', (cb) ->
#   runSequence 'build', 'clean-phonegap', 'copy-phonegap'
#   # TODO auto git add, commit, push and call phonegap build url to update code and rebuild

gulp.task 'default', [ 'build' ]
