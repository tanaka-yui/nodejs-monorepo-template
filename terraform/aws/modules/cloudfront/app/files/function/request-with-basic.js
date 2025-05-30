function isIncludes(arr, target) {
  for (var i = 0; i < arr.length; i++) {
    if (target.indexOf(arr[i]) !== -1) {
      return true;
    }
  }
  return false
}

function handler(event) {
  var request = event.request;
  var headers = request.headers;
  var currentUri = request.uri;

  var basicAuth = ${basic_auth};

  var id = basicAuth.id;
  var pw = basicAuth.password;

  var originBasicAuthStr = id + ":" + pw;
  var authString = "Basic " + originBasicAuthStr.toString("base64");

  var doReplace = request.method === "GET" && currentUri.indexOf(".") === -1;

  if (doReplace) {
    request.uri = "/index.html";
  }

  if (
    typeof headers.authorization === "undefined" ||
    headers.authorization.value !== authString
  ) {
    return {
      statusCode: 401,
      statusDescription: "Unauthorized",
      headers: { "www-authenticate": { value: "Basic" } }
    };
  }

  return request;
}
