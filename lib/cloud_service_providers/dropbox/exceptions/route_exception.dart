import 'package:http/http.dart';
import 'dart:convert' as json;

class RouteException implements Exception {
  String _error;
  String _requestId;

  RouteException({Response response}) {
    if (response != null && response.body != null) {
      _requestId = response.headers['X-Dropbox-Request-Id'];
      final decodedData = json.jsonDecode(response.body);
      _error = decodedData['error'];
    }
  }

  String get message {
    var ret = "";
    if (_requestId != null) {
      ret = ret + "[request-id $_requestId]";
    }
    ret = ret + "API route error - $_error";
    return ret;
  }

  @override
  String toString() {
    return {'RequestId': _requestId, 'Error': _error}.toString();
  }
}