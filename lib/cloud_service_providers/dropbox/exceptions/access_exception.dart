import 'package:http/http.dart';
import 'dart:convert' as json;

enum AccessErrorType {
  invalidAccountType, paperAccessDenied, other, unknown
}

class AccessException implements Exception {
  AccessErrorType type;
  String _userMessage;
  String _errorSummary;
  String _requestId;

  AccessException({Response response}) {
    final body = response.body;
    _requestId = response.headers['X-Dropbox-Request-Id'];
    if (body != null) {
      final map = json.jsonDecode(body);
      final error = map['error'] ?? AccessErrorType.unknown;
      this._userMessage = map['user_message'] ?? '';
      this._errorSummary = map['error_summary'] ?? '';
      this.type = _accessErrorType(error);
    }
  }

  AccessErrorType _accessErrorType(String error) {
    switch (error) {
      case 'invalid_account_type':
        return AccessErrorType.invalidAccountType;
      case 'paper_access_denied':
        return AccessErrorType.paperAccessDenied;
      case 'other':
        return AccessErrorType.other;
      default:
        return AccessErrorType.unknown;
    }
  }

  String get message {
    var desc = _requestId ?? '';
    desc = desc + 'API access error - $this';
    return desc;
  }

  @override
  String toString() {
    return {'erroType': type, 'userMessage': _userMessage, 'errorSummary': _errorSummary}.toString();
  }
}