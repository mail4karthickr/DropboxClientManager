import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'dropbox_auth_result.dart';
import 'oauth2_error.dart';

class OAuthResult {
   Uri redirectUri;
   Uri responseUri;
   SharedPreferences sharedPreferences;
   final _results = Map<String, String>();

  OAuthResult({this.responseUri, this.redirectUri, this.sharedPreferences});

   String get _error {
     return _hasError ? _results['error'] : null;
   }

   bool get _hasError {
     return _results['error'] != null;
   }

  bool get _canHandleUri {
    if (redirectUri != null &&
        responseUri.scheme == redirectUri.scheme &&
        responseUri.host == redirectUri.host &&
        responseUri.path == redirectUri.path) {
      return true;
    } else {
      return false;
    }
  }

  String get _storedState {
    return sharedPreferences.getString(Constants.SET_STATE_KEY);
  }

   bool get _isStateConsistent {
     final currentState = _results['state'];
     final storedState = sharedPreferences.getString(Constants.SET_STATE_KEY);
     if (currentState == null || storedState == null || currentState != storedState) {
       return false;
     }
     // reset upon success
     sharedPreferences.setString(Constants.SET_STATE_KEY, null);
     return true;
   }

   bool get _isStateConsistentForDAuth {
     final currentState = _results['state'].split('%3A') ?? [];
     if (currentState.length == 2 && currentState[0] == 'oauth2' &&
         currentState[1] == _storedState) {
       return true;
     }
     return false;
   }

  String get _errorDescription {
    return _hasError ? _results['error_description'] : null;
  }

  Future<DropboxOAuthResult> get result {
    if ((responseUri.host == '1' && responseUri.path == '/cancel') ||
        (responseUri.host == '2' && responseUri.path == '/cancel')) {
      return DropboxOAuthUserCancelled().futureType;
    }

    if (!_canHandleUri) {
      return Future.error(DropboxOAuthErrorResult(errorCode: 'unable_to_handle_uri',
          description: 'Cannot handle the uri returned'));
    }

    return _extractFromUri(responseUri);
  }

  Future<DropboxOAuthResult> _extractFromUri(Uri uri) {
    if (uri.host == "1") { //dAuth
      for(final pair in responseUri.query.split('&') ?? []) {
        final kv = pair.split('=');
        _results[kv[0]] = kv[1];
      }
      return _extractFromDAuthUri(uri);
    } else {
      for(final pair in responseUri.fragment.split('&') ?? []) {
        final kv = pair.split('=');
        _results[kv[0]] = kv[1];
      }
      return _extractFromRedirectUri(uri);
    }
  }

  Future<DropboxOAuthResult> _extractFromDAuthUri(Uri uri) {
    if (uri.path == "/connect") {
      if (_isStateConsistentForDAuth) {
        final accessToken = _results['oauth_token_secret'];
        final uid = _results['uid'];
        return DropboxOAuthSuccessResult(accessToken: accessToken, uid: uid).futureType;
      } else {
        return Future.error(DropboxOAuthErrorResult.fromOAuthErrorType(errorType: OAuth2ErrorType.unknown));
      }
    } else {
      return Future.error(DropboxOAuthErrorResult.fromOAuthErrorType(errorType: OAuth2ErrorType.accessDenied));
    }
  }

  Future<DropboxOAuthResult> _extractFromRedirectUri(Uri uri) {
    if (_error != null && _error != 'access_denied') {
      return DropboxOAuthUserCancelled().futureType;
    } else if (_error != null) {
      final replacedString = _errorDescription.replaceAll('+', ' ');
      final decodedString = Uri.decodeComponent(replacedString);
      return Future.error(DropboxOAuthErrorResult(errorCode: _error, description: decodedString ?? ""));
    } else {
      if (!_isStateConsistent) {
        return Future.error(DropboxOAuthErrorResult(errorCode: 'inconsistent_state',
            description: 'Auth flow failed because of inconsistent state.'));
      }
      final accessToken = _results['access_token'];
      final uid = _results['uid'];
      final accountId = _results['account_id'];
      return DropboxOAuthSuccessResult(accessToken: accessToken, uid: uid, accountId: accountId).futureType;
    }
  }
}