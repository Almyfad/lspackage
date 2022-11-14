import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class LSRingColorPicker extends StatefulWidget {
  final ButtonStyle? style;
  final Color initialColor;
  final bool enableAplha;
  final bool displayThumbColor;
  final ValueChanged<Color> onColorChanged;
  final Widget child;
  const LSRingColorPicker({
    Key? key,
    this.style,
    required this.initialColor,
    required this.enableAplha,
    required this.displayThumbColor,
    required this.onColorChanged,
    required this.child,
  }) : super(key: key);

  @override
  State<LSRingColorPicker> createState() => _LSRingColorPickerState();
}

class _LSRingColorPickerState extends State<LSRingColorPicker> {
  late Color currentcolor = widget.initialColor;
  late ButtonStyle buttonStyle = widget.style ?? ElevatedButton.styleFrom();
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(currentcolor)),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? const BorderRadius.vertical(
                            top: Radius.circular(500),
                            bottom: Radius.circular(100),
                          )
                        : const BorderRadius.horizontal(
                            right: Radius.circular(500)),
              ),
              content: SingleChildScrollView(
                child: Stack(
                  children: [
                    HueRingPicker(
                      pickerColor: widget.initialColor,
                      onColorChanged: ((value) {
                        setState(() {
                          currentcolor = value;
                        });
                        widget.onColorChanged(value);
                      }),
                      enableAlpha: widget.enableAplha,
                      displayThumbColor: widget.displayThumbColor,
                    ),
                    Positioned(
                      top: 110,
                      left: 350,
                      child: Container(
                        color: Colors.white,
                        width: 145,
                        height: 42,
                        child: ElevatedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.color_lens),
                            label: const Text("Valider")),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      child: widget.child,
    );
  }
}
