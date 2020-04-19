import 'dart:io';
import 'package:dropbox_clients_manager/app_dependency_container.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/dropbox_client_manager.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/platform_channel/in_app_browser.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/platform_channel/url_launcher.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/uuid.dart';
import 'package:dropbox_clients_manager/dropbox/widgets/dropbox_appbar.dart';
import 'package:dropbox_clients_manager/dropbox/widgets/dropbox_container.dart';
import 'package:dropbox_clients_manager/dropbox/widgets/dropbox_items_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'bloc/dropbox_appbar_bloc.dart';
import 'bloc/dropbox_container_bloc.dart';
import 'bloc/dropbox_items_list_bloc.dart';

class DropboxDependencyContainer {
  AppDependencyContainer appDependencyContainer;
  DropboxClientManager dropboxClientManager;
  DropboxContainerBloc dropboxContainerBloc;

  DropboxDependencyContainer({this.appDependencyContainer}) {
    String apiKey;
    String appSecret;
    if (Platform.isIOS) {
      apiKey = "ew5lu9fn1xizlk9";
      appSecret = "p9n13xc5nqthsqa";
    } else if (Platform.isAndroid) {

    }

    dropboxClientManager = DropboxClientManager(
        appKey: apiKey,
        appSecret: appSecret,
        uuidGenerator: Uuid(),
        urlLauncher: UrlLauncher(),
        inAppBrowser: InAppBrowser(),
        secureStorage: FlutterSecureStorage());
    dropboxContainerBloc = DropboxContainerBloc(dropboxClientsManager: dropboxClientManager);
  }

  DropboxContainer makeDropboxContainer() {
    return DropboxContainer(dropboxBloc: dropboxContainerBloc, makeDropboxItemsList: makeDropboxItemsList);
  }

  DropboxItemsList makeDropboxItemsList(String path) {
    return DropboxItemsList(path: path, makeDropboxItemsListBloc: makeDropboxItemsListBloc);
  }

  DropboxItemsListBloc makeDropboxItemsListBloc() {
    return DropboxItemsListBloc(dropboxClientsManager: dropboxClientManager, dropboxContainerBloc: dropboxContainerBloc);
  }
}