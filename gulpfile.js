var gulp = require('gulp');
var install = require('gulp-install');
var debug = require('gulp-debug');

gulp.task('task-npm', function (cb) {
    return gulp
		.src(['./Tasks/**/package.json', '!**/node_modules/**'])
        //.pipe(debug());
		.pipe(install());
});

gulp.task('default', ['task-npm']);