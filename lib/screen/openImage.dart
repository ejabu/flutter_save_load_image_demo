import 'dart:io';
import 'package:flutter/material.dart';

import '../screen/component/displayImage.dart';
import '../service/localStorage.dart';

class OpenImage extends StatefulWidget {
  @override
  _OpenImageState createState() => _OpenImageState();
}

class _OpenImageState extends State<OpenImage> {
  File loadedImage;
  String imageFilename = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future loadImage() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        File result = await LocalStorage().loadImageLocal(
          imageFilename: imageFilename,
        );
        setState(() {
          loadedImage = result;
        });
      } on FormatException catch (e) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('$imageFilename ${e.message}. Check image filename'),
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Open Saved Images",
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 20),
                DisplayImage(
                  imageData: loadedImage,
                ),
                RaisedButton(
                  onPressed: loadImage,
                  child: Text(
                    'Load Image Locally',
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 80,
                  child: Form(
                    key: this._formKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Image Filename",
                      ),
                      onSaved: (value) {
                        if (value.isNotEmpty) {
                          imageFilename = value;
                        }
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must provide filename';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
