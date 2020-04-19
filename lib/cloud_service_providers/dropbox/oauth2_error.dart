enum OAuth2ErrorType {
  /// The client is not authorized to request an access token using this method.
  unauthorizedClient,

  /// The resource owner or authorization server denied the request.
  accessDenied,

  /// The authorization server does not support obtaining an access token using this method.
  unsupportedResponseType,

  /// The requested scope is invalid, unknown, or malformed.
  invalidScope,

  /// The authorization server encountered an unexpected condition that prevented it from fulfilling the request.
  serverError,

  /// The authorization server is currently unable to handle the request
  /// due to a temporary overloading or maintenance of the server.
  temporarilyUnavailable,

  /// The state param received from the authorization server does
  /// not match the state param stored by the SDK.
  inconsistentState,

  /// Some other error (outside of the OAuth2 specification)
  unknown
}

/// A failed authorization.
/// See RFC6749 4.2.2.1
class OAuth2Error {
  OAuth2ErrorType errorType = OAuth2ErrorType.unknown;

  OAuth2Error.fromErrorType({OAuth2ErrorType errorType}) {
    this.errorType = errorType;
  }

  OAuth2Error.fromErrorCode({String errorCode}) {
    switch (errorCode) {
      case 'unauthorized_client':
        errorType = OAuth2ErrorType.unauthorizedClient;
        break;
      case 'access_denied':
        errorType = OAuth2ErrorType.accessDenied;
        break;
      case 'unsupported_response_type':
        errorType = OAuth2ErrorType.unsupportedResponseType;
        break;
      case 'invalid_scope':
        errorType = OAuth2ErrorType.invalidScope;
        break;
      case 'server_error':
        errorType = OAuth2ErrorType.serverError;
        break;
      case 'temporarily_unavailable':
        errorType = OAuth2ErrorType.temporarilyUnavailable;
        break;
      case 'inconsistent_state':
        errorType = OAuth2ErrorType.inconsistentState;
        break;
      case 'unknown':
        errorType = OAuth2ErrorType.unknown;
        break;
    }
  }

  @override
  String toString() {
    return '$errorType';
  }
}