import 'package:http/http.dart';
import 'dart:convert' as json;

enum AuthErrorType {
  invalidAccessToken, invalidSelectUser, invalidSelectAdmin, userSuspended,
  expiredAccessToken, missingScope, other
}

class AuthException implements Exception  {
  String _requestId;

  String error;
  String userMessage;
  String errorSummary;
  AuthErrorType type;

  AuthException({Response response}) {
    final body = response.body;
    _requestId = response.headers['X-Dropbox-Request-Id'];
    if (body != null) {
      final map = json.jsonDecode(body);
      final error = map['error'];
      this.errorSummary = map['error_summary'] ?? '';
      this.userMessage =  map['user_message'] ?? '';
      if (error != null) {
        this.error = error['.tag'] ?? '';
      }
      this.type = _accessErrorType(this.userMessage);
    }
  }

  AuthErrorType _accessErrorType(String error) {
    switch (error) {
      case 'invalid_access_token':
        return AuthErrorType.invalidAccessToken;
      case 'invalid_select_user':
        return AuthErrorType.invalidSelectUser;
      case 'invalid_select_admin':
        return AuthErrorType.invalidSelectAdmin;
      case 'user_suspended':
        return AuthErrorType.userSuspended;
      case 'expired_access_token':
        return AuthErrorType.expiredAccessToken;
      case 'missing_scope':
        return AuthErrorType.missingScope;
      case 'other':
        return AuthErrorType.other;
      default:
        return AuthErrorType.other;
    }
  }

  String get message {
    var desc = _requestId ?? '';
    desc = desc + 'API auth error - $this';
    return desc;
  }

  @override
  String toString() {
    return {'erroType': type, 'userMessage': userMessage, 'errorSummary': errorSummary}.toString();
  }
}