import 'package:http/http.dart';
import 'dart:convert' as json;

class HttpException implements Exception {
  String _message;
  String _requestId;
  String _code;

  HttpException({Response response}) {
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
    ret = ret + 'HTTP Error';
    if (_code != null) {
      ret = ret + _code;
    }
    if (_message != null) {
      ret = ret + _message;
    }
    return ret;
  }

  @override
  String toString() {
    return {'Message': _message, 'RequestId': _requestId, 'StatusCode': _code}.toString();
  }
}