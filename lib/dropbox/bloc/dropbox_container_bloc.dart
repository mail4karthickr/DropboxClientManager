import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/dropbox_client_manager.dart';
import 'package:dropbox_clients_manager/dropbox/exception_to_usermessage.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dropbox_clients_manager/common/bloc.dart';

class DropboxContainerBloc extends Bloc {
  final DropboxClientManager dropboxClientsManager;

  /// Outputs
  Stream<bool> isClientAuthorized;
  Stream<String> errorMessage;

  /// Inputs
  final _logOutDropboxSubject = BehaviorSubject<bool>();
  Sink get logoutDropbox => _logOutDropboxSubject.sink;

  final _initStateSubject = BehaviorSubject<String>();
  Sink get initState => _initStateSubject.sink;

  final _authenticateUserSubject = BehaviorSubject();
  Sink get authenticateUser => _authenticateUserSubject.sink;


  DropboxContainerBloc({@required this.dropboxClientsManager}) :
        assert(dropboxClientsManager != null) {

     final authenticateUserResult = _authenticateUserSubject.flatMap((_) {
           return dropboxClientsManager.authorizeClient().asStream();
         }).flatMap((_) {
           return dropboxClientsManager.isClientAuthorized().asStream();
         }).handleError((error) {
           throw DropboxExceptionToUserMessage(exception: error);
         });

     final isClientAuthorizedResult = _initStateSubject.flatMap((_) {
          return dropboxClientsManager.isClientAuthorized().asStream();
        }).handleError((error) {
           throw DropboxExceptionToUserMessage(exception: error);
         });

     isClientAuthorized = MergeStream([authenticateUserResult, isClientAuthorizedResult, _logOutDropboxSubject.map((result) => !result)]);
  }

  @override
  close() {
    _logOutDropboxSubject.close();
    _authenticateUserSubject.close();
    _initStateSubject.close();
  }
}