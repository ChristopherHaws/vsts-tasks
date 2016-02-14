define(["require", "exports", "os", "fs", "child_process"], function (require, exports, operatingSystem, fileSystem, childProcess) {
    var appCmd = "";
    if (operatingSystem.arch() === "x64") {
        var appCmd = process.env["windir"] + "\\system32\\inetsrv\\appcmd.exe";
    }
    else {
        var appCmd = process.env["windir"] + "\\syswow64\\inetsrv\\appcmd.exe";
    }
    console.log(appCmd);
    if (!fileSystem.existsSync(appCmd)) {
        console.error(new Error("IIS 7 or greater must be installed."));
    }
    var child = childProcess.exec(appCmd);
    child.stdout.on('data', function (data) {
        console.log('stdout: ' + data);
    });
    child.stderr.on('data', function (data) {
        console.log('stdout: ' + data);
    });
    child.on('close', function (code) {
        console.log('closing code: ' + code);
    });
});
