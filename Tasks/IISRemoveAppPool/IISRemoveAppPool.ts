//import * as runner from "vsts-task-lib/toolrunner";
import * as iis from "vsts-iis";

iis.Sites.addSync({
	name: "Foo",
	protocol: "https",
	host: "*",
	port: 443
});

// 
// iis.createSiteSync({
// 	name: "Foo",
// 	protocol: "https",
// 	host: "*",
// 	port: 433,
// 	path: "C:\\application\\manzanita"
// });