const webdav = require("webdav-server").v2;
const express = require("express");
const cors = require("cors");

// User manager (tells who are the users)
const userManager = new webdav.SimpleUserManager();
const user = userManager.addUser("grumpy", "webdavpsd", false);

// Privilege manager (tells which users can access which files/folders)
const privilegeManager = new webdav.SimplePathPrivilegeManager();
privilegeManager.setRights(user, "/", ["all"]);

//Create server instance
const server = new webdav.WebDAVServer({
  // HTTP Basic authentication
  httpAuthentication: new webdav.HTTPBasicAuthentication(userManager),
  privilegeManager: privilegeManager,

  autoSave: {
    // Will automatically save the changes in the 'resource' folder
    treeFilePath: "/resources",
  },
});

// Try to load the 'resource' folder
server.autoLoad((e) => {
  if (e) {
    // Couldn't load the 'resources' (folder is not accessible or it has invalid content)
    server.rootFileSystem().addSubTree(server.createExternalContext(), {
      //create the 'resources' folder
      resources: {},
    });
  }
});

//Create app instance for express
const app = express();

//Reslove CORS issues
const corsOptions = {
  origin: "*",
  methods: "GET,HEAD,PUT,PATCH,POST,DELETE,PROPFIND",
  preflightContinue: true,
  optionsSuccessStatus: 204,
};

app.options("*", cors(corsOptions));
app.use(cors(corsOptions));
app.use(webdav.extensions.express("/", server));

app.listen(1901, () => {
  console.log(`app listening at http://localhost:1901`);
});
