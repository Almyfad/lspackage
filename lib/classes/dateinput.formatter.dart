import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var nwvalue = newValue.text.replaceAll("-", "").replaceAll("/", "");

    if (newValue.text.length < oldValue.text.length) {
      var oldvalue = oldValue.text.replaceAll("-", "").replaceAll("/", "");

      if (oldvalue.isNotEmpty) {
        oldvalue = oldvalue.substring(0, oldvalue.length - 1).padRight(8, "-");

        oldvalue =
            "${oldvalue.substring(0, 2)}/${oldvalue.substring(2, 4)}/${oldvalue.substring(4, 8)}";
      }

      return newValue.copyWith(
          text: oldvalue,
          selection: TextSelection(
              baseOffset: oldvalue.indexOf("-"),
              extentOffset: oldvalue.indexOf("-")));
    }

    day() =>
        newValue.text.split("/")[0].replaceAll("-", "").replaceAll("/", "");
    month() =>
        newValue.text.split("/")[1].replaceAll("-", "").replaceAll("/", "");
    year() =>
        newValue.text.split("/")[2].replaceAll("-", "").replaceAll("/", "");

    var maxdates = {
      DateTime.january: 31,
      DateTime.february: 29,
      DateTime.march: 31,
      DateTime.april: 30,
      DateTime.may: 31,
      DateTime.june: 30,
      DateTime.july: 31,
      DateTime.august: 31,
      DateTime.september: 30,
      DateTime.october: 31,
      DateTime.november: 30,
      DateTime.december: 31,
    };

    switch (nwvalue.length) {
      case 0:
        return newValue.copyWith(
            text: "--/--/----",
            selection: const TextSelection(baseOffset: 0, extentOffset: 0));
      case 1:
        var rex = RegExp(r'^[0-3]$');
        if (rex.hasMatch(nwvalue)) {
          return newValue.copyWith(
              text: "$nwvalue-/--/---",
              selection: const TextSelection(baseOffset: 1, extentOffset: 1));
        }
        rex = RegExp(r'^[4-9]$');
        if (rex.hasMatch(nwvalue)) {
          return newValue.copyWith(
              text: "0$nwvalue/--/---",
              selection: const TextSelection(baseOffset: 3, extentOffset: 3));
        }
        return oldValue;
      case 2:
        var rex = RegExp(r'^[0-2][0-9]|30|31$');
        if (rex.hasMatch(nwvalue)) {
          return newValue.copyWith(
              text: "$nwvalue/--/---",
              selection: const TextSelection(baseOffset: 3, extentOffset: 3));
        }
        rex = RegExp(r'^3[2-9]|[4-9][0-9]$');
        if (rex.hasMatch(nwvalue)) {
          return newValue.copyWith(
              text: "31/--/--",
              selection: const TextSelection(baseOffset: 3, extentOffset: 3));
        }
        return oldValue;
      case 3:
        var rex = RegExp(r'^([0-2][0-9]|30|31)(0|1)$');
        if (rex.hasMatch(nwvalue)) {
          return newValue.copyWith(
              text: "${day()}/${month()}-/---",
              selection: const TextSelection(baseOffset: 4, extentOffset: 4));
        }
        rex = RegExp(r'^([0-2][0-9]|30|31)[2-9]$');
        if (rex.hasMatch(nwvalue)) {
          int pmonth = int.parse(month()), pday = int.parse(day());
          if (pmonth == DateTime.february) {
            if (pday > 29) pday = 29;
          } else {
            if (pday > maxdates[pmonth]!) {
              pday = maxdates[pmonth]!;
            }
          }
          return newValue.copyWith(
              text:
                  "${pday.toString().padLeft(2, "0")}/${pmonth.toString().padLeft(2, "0")}/---",
              selection: const TextSelection(baseOffset: 6, extentOffset: 6));
        }
        return oldValue;
      case 4:
        var rex = RegExp(r'^([0-2][0-9]|30|31)(0[0-9]|1[0-2])$');
        int pday, pmonth;
        if (rex.hasMatch(nwvalue)) {
          pmonth = int.parse(month());
          pday = int.parse(day());
          if (pmonth == DateTime.february) {
            if (pday > 29) pday = 29;
          } else {
            if (pday > maxdates[pmonth]!) {
              pday = maxdates[pmonth]!;
            }
          }
          return newValue.copyWith(
              text:
                  "${pday.toString().padLeft(2, "0")}/${pmonth.toString().padLeft(2, "0")}/---",
              selection: const TextSelection(baseOffset: 6, extentOffset: 6));
        }
        rex = RegExp(r'^([0-2][0-9]|30|31)(1[3-9]|[2-9][0-9])$');
        if (rex.hasMatch(nwvalue)) {
          pmonth = 12;
          pday = int.parse(day());
          return newValue.copyWith(
              text:
                  "${pday.toString().padLeft(2, "0")}/${pmonth.toString().padLeft(2, "0")}/---",
              selection: const TextSelection(baseOffset: 6, extentOffset: 6));
        }
        return oldValue;
      case 5:
        var rex = RegExp(r'^([0-2][0-9]|30|31)(0[0-9]|1[0-2]).$');
        if (rex.hasMatch(nwvalue)) {
          return newValue.copyWith(
              text: "${day()}/${month()}/2---",
              selection: const TextSelection(baseOffset: 7, extentOffset: 7));
        }
        return oldValue;
      case 6:
        var rex = RegExp(r'^([0-2][0-9]|30|31)(0[0-9]|1[0-2])2[0-9]$');
        if (rex.hasMatch(nwvalue)) {
          return newValue.copyWith(
              text: "${day()}/${month()}/${year()}--",
              selection: const TextSelection(baseOffset: 8, extentOffset: 8));
        }
        return oldValue;
      case 7:
        var rex = RegExp(r'^([0-2][0-9]|30|31)(0[0-9]|1[0-2])2[0-9][0-9]$');
        if (rex.hasMatch(nwvalue)) {
          return newValue.copyWith(
              text: "${day()}/${month()}/${year()}-",
              selection: const TextSelection(baseOffset: 9, extentOffset: 9));
        }
        return oldValue;
      case 8:
        var rex =
            RegExp(r'^([0-2][0-9]|30|31)(0[0-9]|1[0-2])2[0-9][0-9][0-9]$');
        if (rex.hasMatch(nwvalue)) {
          int pmonth = int.parse(month()),
              pday = int.parse(day()),
              pyear = int.parse(year());

          if (pmonth == DateTime.february) {
            if (pday == 29) {
              if (isLeapYear(pyear) == false) {
                pday = 28;
              }
            }
          }

          return newValue.copyWith(
              text: "${pday.toString().padLeft(2, "0")}/${month()}/${year()}",
              selection: const TextSelection(baseOffset: 10, extentOffset: 10));
        }
        return oldValue;
      default:
        return oldValue;
    }
  }
}

bool isLeapYear(int year) {
  if (year % 4 == 0) {
    if (year % 100 == 0) {
      if (year % 400 == 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    return false;
  }
}
