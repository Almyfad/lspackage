
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lspackage/classes/dateinputformatter.dart';
import 'package:lspackage/widgets/popupitemnoinkwell.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class LSDatePickerController {
  DateTime? value;
  LSDatePickerController({
    this.value,
  });
}

class LSDatePicker extends StatelessWidget {
  final bool enabled;
  final String? labelText;
  final Widget? prefixIcon;
  final LSDatePickerController? controller;
  final ValueChanged<DateTime?>? onchanged;
  const LSDatePicker({
    Key? key,
    this.enabled = true,
    this.labelText,
    this.prefixIcon,
    this.controller,
    this.onchanged,
  }) : super(key: key);

  String formatValue(DateTime? d) =>
      d == null ? "--/--/----" : DateFormat("dd/MM/yyyy").format(d);

  @override
  Widget build(BuildContext context) {
    var lsController = controller ?? LSDatePickerController();
    var stringcontroller = TextEditingController(
      text: formatValue(lsController.value),
    );

    return LayoutBuilder(builder: (context, constraints) {
      return TextFormField(
        controller: stringcontroller,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value.contains("-")) return;
          onchanged?.call(DateFormat("dd/MM/yyyy").parse(value));
        },
        inputFormatters: [
          DateInputFormatter(),
        ],
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
            labelText: labelText ?? "Date",
            enabled: enabled,
            hintText: "--/--/---",
            suffixIcon: PopupMenuButton(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              itemBuilder: (context) {
                return [
                  PopupItemNoInkWell(
                    child: SizedBox(
                        width: constraints.maxWidth,
                        child: SfDateRangePicker(
                          enablePastDates: true,
                          allowViewNavigation: true,
                          showNavigationArrow: true,
                          onSelectionChanged: (e) {
                            lsController.value = e.value;
                            stringcontroller.text =
                                formatValue(lsController.value);
                            onchanged?.call(e.value);
                            Navigator.pop(context);
                          },
                        )),
                  )
                ];
              },
            )),
      );
    });
  }
}

