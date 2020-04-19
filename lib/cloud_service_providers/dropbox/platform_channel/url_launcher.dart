import 'package:flutter/services.dart';
import 'dart:async';

class UrlLauncher {
  static const platform = const MethodChannel('com.karthick.dropboxClientsManager/dropoboxClientManager');

  Future<bool> canOpenUrl(Uri url) async {
    Completer<bool> accessTokenCompleter = Completer<bool>();
    try {
      await platform.invokeMethod('canOpenUrl', {'url': url.toString()})
          .then((result) {
        final f = result['canOpenUrlResult'] as bool;
        accessTokenCompleter.complete(f);
      }, onError: (error) {
            print('Error canOpenUrl $error');
      });
    } on PlatformException catch (e) {
      accessTokenCompleter.completeError(e);
    }
    return accessTokenCompleter.future;
  }

  Future<Uri> openUrl(Uri url) async {
    Completer<Uri> accessTokenCompleter = Completer<Uri>();
    try {
      await platform.invokeMethod('openUrl', {'url': url.toString()})
          .then((result) {
            final url = Uri.parse(result['responseUrl']);
            accessTokenCompleter.complete(url);
      });
    } on PlatformException catch (e) {
      accessTokenCompleter.completeError(e);
    }
    return accessTokenCompleter.future;
  }

  Future<Uri> openUrlString(String url) async {
    Completer<Uri> accessTokenCompleter = Completer<Uri>();
    try {
      await platform.invokeMethod('openUrl', {'url': url})
          .then((result) {
        final url = Uri.parse(result['responseUrl']);
        accessTokenCompleter.complete(url);
      });
    } on PlatformException catch (e) {
      accessTokenCompleter.completeError(e);
    }
    return accessTokenCompleter.future;
  }
}