import 'package:flutter/material.dart';

class FileCard extends StatelessWidget {
  final Widget child;
  final Color cornercolor;
  final double cornersize;
  final Function()? onpressed;
  const FileCard({
    Key? key,
    required this.child,
    required this.cornercolor,
    required this.cornersize,
    this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: ClipPath(
          clipper: Rootclip(cornersize),
          child: Card(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: cornersize),
                  child: child,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cornercolor,
                      boxShadow: [
                        BoxShadow(
                          color: cornercolor,
                          offset: const Offset(0.0, 1.0),
                          blurRadius: 3.0,
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(5.0),
                      ),
                    ),
                    width: cornersize - 6,
                    height: cornersize - 6,
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class Rootclip extends CustomClipper<Path> {
  final double cornersize;

  Rootclip(this.cornersize);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width - cornersize, 0);
    path.lineTo(size.width, cornersize);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
