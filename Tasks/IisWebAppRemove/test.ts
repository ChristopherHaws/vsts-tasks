import * as operatingSystem from "os";
import * as fileSystem from "fs";
import * as childProcess from "child_process";
import * as task from "vsts-task-lib/task";

var appCmd = "";

if(operatingSystem.arch() === "x64") {
    var appCmd = process.env["windir"] + "\\system32\\inetsrv\\appcmd.exe";
} else {
    var appCmd = process.env["windir"] + "\\syswow64\\inetsrv\\appcmd.exe";
}

console.log(appCmd);

if (!fileSystem.existsSync(appCmd)) {
    console.error(new Error("IIS 7 or greater must be installed."));
}

var child = childProcess.exec(appCmd);

child.stdout.on('data', function(data: any) {
    console.log('stdout: ' + data);
});

child.stderr.on('data', function(data: any) {
    console.log('stdout: ' + data);
});

child.on('close', function(code: any) {
    console.log('closing code: ' + code);
});