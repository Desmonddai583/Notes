// const { echo, UserModel } = require("./pkg/mywasm.js");

// echo("desmond");

// // const user = new_user(141);
// const user = new UserModel();
// user.uid = 115;
// echo(user.uid.toString());

const js = import("./pkg/mywasm.js");
js.then(js => {
  js.echo("desmond")
});
