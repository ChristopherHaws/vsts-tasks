var gulp = require('gulp');
var del = require('del');
var typescript = require('gulp-typescript');
var install = require('gulp-install');
var tsd = require('gulp-tsd');
var project = typescript.createProject("tsconfig.json");

// gulp.task('clean', function (cb) {
//     del([_buildRoot, _pkgRoot, _wkRoot, _oldPkg], cb);
// });

gulp.task('install-task-dependencies', function (cb) {
    return gulp
		.src(['./Tasks/**/package.json'])
        .pipe(install());
});

gulp.task('tsd', function (cb) {
    return gulp
		.src(['./Tasks/**/tsd.json'])
        .pipe(tsd());
});

gulp.task('build', function (cb) {
    return gulp
		.src([
			'./typings/**/*.d.ts',
			'./Tasks/**/*.ts'
		])
        .pipe(typescript(project))
		.pipe(gulp.dest('./_build/'));
});

gulp.task('copy-task-files', function (cb) {
    return gulp
		.src([
			'./Tasks/**/task.json',
			'./Tasks/**/icon.png',
			'./Tasks/**/*.ps1'
		])
		.pipe(gulp.dest('./_build/'));
});

gulp.task('default', [
	'install-task-dependencies',
	'build',
	'copy-task-files'
]);