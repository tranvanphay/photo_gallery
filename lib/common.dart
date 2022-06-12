import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  const ImageTile({
    Key? key,
    required this.url,
    required this.width,
    required this.height,
  }) : super(key: key);

  final String url;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width.toDouble(),
      height: height.toDouble(),
      fit: BoxFit.cover,
    );
  }
}
