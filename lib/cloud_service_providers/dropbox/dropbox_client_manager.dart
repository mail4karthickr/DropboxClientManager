import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/exceptions/auth_exception.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/platform_channel/in_app_browser.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/platform_channel/url_launcher.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'constants.dart';
import 'dropbox_access_token.dart';
import 'dropbox_auth_result.dart';
import 'dropbox_request.dart';
import 'exceptions/access_token_notavailable_exception.dart';
import 'exceptions/exception_constructor.dart';
import 'exceptions/server_exception.dart';
import 'model/files/list_folder.dart';
import 'model/users/get_account.dart';
import 'model/users/get_space_usage.dart';
import 'oauth2_result.dart';
import 'dart:io';

// app key: ew5lu9fn1xizlk9
// app secret: p9n13xc5nqthsqa

class DropboxClientManager {
  final String appKey;
  final String appSecret;
  final Uuid uuidGenerator;
  final UrlLauncher urlLauncher;
  final InAppBrowser inAppBrowser;
  final FlutterSecureStorage secureStorage;
  static final _baseUri = 'https://api.dropboxapi.com/2';

  DropboxClientManager({
    @required this.appKey,
    @required this.appSecret,
    @required this.uuidGenerator,
    @required this.urlLauncher,
    @required this.inAppBrowser,
    @required this.secureStorage}):
        assert(appKey != null),
        assert(appSecret != null),
        assert(uuidGenerator != null),
        assert(urlLauncher != null),
        assert(inAppBrowser != null),
        assert(secureStorage != null);

  Future<bool> isClientAuthorized() async {
    try {
      final dbAccessToken = await _retrieveAccessTokenFromSecureStorage();
      if (dbAccessToken.accessToken != null && dbAccessToken.accountId != null && dbAccessToken.uid != null) {
        final reqResult = await postRequest(path: '/check/user', parameters: {'query': 'test'});
        final result = reqResult['result'];
        if (result != null && result == 'test') {
          return true;
        }
        return false;
      }
      return false;
    } on AuthException catch (_) {
      return false;
    }
  }

  Future<DropboxOAuthResult> authorizeClient() async {
    final api2Url = Uri(scheme: 'dbapi-2', host: '1', path: '/connect');
    final api8Url = Uri(scheme: 'dbapi-8-emm', host: '1', path: '/connect');

    final canOpenApi2Url = await urlLauncher.canOpenUrl(api2Url);
    final canOpenApi8Url = await urlLauncher.canOpenUrl(api8Url);

    final uniqueString = uuidGenerator.generateV4();
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.SET_STATE_KEY, uniqueString);

    final state = 'oauth2:$uniqueString';
    final parameters = {'k': 'ew5lu9fn1xizlk9', 's': '', 'state': state};

