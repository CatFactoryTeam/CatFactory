var gulp = require('gulp');
var elm = require('gulp-elm');
var rename = require('gulp-rename');

gulp.task('elm-init', elm.init);

gulp.task('elm', ['elm-init'], function() {
  return gulp.src('src/Main.elm')
    .pipe(elm())
    .pipe(rename("main.js"))
    .pipe(gulp.dest('dist/'));
});

gulp.task('html', function() {
  return gulp.src('src/*.html')
    .pipe(gulp.dest('dist'))
});

gulp.task('css', function() {
  return gulp.src('src/css/**')
    .pipe(gulp.dest('dist/css'))
});

gulp.task('font', function() {
  return gulp.src('src/font/*')
    .pipe(gulp.dest('dist/font'))
});

gulp.task('img', function() {
  return gulp.src('src/img/*')
    .pipe(gulp.dest('dist/img'))
});

gulp.task('build', ['elm', 'html', 'css', 'font', 'img'])

gulp.task('default', ['build']);
