import 'package:flutter/material.dart';

class Snackit {
  static info(String msg, BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Icon(
                Icons.info_outline,
                color: Colors.blueAccent,
              ),
            ),
            Expanded(child: Text(msg)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 5.0,
      ));

  static sucess(BuildContext context, {String? title, String? message}) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Icon(
                Icons.verified,
              ),
            ),
            Expanded(
              child: Text(
                message ?? "",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 5.0,
      ));

  static error(String msg, BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 5.0,
      ));
}
