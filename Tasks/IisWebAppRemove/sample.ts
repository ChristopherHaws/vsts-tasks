import * as path from "path";
import * as tl from "vsts-task-lib/task";
import * as toolRunner from "vsts-task-lib/toolrunner";

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
