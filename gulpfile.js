var gulp = require('gulp');
var typescript = require('gulp-typescript');
var install = require('gulp-install');
var debug = require('gulp-debug');
var project = typescript.createProject("tsconfig.json")

gulp.task('project-npm', function (cb) {
	return gulp
		.src(['package.json'])
		.pipe(install());
});

gulp.task('task-npm', ['project-npm'], function (cb) {
	return gulp
		.src([
			'./Shared/**/package.json',
			'./Tasks/**/package.json',
			'!**/node_modules/**'
		])
        //.pipe(debug());
		.pipe(install());
});

gulp.task('typescript', ['task-npm'], function (cb) {
    return gulp
        .src([
            './typings/**/*.d.ts',
            './Shared/**/*.ts',
            './Tasks/**/*.ts'
        ], { base: "." })
        .pipe(typescript(project))
        .pipe(gulp.dest('.'));
});

gulp.task('default', ['project-npm', 'task-npm', 'typescript']);