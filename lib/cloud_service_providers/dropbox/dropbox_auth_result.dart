import 'dropbox_access_token.dart';
import 'oauth2_error.dart';

abstract class DropboxOAuthResult {
   bool get isError;
   bool get isSuccess;
}

/// The authorization succeeded. Includes a `DropboxAccessToken`.
class DropboxOAuthSuccessResult extends DropboxOAuthResult {
  DropboxAccessToken dbAccessToken;

  DropboxOAuthSuccessResult({String accessToken, String uid, String accountId}) {
    dbAccessToken = DropboxAccessToken(accessToken: accessToken, uid: uid, accountId: accountId);
  }

  Future<DropboxOAuthResult> get futureType {
    return Future.value(this);
  }

  @override
  String toString() {
    return 'Success - AccessToken - $dbAccessToken';
  }

  @override
  // TODO: implement isError
  bool get isError => false;

  @override
  // TODO: implement isSuccess
  bool get isSuccess => true;
}

/// The authorization failed. Includes an `OAuth2Error` and a descriptive message.
class DropboxOAuthErrorResult extends DropboxOAuthResult {
  OAuth2Error oAuth2error;
  String description = "";

  DropboxOAuthErrorResult({String errorCode, this.description}) {
    oAuth2error = OAuth2Error.fromErrorCode(errorCode: errorCode);
  }

  DropboxOAuthErrorResult.fromOAuthErrorType({OAuth2ErrorType errorType}) {
    oAuth2error = OAuth2Error.fromErrorType(errorType: errorType);
  }

  Future<OAuth2Error> get futureType {
    return Future.error(oAuth2error);
  }

  @override
  String toString() {
    return '$oAuth2error - $description';
  }

  @override
  // TODO: implement isError
  bool get isError => true;

  @override
  // TODO: implement isSuccess
  bool get isSuccess => false;
}

/// The authorization was manually canceled by the user.
class DropboxOAuthUserCancelled extends DropboxOAuthResult {
  DropboxOAuthUserCancelled();

  Future<DropboxOAuthUserCancelled> get futureType {
    return Future.error(this);
  }

  @override
  // TODO: implement isError
  bool get isError => false;

  @override
  // TODO: implement isSuccess
  bool get isSuccess => false;
}