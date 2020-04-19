import 'package:flutter/cupertino.dart';

class MessageDisplayWidget extends StatelessWidget {
  final String message;

  MessageDisplayWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
