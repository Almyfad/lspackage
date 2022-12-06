import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadResult {
  PlatformFile file;
  String reference;
  UploadResult({
    required this.file,
    required this.reference,
  });
}

String getmimeTypeFromExtension(String? extension) {
  switch (extension?.toLowerCase()) {
    case "jpeg":
    case "jpg":
      return "image/jpeg";
    case "png":
      return "image/png";
    case "gif":
      return "image/gif";
    case "webp":
      return "image/webp";
    default:
      return "application/octet-stream";
  }
}

class FileUploadManager {
  static Future<bool?> show(
      BuildContext context,
      String imagePath,
      String itemId,
      List<PlatformFile> files,
      Function(List<UploadResult>) onAllUploaded) {
    var tasks = List.generate(
        files.length,
        (i) => FirebaseStorage.instance
            .ref("$imagePath/${itemId}_$i.${files[i].extension}")
            .putData(
                files[i].bytes!,
                SettableMetadata(
                    cacheControl: "max-age=3600",
                    contentType:
                        getmimeTypeFromExtension(files[i].extension))));
    List<UploadResult> completed = List.empty(growable: true);

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Center(child: Text("Téléversement en cours...")),
            content: SizedBox(
              width: 300,
              height: 26.0 * tasks.length,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ItemProgressBar(
                      task: tasks[i],
                      onUploaded: (e) {
                        completed.add(UploadResult(
                            file: files[i], reference: e.fullPath));
                        if (completed.length >= tasks.length) {
                          onAllUploaded(completed);
                          Navigator.pop(context);
                        }
                      },
                    );
                  }),
            ));
      },
    );
  }
}

class ItemProgressBar extends StatefulWidget {
  final UploadTask task;
  final Function(Reference) onUploaded;
  const ItemProgressBar({
    Key? key,
    required this.task,
    required this.onUploaded,
  }) : super(key: key);

  @override
  State<ItemProgressBar> createState() => _ItemProgressBarState();
}

class _ItemProgressBarState extends State<ItemProgressBar> {
  double progress = 0.0;
  @override
  void initState() {
    super.initState();
    widget.task.snapshotEvents.listen((event) {
      setState(() {
        progress = event.bytesTransferred / event.totalBytes;
      });
      if (event.state != TaskState.running) {
        widget.onUploaded(event.ref);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 10,
      ),
    );
  }
}
