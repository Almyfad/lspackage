import 'package:flutter/material.dart';

class SomethingWenWrong extends StatelessWidget {
  const SomethingWenWrong({
    Key? key,
    this.msg,
    this.msg2,
  }) : super(key: key);

  final String? msg;
  final String? msg2;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.warning,
          color: Colors.yellow,
        ),
        SelectableText(
          msg ?? 'Une Erreure est survenue...',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.redAccent),
        ),
        SelectableText(msg2 == null ? "" : msg!,
            style: const TextStyle(
                color: Colors.redAccent,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300)),
      ],
    );
  }
}
