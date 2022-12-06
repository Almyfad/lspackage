import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lspackage/widgets/futurebuilder.dart';

class ImageHandler extends StatelessWidget {
  final PlatformFile? image;
  final Future<String>? future;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const ImageHandler({
    Key? key,
    this.image,
    this.future,
    this.width,
    this.height,
    this.fit,
  })  : assert(image != null || future != null,
            "image ou future doit etre renseigné"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (future != null) {
      return ImageFromStorageLoader(
        fit: fit,
        future: future!,
        width: width,
        height: height,
      );
    }
    if (image != null) {
      return ImageFromFileBytes(
        file: image!,
        width: width,
        height: height,
      );
    }

    return const Icon(
      Icons.error,
      color: Colors.redAccent,
    );
  }
}

class ImageFromFileBytes extends StatelessWidget {
  final double? height;
  final double? width;
  final PlatformFile file;
  const ImageFromFileBytes({
    Key? key,
    this.height,
    this.width,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.memory(file.bytes!, width: width, height: height);
  }
}

class ImageFromStorageLoader extends StatelessWidget {
  const ImageFromStorageLoader({
    Key? key,
    this.height,
    this.width,
    required this.future,
    this.fit,
  }) : super(key: key);
  final double? height;
  final double? width;
  final Future<String> future;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return LSFutureBuilder<String?>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
        if (snap.data == null) {
          return const Center(
            child: Icon(Icons.error),
          );
        }
        return Image.network(
          snap.data,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
