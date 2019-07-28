import 'dart:convert';

import 'package:mbta_companion/src/utils/api_request_counter.dart';

import 'executeCall.dart';

class Result {
  final dynamic payload;
  final bool hasError;
  final String error;

  Result(this.payload, this.hasError, this.error);
}

Future<Result> makeRequest(Method method, String route,
    {Map<String, String> headers, String body}) async {
  final result = await executeCall(
      new GenericRequest(method, route, headers: headers, body: body));

  if (APIRequestCounter.debug) {
    print("response url: $route");
    APIRequestCounter.incrementCalls(route);
  }

  if (result.statusCode != 200) {
    return new Result(null, true,
        'Error making $method request to $route: ${result.statusCode}, ${result.reasonPhrase}');
  }

  final jsonResult = json.decode(result.body);

  return new Result(jsonResult, false, '');
}
