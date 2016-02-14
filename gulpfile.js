var gulp = require('gulp');
var del = require('del');
var typescript = require('gulp-typescript');
var project = typescript.createProject("tsconfig.json");

// gulp.task('clean', function (cb) {
//     del([_buildRoot, _pkgRoot, _wkRoot, _oldPkg], cb);
// });

gulp.task('build', function (cb) {
    return gulp
		.src([
			'typings/**/*.d.ts',
			'Tasks/**/*.ts'
		])
        .pipe(typescript(project));
});

gulp.task('default', ['build']);