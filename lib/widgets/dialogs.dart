import 'package:flutter/material.dart';

class LsDialog {
  static Future<bool?> confirm(BuildContext context, String msg,
      {String title = "", Color? cancelButtonColor}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      cancelButtonColor ?? Theme.of(context).colorScheme.error),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              child: const Text('Valider'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
