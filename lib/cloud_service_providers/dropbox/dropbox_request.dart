import 'package:flutter/material.dart';
import 'dart:convert' as json;
import 'dropbox_access_token.dart';

class DropboxRequest {
  final DropboxAccessToken dbAccessToken;
  final String path;
  Map<String, String> parameters;

  DropboxRequest({@required this.dbAccessToken,
    @required this.path,
    this.parameters}) :
        assert(dbAccessToken != null),
        assert(path != null);

  String get body {
      if (parameters != null) {
        final encodedParameters = json.jsonEncode(parameters);
        final decodedUri = Uri.decodeFull(encodedParameters);
        return decodedUri;
      }
      return null;
  }

  Map<String, String> get headers {
    if (body != null) {
      return {'Authorization': 'Bearer ${dbAccessToken.accessToken}', 'content-Type': 'application/json'};
    } else {
      return {'Authorization': 'Bearer ${dbAccessToken.accessToken}'};
    }
  }
}