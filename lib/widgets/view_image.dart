import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatelessWidget {
  final image;
  ViewImage(this.image);
  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: NetworkImage(image),
      enableRotation: true,
    );
  }
}
