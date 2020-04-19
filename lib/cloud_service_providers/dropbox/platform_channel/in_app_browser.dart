import 'package:flutter/services.dart';
import 'dart:async';

class InAppBrowser {
  static const platform = const MethodChannel('com.karthick.dropboxClientsManager/dropoboxClientManager');

  Future<Uri> openUrl(Uri url) async {
    Completer<Uri> accessTokenCompleter = Completer<Uri>();
    try {
      await platform.invokeMethod('openInAppBrowser', {'url': url.toString()})
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
      await platform.invokeMethod('openInAppBrowser', {'url': url})
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