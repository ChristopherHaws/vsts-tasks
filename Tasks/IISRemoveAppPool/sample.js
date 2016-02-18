var path = require("path");
var tl = require("vsts-task-lib/task");
var toolRunner = require("vsts-task-lib/toolrunner");

var echo = new toolRunner.ToolRunner(tl.which('echo', true));

var msg = tl.getInput('msg', true);
echo.arg(msg);

var cwd = tl.getPathInput('cwd', false);

// will error and fail task if it doesn't exist
tl.checkPath(cwd, 'cwd');
tl.cd(cwd);

echo.exec({ failOnStdErr: false } as toolRunner.IExecOptions)
	.then(function(code) {
		tl.exit(code);
	})
	.fail(function(err) {
		console.error(err.message);
		tl.debug('taskRunner fail');
		tl.exit(1);
	})
