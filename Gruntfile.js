'use strict';

module.exports = function (grunt) {
  // show elapsed time at the end
  require('time-grunt')(grunt);
  // load all grunt tasks
  require('load-grunt-tasks')(grunt);

  // configurable paths
  var yeomanConfig = {
    app: 'app',
    dist: 'dist'
  };

  grunt.initConfig({
    yeoman: yeomanConfig,
    watch: {
      // TODO dont fit for coffee, cson, haml, etc.
      options: {
        nospawn: true
      },
      default: {
        files: [
          '<%= yeoman.app %>/*.html',
          '<%= yeoman.app %>/elements/{,*/}*.html',
          '{.tmp,<%= yeoman.app %>}/elements/{,*/}*.{css,js}',
          '{.tmp,<%= yeoman.app %>}/styles/{,*/}*.css',
          '{.tmp,<%= yeoman.app %>}/scripts/{,*/}*.js',
          '<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
      },
      js: {
        files: ['<%= yeoman.app %>/scripts/{,*/}*.js'],
        tasks: ['jshint']
      },
      styles: {
        files: [
          '<%= yeoman.app %>/styles/{,*/}*.css',
          '<%= yeoman.app %>/elements/{,*/}*.css'
        ],
        tasks: ['copy:styles', 'autoprefixer:server']
      },
      sass: {
        files: [
          '<%= yeoman.app %>/styles/{,*/}*.{scss,sass}',
          '<%= yeoman.app %>/elements/{,*/}*.{scss,sass}'
        ],
        tasks: ['sass:server', 'autoprefixer:server']
      }
    },
    // Compiles Haml
    haml: {
      compile: {
        options: {
          trace: true,
          bundleExec: true,
          style: 'expanded'
        },
        files: [{
          expand: true,
          flatten: false,
          cwd: '<%= yeoman.app %>',
          src: [ 'index.haml', 'elements/{,*/}*.haml' ],
          dest: '<%= yeoman.dist %>',
          ext: '.html'
        }]
      }
    },
    // Compiles Coffee
    coffee: {
      dist: {
        options: {
          trace: true,
          bare: false,
          sourceMap: false
        },
        files: [{
          expand: true,
          flatten: false,
          cwd: '<%= yeoman.app %>',
          src: ['scripts/{,*/}*.coffee', 'elements/{,*/}*.coffee'],
          dest: '<%= yeoman.dist %>',
          ext: '.js'
        }]
      },
    },
    // Compiles Sass to CSS and generates necessary files if requested
    sass: {
      options: {
        loadPath: 'bower_components'
      },
      dist: {
        options: {
          style: 'compressed'
        },
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>',
          src: ['styles/{,*/}*.{scss,sass}', 'elements/{,*/}*.{scss,sass}'],
          dest: '<%= yeoman.dist %>',
          ext: '.css'
        }]
      },
      server: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>',
          src: ['styles/{,*/}*.{scss,sass}', 'elements/{,*/}*.{scss,sass}'],
          dest: '.tmp',
          ext: '.css'
        }]
      }
    },
    stamp: {
      for_custom_styles_in_sass: {
        options: {
          banner: '<style is="custom-style">',
          footer: '</style>'
        },
        files: [{
          expand: true,
          cwd: '<%= yeoman.dist %>',
          src: ['elements/{,*/}*.css'],
        }]
      }
    },
    // Compiles cson to json
    cson: {
      compile:{
        expand: true,
        cwd: '<%= yeoman.app %>',
        src: [ 'resources/**/*.cson' ],
        dest: '<%= yeoman.dist %>',
        ext: '.json'
      }
    },
    autoprefixer: {
      options: {
        browsers: ['last 2 versions']
      },
      server: {
        files: [{
          expand: true,
          cwd: '.tmp',
          src: '**/*.css',
          dest: '.tmp'
        }]
      },
      dist: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.dist %>',
          src: ['**/*.css', '!bower_components/**/*.css'],
          dest: '<%= yeoman.dist %>'
        }]
      }
    },
    browserSync: {
      options: {
        notify: false,
        port: 9000,
        open: true
      },
      app: {
        options: {
          watchTask: true,
          injectChanges: false, // can't inject Shadow DOM
          server: {
            baseDir: ['.tmp', '<%= yeoman.app %>'],
            routes: {
              '/bower_components': 'bower_components'
            }
          }
        },
        src: [
          '.tmp/**/*.{css,html,js}',
          '<%= yeoman.app %>/**/*.{css,html,js}'
        ]
      },
      dist: {
        options: {
          server: {
            baseDir: 'dist'
          }
        },
        src: [
          '<%= yeoman.dist %>/**/*.{css,html,js}',
          '!<%= yeoman.dist %>/bower_components/**/*'
        ]
      }
    },
    clean: {
      dist: ['.tmp', '<%= yeoman.dist %>/*'],
      server: '.tmp',
      phonegap: {
        options: {
          force: true
        },
        src: ['../aozora-phonegap-build/*', '!../aozora-phonegap-build/.gitignore', '!../aozora-phonegap-build/README.md', '!../aozora-phonegap-build/LICENSE']
      }
    },
    jshint: {
      options: {
        jshintrc: '.jshintrc',
        reporter: require('jshint-stylish')
      },
      all: [
        '<%= yeoman.app %>/scripts/{,*/}*.js',
        '!<%= yeoman.app %>/scripts/vendor/*',
        'test/spec/{,*/}*.js'
      ]
    },
    useminPrepare: {
      html: '<%= yeoman.app %>/index.html',
      options: {
        dest: '<%= yeoman.dist %>'
      }
    },
    usemin: {
      html: ['<%= yeoman.dist %>/{,*/}*.html'],
      css: ['<%= yeoman.dist %>/styles/{,*/}*.css'],
      options: {
        dirs: ['<%= yeoman.dist %>']
      }
    },
    replace: {
      dist: {
        options: {
          patterns: [{
            match: /elements\/elements\.html/g,
            replacement: 'elements/elements.vulcanized.html'
          }]
        },
        files: {
          '<%= yeoman.dist %>/index.html': ['<%= yeoman.dist %>/index.html']
        }
      },
      phonegap_resources: {
        options: {
          patterns: [
            {
              match: /\.\.\/resources\//,
              replacement: 'resources\/'
            }
          ]
        },
        files: {
          '<%= yeoman.dist %>/elements/aozora-resources/aozora-resources.js': ['<%= yeoman.dist %>/elements/aozora-resources/aozora-resources.js']
        }
      }
    },
    vulcanize: {
      default: {
        options: {
          strip: true,
          inline: true
        },
        files: {
          '<%= yeoman.dist %>/elements/elements.vulcanized.html': [
            '<%= yeoman.dist %>/elements/elements.html'
          ]
        }
      }
    },
    // imagemin: {
    //   dist: {
    //     files: [{
    //       expand: true,
    //       cwd: '<%= yeoman.app %>/images',
    //       src: '{,*/}*.{png,jpg,jpeg,svg}',
    //       dest: '<%= yeoman.dist %>/images'
    //     }]
    //   }
    // },
    minifyHtml: {
      options: {
        quotes: true,
        empty: true,
        spare: true
      },
      app: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.dist %>',
          src: '*.html',
          dest: '<%= yeoman.dist %>'
        }]
      }
    },
    copy: {
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= yeoman.app %>',
          dest: '<%= yeoman.dist %>',
          src: [
            '*.{ico,txt}',
            '.htaccess',
            '*.html',
            'elements/**',
            '!elements/**/*.haml',
            '!elements/**/*.scss',
            '!elements/**/*.sass',
            '!elements/**/*.coffee',
            'resources/**/*',
            '!resources/**/*.cson'
          ]
        }, {
          expand: true,
          dot: true,
          dest: '<%= yeoman.dist %>',
          src: ['bower_components/**']
        }]
      },
      styles: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>',
          dest: '.tmp',
          src: ['{styles,elements}/{,*/}*.css']
        }]
      },
      phonegap: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= yeoman.dist %>',
          dest: '../aozora-phonegap-build',
          src: ['*', '**']
        },{
          expand: true,
          dot: true,
          dest: '../aozora-phonegap-build',
          src: ['config.xml']
        }]
      }
    },
    // See this tutorial if you'd like to run PageSpeed
    // against localhost: http://www.jamescryer.com/2014/06/12/grunt-pagespeed-and-ngrok-locally-testing/
    pagespeed: {
      options: {
        // By default, we use the PageSpeed Insights
        // free (no API key) tier. You can use a Google
        // Developer API key if you have one. See
        // http://goo.gl/RkN0vE for info
        nokey: true
      },
      // Update `url` below to the public URL for your site
      mobile: {
        options: {
          url: "https://developers.google.com/web/fundamentals/",
          locale: "en_GB",
          strategy: "mobile",
          threshold: 80
        }
      }
    }
  });

  grunt.registerTask('server', function (target) {
    grunt.log.warn('The `server` task has been deprecated. Use `grunt serve` to start a server.');
    grunt.task.run(['serve:' + target]);
  });

  grunt.registerTask('serve', function (target) {
    if (target === 'dist') {
      return grunt.task.run(['build', 'browserSync:dist']);
    }

    grunt.task.run([
      'clean:server',
      'sass:server',
      'copy:styles',
      'autoprefixer:server',
      'browserSync:app',
      'watch'
    ]);
  });

  grunt.registerTask('build', [
    'clean:dist',
    'haml',
    'coffee:dist',
    'cson',
    'sass',
    'copy:dist',
    'copy:styles',
    'useminPrepare',
    // 'imagemin',
    'concat',
    'autoprefixer',
    // 'stamp:for_custom_styles_in_sass',
    'uglify',
    // 'vulcanize', //disable vulcanize for developing
    'usemin',
    // 'replace', //disable vulcanize for developing
    'minifyHtml'
  ]);

  grunt.registerTask('build-production', [
    'clean:dist',
    'haml',
    'coffee:dist',
    'cson',
    'sass',
    'copy:dist',
    'copy:styles',
    'useminPrepare',
    // 'imagemin',
    'concat',
    'autoprefixer',
    // 'stamp:for_custom_styles_in_sass',
    'uglify',
    'vulcanize',
    'usemin',
    'replace:dist',
    'minifyHtml'
  ]);

  grunt.registerTask('build-phonegap', [
    // TODO auto git command
    'clean:dist',
    'haml',
    'coffee:dist',
    'cson',
    'sass',
    'copy:dist',
    'copy:styles',
    'useminPrepare',
    // 'imagemin',
    'concat',
    'autoprefixer',
    'uglify',
    'replace:phonegap_resources',
    'vulcanize',
    'usemin',
    'replace:dist',
    'minifyHtml',
    'clean:phonegap',
    'copy:phonegap'
  ]);

  grunt.registerTask('default', [
    'jshint',
    // 'test'
    'build'
  ]);
};
