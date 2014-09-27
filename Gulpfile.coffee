gulp = require 'gulp'
$ = require('gulp-load-plugins')()

# The order of files is important!
sources = [
  'src/globals.coffee',
  'src/util.coffee',
  'src/base.coffee',
  'src/fermentable.coffee',
  'src/spice.coffee',
  'src/yeast.coffee',
  'src/mashStep.coffee',
  'src/mash.coffee',
  'src/**/*.coffee'
]

gulp.task 'compile', ->
  gulp.src 'test/**/*.coffee'
    .pipe $.coffee(bare: true)
    .pipe gulp.dest('test')

  gulp.src sources
    .pipe $.coffeelint(max_line_length: {value: 120, level: 'warn'})
    .pipe $.coffeelint.reporter()
    .pipe $.concat('brauhaus.js')
    .pipe $.coffee(bare: true)
    .pipe gulp.dest('lib')
    .pipe $.rename('brauhaus.min.js')
    .pipe $.uglify(preserveComments: 'some')
    .pipe gulp.dest('dist')

gulp.task 'watch', ->
  gulp.watch 'src/**/*.coffee', ['compile']

gulp.task 'test', ['compile'], ->
  if process.env.CI
    gulp.src 'test/test.html'
      .pipe $.mochaPhantomjs()

  gulp.src 'test/**/*.coffee', read: false
    .pipe $.mocha(reporter: 'spec')

gulp.task 'coverage', ['compile'], ->
  gulp.src 'lib/**/*.js'
    .pipe $.istanbul()
    .on 'finish', ->
      gulp.src 'test/**/*.coffee', read: false
        .pipe $.mocha(reporter: 'spec')
        .pipe $.istanbul.writeReports
          reporters: ['text-summary', 'html', 'lcovonly']

gulp.task 'coveralls', ['coverage'], ->
  gulp.src 'coverage/lcov.info'
    .pipe $.coveralls()

gulp.task 'default', ['compile', 'watch']
