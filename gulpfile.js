var gulp = require('gulp');
var del = require('del');
var tsc = require('gulp-tsc');

// gulp.task('clean', function (cb) {
//     del([_buildRoot, _pkgRoot, _wkRoot, _oldPkg], cb);
// });

gulp.task('build', function (cb) {
    return gulp
		.src(['Tasks/**/*.ts'])
        .pipe(tsc());
});

gulp.task('default', ['build']);