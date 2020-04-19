import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/dropbox_client_manager.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/model/files/list_folder.dart';
import 'package:dropbox_clients_manager/common/bloc.dart';
import 'package:dropbox_clients_manager/dropbox/exception_to_usermessage.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'dropbox_container_bloc.dart';

class DropboxItemsListBloc extends Bloc {

  final _initStateSubject = BehaviorSubject<String>();
  Sink<String> get initState => _initStateSubject.sink;

  final _logoutDropboxSubject = BehaviorSubject<bool>();
  Sink get logoutDropbox => _logoutDropboxSubject.sink;

  Stream<List<Entry>> dropboxItems;
  Stream<bool> showProgressDialog;
  Stream<String> errorMessage;
  Stream<bool> dismissBottomSheet;

  DropboxItemsListBloc({@required DropboxClientManager dropboxClientsManager,
    @required DropboxContainerBloc dropboxContainerBloc}) :
        assert(dropboxClientsManager != null),
        assert(dropboxContainerBloc != null) {

    /// List folder
    dropboxItems = _initStateSubject.flatMap((path) {
          return dropboxClientsManager.listFolder(path).asStream();
        })
        .map((listFolder) => listFolder.entries)
        .handleError((error) {
            throw DropboxExceptionToUserMessage(exception: error).displayableMessage;
        });

    /// Logout dropbox
    final logoutDropboxSubjectResult = _logoutDropboxSubject.flatMap((_) {
      return dropboxClientsManager.revokeAccessToken().asStream();
    }).materialize();

    showProgressDialog = MergeStream([
      _logoutDropboxSubject.map((_) => true),
      logoutDropboxSubjectResult.map((_) => false)]);

    logoutDropboxSubjectResult
        .where((event) => event.isOnData)
        .listen((data) {
          dropboxContainerBloc.logoutDropbox.add(true);
          print('Logout successfull');
        });

    final logoutDropboxError = logoutDropboxSubjectResult
        .where((event) => event.isOnError)
        .map((error) {
          return "Could not logout dropbox error occurred";
    });

    errorMessage = MergeStream([logoutDropboxError]);
  }

  @override
  close() {
    _logoutDropboxSubject.close();
    _initStateSubject.close();
  }
}