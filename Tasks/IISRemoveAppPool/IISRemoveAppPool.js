//import * as runner from "vsts-task-lib/toolrunner";
var iis = require("iis");
iis.deleteAppPool("Foo");
