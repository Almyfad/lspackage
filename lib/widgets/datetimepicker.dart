import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LsDatetimePicker extends StatelessWidget {
  final String? Function(String?)? validator;
  final Function(DateTime?)? onDatePicked;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool? onlyDate;
  final DateFormat? dateformat;
  final AutovalidateMode? autovalidateMode;
  final bool? enabled;
  final DateTime? initialValue;
  final InputDecoration? decoration;
  const LsDatetimePicker({
    Key? key,
    this.validator,
    this.onDatePicked,
    this.firstDate,
    this.lastDate,
    this.onlyDate,
    this.dateformat,
    this.autovalidateMode,
    this.enabled,
    this.initialValue,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? formatDate(d) => d == null
        ? null
        : dateformat != null
            ? dateformat!.format(d)
            : DateFormat('d/MM/yyyy HH:mm').format(d);

    var pcontroller = TextEditingController(text: formatDate(initialValue));

    Future<DateTime?> showpicker(DateTime d) async {
      DateTime? date = await showDatePicker(
          context: context,
          initialDate: d,
          firstDate: firstDate ?? DateTime(DateTime.now().year),
          lastDate: lastDate ?? DateTime(DateTime.now().year + 100));

      if (date == null) return null;
      if (onlyDate ?? false) return date;
      TimeOfDay? tod = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(d));

      if (tod == null) return null;
      return DateTime(date.year, date.month, date.day, tod.hour, tod.minute);
    }

    return TextFormField(
      controller: pcontroller,
      autovalidateMode: autovalidateMode,
      readOnly: true,
      enabled: enabled,
      keyboardType: TextInputType.datetime,
      onTap: () async {
        var d = await showpicker(initialValue ?? DateTime.now());
        pcontroller.text = formatDate(d) ?? "";
        if (onDatePicked != null) onDatePicked!(d);
      },
      validator: validator,
      decoration: decoration,
    );
  }
}
