import * as os from "os";
import * as vsts from "vsts-task-lib/task";
import * as toolRunner from "vsts-task-lib/toolrunner";

interface IisSite {
	name: string;
	bindings: string;
	path: string;
}

class IIS {
	private toolRunner: toolRunner.ToolRunner;
	
	constructor() {
		if (os.arch() === "x64") {
			this.toolRunner = vsts.createToolRunner(process.env["windir"] + "\\syswow64\\inetsrv\\appcmd.exe");
		} else {
			this.toolRunner = vsts.createToolRunner(process.env["windir"] + "\\system32\\inetsrv\\appcmd.exe");
		}
	}
	
	public createSite(options: IisSite): void {
		vsts.debug("Creating site...");
		this.toolRunner.arg("add site");
		this.toolRunner.arg(["/name:", options.name]);
		this.toolRunner.arg(["/bindings:", options.bindings]);
		this.toolRunner.argIf(options.path, ["/physicalPath:", options.path]);
		var results = this.toolRunner.execSync();
	}
}