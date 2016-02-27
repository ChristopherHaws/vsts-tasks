import * as vsts from "vsts-task-lib/task";
import * as iis from "vsts-iis";

var name = vsts.getInput("AppPoolName", true);

iis.AppPools.exists(name)
	.then(exists => {
		if (exists) {
			return iis.AppPools.remove(name);
		} else {
			vsts.warning("AppPool does not exist.");
			vsts.exit(0);
		}
	})
	.then(() => {
		vsts.exit(0);
	})
	.fail(() => {
		vsts.exit(1);
	});