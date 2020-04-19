import 'package:flutter/material.dart';
import 'dropbox/widgets/dropbox_container.dart';

class FileManagerApp extends StatelessWidget {
  final DropboxContainer dropboxContainer;

  FileManagerApp({this.dropboxContainer});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: dropboxContainer,
      ),
    );
  }
}

