import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/exceptions/access_exception.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/exceptions/access_token_notavailable_exception.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/exceptions/auth_exception.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/exceptions/bad_input_exception.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/exceptions/http_exception.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/exceptions/internal_server_exception.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/exceptions/rate_limit_exception.dart';
import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/exceptions/server_exception.dart';
import 'package:flutter/material.dart';

class DropboxExceptionToUserMessage implements Exception {
  final Exception exception;
  DropboxExceptionToUserMessage({@required this.exception}) : assert(exception != null);

  String get displayableMessage {
    if (exception is AccessException) {
      return 'Permission denied';
    } else if (exception is AuthException) {
      return 'Please login again to continue using Dropbox';
    } else if (exception is AccessTokenNotAvailableException) {
      return 'Please login';
    } else if (exception is BadInputException) {
      return 'Invalid input';
    } else if (exception is HttpException) {
      return 'Dropbox server error. Please try again after some time';
    } else if (exception is InternalServerException) {
      return 'Dropbox server error. Please try again after some time';
    } else if (exception is RateLimitException) {
      return 'Too many requests. Please try again after some time';
    } else if (exception is ServerException) {
      return 'Could not connect to the network. Please try again later.';
    } else {
      return 'An error occurred. Please try again after some time';
    }
  }
}