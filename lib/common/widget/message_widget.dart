import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final String buttonTitle;
  final Color buttonColor;
  final Function buttonTapped;

  MessageWidget({this.message, this.buttonTitle, this.buttonColor, this.buttonTapped});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message,
                textAlign: TextAlign.center),
            FlatButton(
              onPressed: () => buttonTapped(),
              child: Image.asset('images/Dropbox.png', height: 70, width: 150),
            )
          ]
        ),
      ),
    );
  }
}