    if (canOpenApi2Url) {
      final url = Uri(scheme: api2Url.scheme,
          host: api2Url.host,
          path: api2Url.path,
          queryParameters: parameters);
      return _launchUrl(url);
    } else if (canOpenApi8Url) {
      final url = Uri(scheme: api8Url.scheme,
          host: api8Url.host,
          path: api8Url.path,
          queryParameters: parameters);
      return _launchUrl(url);
    } else {
      // Open InAppBrowser
      return inAppBrowser
          .openUrlString(_authUrl(uniqueString))
          .then((responseUrl) { return _handleResponseUrl(responseUrl, _redirectUri); });
    }
  }

  Future<DropboxOAuthResult> _launchUrl(Uri url) {
    return urlLauncher
        .openUrl(url)
        .then((result) { return _handleResponseUrl(result, _redirectUriForDbAuth); });
  }

  Future<DropboxOAuthResult> _handleResponseUrl(Uri responseUri, String redirectUri) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final oAuthResult = OAuthResult(responseUri: responseUri,
        redirectUri: Uri.parse(redirectUri),
        sharedPreferences: sharedPreferences);
    return await oAuthResult.result.then((result) async {
      if (result is DropboxOAuthSuccessResult) {
        /// Store the access token in secure storage to use it for future authentication.
        await _storeDbAccessTokenInSecureStorage(result.dbAccessToken);
      }
      return result;
    });
  }

  String _authUrl(String uniqueString) {
    final authUri = Uri.http('www.dropbox.com','/oauth2/authorize', {
      'response_type': 'token',
      'client_id': 'ew5lu9fn1xizlk9',
      'redirect_uri': _redirectUri,
      'disable_signup': 'true',
      'locale': 'en',
      'state': uniqueString
    }).toString();
    return authUri;
  }

  String get _redirectUri {
    return "db-ew5lu9fn1xizlk9://2/token";
  }

  String get _redirectUriForDbAuth {
    return 'db-ew5lu9fn1xizlk9://1/connect';
  }

  _storeDbAccessTokenInSecureStorage(DropboxAccessToken dbAccessToken) async {
    await secureStorage.write(key: Constants.ACCESS_TOKEN_KEY, value: dbAccessToken.accessToken);
    await secureStorage.write(key: Constants.ACCOUNT_ID, value: dbAccessToken.accountId);
    await secureStorage.write(key: Constants.UID, value: dbAccessToken.uid);
  }

  Future<DropboxAccessToken> _retrieveAccessTokenFromSecureStorage() async {
    final token = await secureStorage.read(key: Constants.ACCESS_TOKEN_KEY);
    final accountId = await secureStorage.read(key: Constants.ACCOUNT_ID);
    final uid = await secureStorage.read(key: Constants.UID);
    return DropboxAccessToken(accessToken: token, uid: uid, accountId: accountId);
  }

  Future<Map<String, dynamic>> postRequest({String path, Map<String, String> parameters}) async {
    final dbAccessToken = await _retrieveAccessTokenFromSecureStorage();
    if (dbAccessToken != null) {
      final dropboxRequest = DropboxRequest(dbAccessToken: dbAccessToken,
          path: path, parameters: parameters);
      try {
        final response = await http.post('$_baseUri${dropboxRequest.path}',
            headers: dropboxRequest.headers,
            body: dropboxRequest.body);
        if (response.hasAcceptableStatusCode) {
          Map<String, dynamic> result = json.jsonDecode(response.body);
          return result;
        } else {
          final exceptionConstructor = ExceptionConstructor(response: response);
          throw exceptionConstructor.exception;
        }
      } on SocketException catch(exception, stacktrace) {
        throw ServerException(exception: exception, stackTrace: stacktrace);
      }
    } else {
      print('_dbAccessToken is null. Cannot make a post request');
      throw AccessTokenNotAvailableException();
    }
  }
}

extension on Response {
  bool get hasAcceptableStatusCode {
    if (statusCode >= 200 && statusCode <= 299) {
      return true;
    }
   return false;
  }
}

extension Account on DropboxClientManager {
  Future<void> revokeAccessToken() async {
    await postRequest(path: '/auth/token/revoke');
  }
}

extension Users on DropboxClientManager {
  Future<GetAccount> getAccount() async  {
    final dbAccessToken = await _retrieveAccessTokenFromSecureStorage();
    final result = await postRequest(path: '/users/get_account',
        parameters: {'account_id' : dbAccessToken.accountId});
    return GetAccount.fromJson(result);
  }

  Future<GetSpaceUsage> getSpaceUsage() async {
    final result = await postRequest(path: '/users/get_space_usage');
    return GetSpaceUsage.fromJson(result);
  }
}

extension Files on DropboxClientManager {
  Future<ListFolder> listFolder(String path) async {
    final result = await postRequest(path: '/files/list_folder', parameters: {'path': path});
    return ListFolder.fromJson(result);
  }

  dynamic deleteItemAtPath(String path) async {
    final result = await postRequest(path: '/files/delete_v2', parameters: {'path': ''});
    return result;
  }
}