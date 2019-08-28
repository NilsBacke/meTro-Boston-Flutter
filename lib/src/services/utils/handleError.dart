import 'makeRequest.dart';

void handleError(Result result) {
  if (result.hasError) {
    if (result.payload['error'] != null) {
      print(result.payload['error']);
      throw new Exception(result.payload['error']);
    } else {
      print(result.error);
      throw new Exception(result.error);
    }
  }
}
