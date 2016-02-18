var os = require("os");
var vsts = require("vsts-task-lib/task");
var IIS = (function () {
    function IIS() {
        if (os.arch() === "x64") {
            this.toolRunner = vsts.createToolRunner(process.env["windir"] + "\\syswow64\\inetsrv\\appcmd.exe");
        }
        else {
            this.toolRunner = vsts.createToolRunner(process.env["windir"] + "\\system32\\inetsrv\\appcmd.exe");
        }
    }
    IIS.prototype.createSite = function (options) {
        vsts.debug("Creating site...");
        this.toolRunner.arg("add site");
        this.toolRunner.arg(["/name:", options.name]);
        this.toolRunner.arg(["/bindings:", options.bindings]);
        this.toolRunner.argIf(options.path, ["/physicalPath:", options.path]);
        var results = this.toolRunner.execSync();
    };
    return IIS;
})();
