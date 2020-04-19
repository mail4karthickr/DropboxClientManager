import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/exceptions/route_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'access_exception.dart';
import 'auth_exception.dart';
import 'bad_input_exception.dart';
import 'http_exception.dart';
import 'internal_server_exception.dart';

enum HttpResponseExceptionType {
  internalServerException,
  badInputException,
  authException,
  accessException,
  routeException,
  rateLimitException,
  clientException,
  httpException
}

class ExceptionConstructor {
  Response response;
  HttpResponseExceptionType errorType;
  String description;

  ExceptionConstructor({@required Response response}) : assert(response != null) {
    this.response = response;
    this.errorType = getExceptionType();
  }

  HttpResponseExceptionType getExceptionType() {
    final statusCode = response.statusCode;
    if (statusCode >= 500 && statusCode <= 599) {
      return HttpResponseExceptionType.internalServerException;
    } else if (statusCode == 400) {
      /// Bad input parameter. The response body is a plaintext message with more information.
      return HttpResponseExceptionType.badInputException;
    } else if (statusCode == 401) {
      /// Bad or expired token. This can happen if the access token is expired or if the access token has been revoked by Dropbox or the user.
      /// To fix this, you should re-authenticate the user.
      return HttpResponseExceptionType.authException;
    } else if (statusCode == 403) {
      /// The user or team account doesn't have access to the endpoint or feature.
      return HttpResponseExceptionType.accessException;
    } else if (statusCode == 409) {
      /// Endpoint-specific error. Look to the JSON response body for the specifics of the error.
      return HttpResponseExceptionType.routeException;
    } else if (statusCode == 429) {
      /// Your app is making too many requests for the given user or team and is being rate limited.
      /// Your app should wait for the number of seconds specified in the "Retry-After" response header before trying again.
      return HttpResponseExceptionType.rateLimitException;
    } else {
      /// An error occurred on the Dropbox servers.
      /// Check status.dropbox.com for announcements about Dropbox service issues
      return HttpResponseExceptionType.httpException;
    }
  }

  Exception get exception {
    switch (errorType) {
      case HttpResponseExceptionType.internalServerException:
        return InternalServerException(response: response);
      case HttpResponseExceptionType.badInputException:
        return BadInputException(response: response);
      case HttpResponseExceptionType.authException:
        return AuthException(response: response);
      case HttpResponseExceptionType.accessException:
        return AccessException(response: response);
      case HttpResponseExceptionType.httpException:
        return HttpException(response: response);
      case HttpResponseExceptionType.routeException:
        return RouteException(response: response);
      default:
        return BadInputException(response: response);
    }
  }
}
