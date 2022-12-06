import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lspackage/widgets/imageuploader/imagehandler.wiget.dart';

class LSSingleImagePicker extends StatefulWidget {
  final Image? initialImage;
  final ValueChanged<PlatformFile> onFilePicked;
  const LSSingleImagePicker({
    Key? key,
    this.initialImage,
    required this.onFilePicked,
  }) : super(key: key);

  @override
  State<LSSingleImagePicker> createState() => _SingleImagePickerState();
}

class _SingleImagePickerState extends State<LSSingleImagePicker> {
  PlatformFile? imagepicked;

  @override
  Widget build(BuildContext context) {
    if (imagepicked != null) {
      return InkWell(
        onTap: pickimage,
        child: ImageFromFileBytes(
          file: imagepicked!,
        ),
      );
    }

    if (widget.initialImage != null) {
      return InkWell(onTap: pickimage, child: widget.initialImage!);
    }

    return InkWell(
      onTap: pickimage,
      child: ColoredBox(
        color: Theme.of(context).backgroundColor.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.camera_alt_sharp, color: Colors.black54),
            Text(
              "Cliquez pour ajouter une photo",
              style: TextStyle(color: Colors.black54),
            )
          ],
        ),
      ),
    );
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
