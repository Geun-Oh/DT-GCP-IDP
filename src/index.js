const functions = require("@google-cloud/functions-framework");

const fn = () => {
  console.log("test");
};

functions.http("helloHttp", (req, res) => {
  fn();
  res.send(200);
});
