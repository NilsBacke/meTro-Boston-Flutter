import 'package:http/http.dart' as http;

enum Method { GET, POST, PUT, DELETE }

class GenericRequest {
  final Method method;
  final String route, body;
  final Map<String, String> headers;

  GenericRequest(this.method, this.route, {this.body, this.headers});
}

Future<http.Response> executeCall(GenericRequest request) async {
  try {
    // const BASE_HEADERS = {
    //     device_id: DeviceInfo.getUniqueID(),
    //     app_version:
    //         DeviceInfo.getVersion() + ':' + DeviceInfo.getBuildNumber()
    // }

    switch (request.method) {
      case Method.GET:
        return await http.get(request.route, headers: request.headers);
      case Method.POST:
        return await http.post(request.route,
            headers: request.headers, body: request.body);
      case Method.PUT:
        return await http.put(request.route,
            headers: request.headers, body: request.body);
      case Method.DELETE:
        return await http.delete(request.route, headers: request.headers);
      default:
        return null;
    }
  } catch (e) {
    throw new Exception('Error making API request: $e');
  }
}
