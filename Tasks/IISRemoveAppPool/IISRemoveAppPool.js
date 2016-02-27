var vsts = require("vsts-task-lib/task");
var iis = require("vsts-iis");
var name = vsts.getInput("AppPoolName", true);
iis.AppPools.exists(name)
    .then(function (exists) {
    if (exists) {
        return iis.AppPools.remove(name);
    }
    else {
        vsts.warning("AppPool does not exist.");
        vsts.exit(0);
    }
})
    .then(function () {
    vsts.exit(0);
})
    .fail(function () {
    vsts.exit(1);
});
