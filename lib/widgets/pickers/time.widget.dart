import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lspackage/classes/timeinput.formatter.dart';
import 'package:lspackage/widgets/pickers/hour.widget.dart';
import 'package:lspackage/widgets/pickers/minute.widget.dart';
import 'package:lspackage/widgets/popupitemnoinkwell.dart';

class LSTimePickerController {
  TimeOfDay? value;
  LSTimePickerController({
    this.value,
  });

  set hour(int hour) {
    value = TimeOfDay(hour: hour, minute: value?.minute ?? 0);
  }

  set minute(int minute) {
    value = TimeOfDay(hour: value?.hour ?? 0, minute: minute);
  }
}

class LSTimePicker extends StatelessWidget {
  final bool enabled;
  final String? labelText;
  final Widget? prefixIcon;
  final LSTimePickerController? controller;
  final ValueChanged<TimeOfDay?>? onchanged;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final bool enableSeconds;
  final TimeOfDay? firstTime;
  final TimeOfDay? lastTime;
  const LSTimePicker({
    Key? key,
    this.enabled = true,
    this.labelText,
    this.prefixIcon,
    this.controller,
    this.onchanged,
    this.validator,
    this.autovalidateMode,
    this.firstTime,
    this.lastTime,
    this.enableSeconds = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lsController = controller ?? LSTimePickerController();

    final localizations = MaterialLocalizations.of(context);
    formatValue(TimeOfDay? d) => d == null
        ? "--:--${enableSeconds ? ":--" : ""}"
        : localizations.formatTimeOfDay(d);

    var stringcontroller = TextEditingController(
      text: formatValue(lsController.value),
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return TextFormField(
          validator: validator,
          autovalidateMode: autovalidateMode,
          controller: stringcontroller,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (value.contains("-")) return;
            int hour = int.parse(value.split(":")[0]),
                minute = int.parse(value.split(":")[1]);
            onchanged?.call(TimeOfDay(hour: hour, minute: minute));
          },
          inputFormatters: [TimeInputFormatter(enableSeconds: enableSeconds)],
          decoration: InputDecoration(
              prefixIcon: prefixIcon,
              labelText: labelText ?? "Date",
              enabled: enabled,
              hintText: "--:--",
              suffixIcon: PopupMenuButton(
                icon: const Icon(Icons.alarm),
                constraints: BoxConstraints(
                  maxWidth: max(constraints.maxWidth, 300),
                ),
                itemBuilder: (context) {
                  return [
                    PopupItemNoInkWell(
                      child: SizedBox(
                          width: max(constraints.maxWidth, 300),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LSHourPicker(
                                        value: lsController.value?.hour ?? 0,
                                        onPicked: (hour) {
                                          lsController.hour = hour!;
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LSMinutePicker(
                                        value: lsController.value?.minute ?? 0,
                                        onPicked: (minute) {
                                          lsController.minute = minute!;
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      stringcontroller.text =
                                          formatValue(lsController.value);
                                      onchanged?.call(lsController.value);
                                    },
                                    child: const Text("OK")),
                              )
                            ],
                          )),
                    )
                  ];
                },
              )),
        );
      },
    );
  }
}
