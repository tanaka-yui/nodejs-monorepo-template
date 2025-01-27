function handler(event) {
  var request = event.request;
  var currentUri = request.uri;

  var doReplace = request.method === "GET" && currentUri.indexOf(".") === -1;

  if (doReplace) {
    request.uri = "/index.html";
  }

  return request;
}
