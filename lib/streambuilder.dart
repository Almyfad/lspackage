import 'package:flutter/material.dart';
import 'package:lspackage/somethingwentwrong.dart';

class LSStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget? progressIndicator;
  final Widget? noelement;
  final Widget? error;
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;

  const LSStreamBuilder(
      {Key? key,
      required this.stream,
      this.progressIndicator,
      this.noelement,
      this.error,
      required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        stream: stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(
                child: SizedBox(
                  height: 70,
                  child: SomethingWenWrong(
                    msg: "network issue",
                  ),
                ),
              );
            case ConnectionState.waiting:
              return progressIndicator ??
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ));
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return error ??
                    Center(
                      child: SizedBox(
                        height: 70,
                        child: SomethingWenWrong(
                          msg: snapshot.error.toString(),
                        ),
                      ),
                    );
              }
              if (!snapshot.hasData) {
                return noelement ??
                    const Center(
                      child: SizedBox(
                        height: 70,
                        child: SomethingWenWrong(
                          msg: "No Data",
                        ),
                      ),
                    );
              }
              return builder(context, snapshot);
          }
        });
  }
}
