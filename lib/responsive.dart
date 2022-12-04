import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class LSResponsive extends StatelessWidget {
  final Map<double, Widget> breakPointsWidgets;
  const LSResponsive({
    Key? key,
    required this.breakPointsWidgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (breakPointsWidgets.isEmpty) return Container();

        var keys =
            breakPointsWidgets.keys.toList().sorted((a, b) => a.compareTo(b));

        for (var key in keys) {
          if (constraints.maxWidth < key) {
            return breakPointsWidgets[key]!;
          }
        }

        return breakPointsWidgets[keys.last]!;
      },
    );
  }
}
