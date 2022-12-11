import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lspackage/widgets/imageuploader/imagehandler.wiget.dart';

class LSSingleImagePicker extends StatefulWidget {
  final Image? initialImage;
  final Alignment? initialAlignement;
  final Future<String?>? initialImagfuture;
  final Color? pickerbackgroundColor;
  final Color? pickerforegroundColor;
  final DecorationImage? pickerImageBackground;
  final double? pickerImageBackgroundOpacity;
  final String? pickerText;
  final ValueChanged<PlatformFile> onFilePicked;
  final ValueChanged<Alignment>? onAlignmentChanged;
  const LSSingleImagePicker({
    Key? key,
    this.initialImage,
    this.initialAlignement,
    this.initialImagfuture,
    this.pickerbackgroundColor,
    this.pickerforegroundColor,
    this.pickerImageBackground,
    this.pickerImageBackgroundOpacity,
    this.pickerText,
    required this.onFilePicked,
    this.onAlignmentChanged,
  }) : super(key: key);

  @override
  State<LSSingleImagePicker> createState() => _SingleImagePickerState();
}

class _SingleImagePickerState extends State<LSSingleImagePicker> {
  PlatformFile? imagepicked;
  late Alignment imageAlignement;

  @override
  void initState() {
    super.initState();
    imageAlignement = widget.initialAlignement ?? Alignment.center;
  }

  @override
  Widget build(BuildContext context) {
    if (imagepicked != null) {
      return _PickedImageHandler(
        onTap: pickimage,
        onAlignmentChanged: onUpdateAlignement,
        onMoveImage: (value) => setState(() {
          imageAlignement = value;
        }),
        initialAlignement: imageAlignement,
        child: ImageFromFileBytes(
          alignment: imageAlignement,
          fit: BoxFit.cover,
          file: imagepicked!,
        ),
      );
    }

    if (widget.initialImage != null) {
      return InkWell(onTap: pickimage, child: widget.initialImage!);
    }

    var emptypicker = Container(
      decoration: BoxDecoration(
          color: widget.pickerbackgroundColor ??
              Theme.of(context).backgroundColor.withOpacity(0.5),
          image: widget.pickerImageBackground),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(Icons.camera_alt_sharp,
              color: widget.pickerforegroundColor ?? Colors.black54),
          Text(
            widget.pickerText ?? "Cliquez pour ajouter une photo",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: widget.pickerforegroundColor ?? Colors.black54,),
          )
        ],
      ),
    );

    if (widget.initialImagfuture != null) {
      return _PickedImageHandler(
        onTap: pickimage,
        onAlignmentChanged: onUpdateAlignement,
        onMoveImage: (value) => setState(() {
          imageAlignement = value;
        }),
        initialAlignement: imageAlignement,
        child: LSImageFromStorageLoader(
          alignment: imageAlignement,
          fit: BoxFit.cover,
          widgetError: emptypicker,
          future: widget.initialImagfuture!,
        ),
      );
    }

    return InkWell(onTap: pickimage, child: emptypicker);
  }

  void onUpdateAlignement(Alignment details) {
    widget.onAlignmentChanged?.call(details);
  }

  void pickimage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        imagepicked = result.files.first;
      });
      widget.onFilePicked(imagepicked!);
    } else {
      // User canceled the picker
    }
  }
}

class _PickedImageHandler extends StatefulWidget {
  final Alignment? initialAlignement;
  final ValueChanged<Alignment>? onMoveImage;
  final ValueChanged<Alignment>? onAlignmentChanged;
  final Widget child;
  final Function() onTap;

  const _PickedImageHandler({
    Key? key,
    this.initialAlignement,
    this.onMoveImage,
    this.onAlignmentChanged,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_PickedImageHandler> createState() => __PickedImageHandlerState();
}

class __PickedImageHandlerState extends State<_PickedImageHandler> {
  bool imageHovered = false;
  late Alignment imageAlignement;

  @override
  void initState() {
    super.initState();
    imageAlignement = widget.initialAlignement ?? Alignment.center;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (event) {
        if (imageHovered == false) {
          setState(() {
            imageHovered = true;
          });
        }
      },
      onExit: (event) {
        if (imageHovered == true) {
          setState(() {
            imageHovered = false;
          });
        }
      },
      child: GestureDetector(
        onPanUpdate: moveimage,
        onPanEnd: (details) => widget.onAlignmentChanged?.call(imageAlignement),
        child: Stack(
          children: [
            SizedBox(width: double.infinity, child: widget.child),
            Visibility(
              visible: imageHovered,
              child: Container(
                  width: double.infinity,
                  color: Colors.black45.withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:const  [
                      Icon(Icons.arrow_drop_up_outlined, color: Colors.white),
                      Icon(Icons.mouse_sharp, color: Colors.white),
                      Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
                      Text(
                        "Glissez pour faire monter ou descendre l'image",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  void moveimage(details) {
    double movefactor = 0.01;
    Alignment newalignment = Alignment(imageAlignement.x, imageAlignement.y);
    if (details.delta.dx > 0 && newalignment.x > -1.0) {
      newalignment = Alignment(newalignment.x - movefactor, newalignment.y);
    }
    if (details.delta.dx < 0 && newalignment.x < 1.0) {
      newalignment = Alignment(newalignment.x + movefactor, newalignment.y);
    }

    if (details.delta.dy > 0 && newalignment.y > -1.0) {
      newalignment = Alignment(newalignment.x, newalignment.y - movefactor);
    }
    if (details.delta.dy < 0 && newalignment.y < 1.0) {
      newalignment = Alignment(newalignment.x, newalignment.y + movefactor);
    }

    if (newalignment != imageAlignement) {
      imageAlignement = newalignment;
      widget.onMoveImage?.call(imageAlignement);
    }
  }
}
