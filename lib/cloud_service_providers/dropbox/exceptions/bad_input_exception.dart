import 'package:http/http.dart';
import 'dart:convert' as json;

class BadInputException implements Exception {
  String _message;
  String _requestId;

  BadInputException({Response response}) {
    final data = response.body;
    _requestId = response.headers['X-Dropbox-Request-Id'];
    if (data != null) {
      _message = json.jsonDecode(data);
    }
  }

  String get message {
    var ret = "";
    if (_requestId != null) {
      ret = ret + '[request-id $_requestId]';
    }
    ret = ret + 'Bad Input';
    if (_message != null) {
      ret = ret + _message;
    }
    return ret;
  }

  @override
  String toString() {
    return {'Message': _message, 'RequestId': _requestId}.toString();
  }
}