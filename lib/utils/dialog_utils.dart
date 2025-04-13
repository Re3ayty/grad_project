import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoadingDialog(BuildContext context,
      {required String message}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              Text(
                message,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 6,
              ),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessageDialog(
      BuildContext context, {
        String? message,
        String? posActionTitle,
        String? negActionTitle,
        VoidCallback? posAction,
        VoidCallback? negAction,
      }) {
    List<Widget> actions = [];
    if (posActionTitle != null) {
      actions.add(TextButton(
          onPressed: () {
            // Navigator.pop(context);
            posAction?.call();
          },
          child: Text(
            posActionTitle,
            style: TextStyle(fontSize: 12, color: Colors.black),
          )));
    }
    if (negActionTitle != null) {
      actions.add(TextButton(
          onPressed: () {
            // Navigator.pop(context);
            negAction?.call();
          },
          child: Text(negActionTitle,
              style: TextStyle(fontSize: 12, color: Colors.black))));
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message ?? '', style: TextStyle(fontSize: 12, color: Colors.black)),
              ],
            ),
          ),
          actions: actions,
        );
      },
    );
  }
}