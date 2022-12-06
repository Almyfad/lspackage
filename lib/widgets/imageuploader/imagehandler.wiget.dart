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
      return LSImageFromStorageLoader(
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

class LSImageFromStorageLoader extends StatelessWidget {
  const LSImageFromStorageLoader({
    Key? key,
    this.height,
    this.width,
    required this.future,
    this.fit,
    this.aspectRatio,
    this.aspectRatioOnError,
    this.widgetError,
  }) : super(key: key);
  final double? height;
  final double? width;
  final Future<String?> future;
  final BoxFit? fit;
  final double? aspectRatio;
  final double? aspectRatioOnError;
  final Widget? widgetError;

  @override
  Widget build(BuildContext context) {
    var lsFutureBuilder = LSFutureBuilder<String?>(
      future: future,
      builder: (BuildContext context, snap) {
        if (snap.data == null) {
          return _CustomAspectRation(
            aspectRatio: aspectRatioOnError,
            child: widgetError ??
                const Opacity(
                  opacity: 0.5,
                  child: Center(
                    child: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  ),
                ),
          );
        }
        if (snap.data!.isEmpty) {
          return _CustomAspectRation(
            aspectRatio: aspectRatioOnError,
            child: widgetError ??
                const Opacity(
                  opacity: 0.5,
                  child: Center(
                    child: Icon(
                      Icons.warning_outlined,
                      color: Colors.red,
                    ),
                  ),
                ),
          );
        }
        return _CustomAspectRation(
          aspectRatio: aspectRatio,
          child: Image.network(
            snap.data!,
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
          ),
        );
      },
    );
    return lsFutureBuilder;
  }
}

class _CustomAspectRation extends StatelessWidget {
  final double? aspectRatio;
  final Widget child;
  const _CustomAspectRation({
    Key? key,
    this.aspectRatio,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (aspectRatio == null) return child;
    return AspectRatio(aspectRatio: aspectRatio!, child: child);
  }
}
