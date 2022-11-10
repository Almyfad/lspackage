import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:flutter/services.dart';

class LSTimePicker extends StatelessWidget {
  final String? Function(String?)? validator;
  final Function(TimeOfDay?)? onTimePicked;
  final TimeOfDay? firstTime;
  final TimeOfDay? lastTime;
  final TimePickerEntryMode? initialEntryMode;
  final DateFormat? dateformat;
  final AutovalidateMode? autovalidateMode;
  final bool? enabled;
  final TimeOfDay? initialValue;
  final InputDecoration? decoration;
  const LSTimePicker({
    Key? key,
    this.validator,
    this.onTimePicked,
    this.firstTime,
    this.lastTime,
    required this.initialEntryMode,
    this.dateformat,
    this.autovalidateMode,
    this.enabled,
    this.initialValue,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? formatTime(TimeOfDay? d) => d?.format(context);

    var pcontroller = TextEditingController(text: formatTime(initialValue));

    return TextFormField(
      controller: pcontroller,
      autovalidateMode: autovalidateMode,
      readOnly: true,
      enabled: enabled,
      keyboardType: TextInputType.datetime,
      onTap: () async {
        var value = initialValue;
      //  ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);

     /*   if (cdata != null) {
          RegExp regExp = RegExp(
            r"^.*([0-1]?[0-9]|2[0-3])(:|h|H)([0-5][0-9]).*$",
            caseSensitive: false,
            multiLine: false,
          );
          if (regExp.hasMatch(cdata.text ?? "")) {
            var match = regExp.firstMatch(cdata.text ?? "");
            value = TimeOfDay(
                hour: int.parse(match!.group(1) ?? "00"),
                minute: int.parse(match.group(3) ?? "00"));
          }
        }*/

        var d = await showTimePicker(
            context: context,
            initialEntryMode: initialEntryMode ?? TimePickerEntryMode.dial,
            initialTime: value ?? TimeOfDay.now());
        pcontroller.text = formatTime(d) ?? "";
        if (onTimePicked != null) onTimePicked!(d);
      },
      validator: validator,
      decoration: decoration,
    );
  }
}
