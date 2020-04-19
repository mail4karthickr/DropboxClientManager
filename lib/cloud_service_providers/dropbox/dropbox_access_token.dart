import 'package:flutter/material.dart';

class DropboxAccessToken {
  final String accessToken;
  final String uid;
  final String accountId;

  DropboxAccessToken({this.accessToken, this.uid, this.accountId});

  @override
  String toString() {
    return 'ACCESSTOKEN: $accessToken, UID: $uid, ACCOUNTID: $accountId';
  }
}