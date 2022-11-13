
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class HourPicker extends StatelessWidget {
  final int value;
  final bool enabled;
  final Function(int?) onPicked;
  const HourPicker({
    Key? key,
    required this.value,
    required this.onPicked,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enabled == false) {
      return TextFormField(
          enabled: false,
          initialValue: value.toString(),
          decoration: const InputDecoration(
            label: Text("Heure"),
          ));
    }

    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
          labelText: "Heure",
          suffixIcon: Icon(
            FontAwesomeIcons.stopwatch,
          )),
      value: value,
      onChanged: enabled ? onPicked : null,
      items: List.generate(
          24,
          (index) => DropdownMenuItem(
                value: index,
                child: Text(index.toString().padLeft(2, '0')),
              )),
    );
  }
}