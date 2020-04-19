import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/dropbox_client_manager.dart';
import 'package:dropbox_clients_manager/common/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'dropbox_container_bloc.dart';

class DropboxAppBarBloc extends Bloc {
  final DropboxClientManager dropboxClientManager;
  final DropboxContainerBloc dropboxContainerBloc;

  final _logoutDropboxSubject = BehaviorSubject<bool>();
  Sink get logoutDropbox => _logoutDropboxSubject.sink;

  DropboxAppBarBloc({@required this.dropboxClientManager,
    @required this.dropboxContainerBloc}) :
        assert(dropboxClientManager != null),
        assert(dropboxContainerBloc != null) {

    _logoutDropboxSubject.flatMap((_) {
      return dropboxClientManager.revokeAccessToken().asStream();
    }).listen((data) {
      dropboxContainerBloc.logoutDropbox.add(true);
      print('Access token revoked');
    }, onError: (error) {
      print('access token revoke error $error');
    });
  }

  @override
  close() {
    _logoutDropboxSubject.close();
  }
}