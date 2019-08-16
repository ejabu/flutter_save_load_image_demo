import 'package:flutter/material.dart';
import 'dart:io';

class DisplayImage extends StatelessWidget {
  DisplayImage({
    @required this.imageData,
  });
  final File imageData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200.0,
        height: 200.0,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
              width: 2.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: renderBoxContent(),
        ),
      ),
    );
  }

  Widget renderBoxContent() {
    if (imageData == null ?? imageData.existsSync()) {
      return Center(child: Text('No image selected.'));
    } else {
      return Image.file(imageData);
    }
  }
}
