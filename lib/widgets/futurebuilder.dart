import 'package:flutter/material.dart';
import 'package:lspackage/widgets/somethingwentwrong.dart';

class LSFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget? progressIndicator;
  final Widget? noelement;
  final Widget? error;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot)
      builder;

  const LSFutureBuilder(
      {Key? key,
      required this.future,
      this.progressIndicator,
      this.noelement,
      this.error,
      required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(
                child: SomethingWenWrong(
                  msg: "network issue",
                ),
              );
            case ConnectionState.waiting:
            case ConnectionState.active:
              return progressIndicator ??
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ));
            case ConnectionState.done:
              if (snapshot.hasError) {
                return error ??
                    Center(
                      child: SomethingWenWrong(
                        msg: snapshot.error.toString(),
                      ),
                    );
              }
              if (snapshot.hasData==false && (null is T) == false ) {
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
