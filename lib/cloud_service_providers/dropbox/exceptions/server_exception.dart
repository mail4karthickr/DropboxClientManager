class ServerException implements Exception {
  final Exception exception;
  final StackTrace stackTrace;
  ServerException({this.exception, this.stackTrace});
}