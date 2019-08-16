import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../screen/openImage.dart';
import '../screen/component/displayImage.dart';
import '../service/localStorage.dart';

class SaveImageScreen extends StatefulWidget {
  @override
  _SaveImageScreenState createState() => _SaveImageScreenState();
}

class _SaveImageScreenState extends State<SaveImageScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File imageData;
  String newFilename = '';

  Future saveImage() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await LocalStorage().saveImageLocal(
        imageData: imageData,
        newFilename: newFilename,
      );
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('$newFilename saved successfully'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageData = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(
          "Saving Image Locally",
        ),
      ),
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              elevation: 4.0,
              icon: const Icon(Icons.camera_front),
              label: const Text('Open Saved Images'),
              onPressed: getOpenImageScreen,
            )
          : null,
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 20),
                DisplayImage(
                  imageData: imageData,
                ),
                RaisedButton.icon(
                  onPressed: getImage,
                  icon: Icon(Icons.photo_size_select_large),
                  label: Text(
                    'Load Image From Gallery',
                  ),
                ),
                SizedBox(height: 20),
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
                        newFilename = value;
                      },
                      onFieldSubmitted: (value) {
                        newFilename = value;
                        saveImage();
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
                RaisedButton.icon(
                  onPressed: saveImage,
                  icon: Icon(Icons.save),
                  label: Text(
                    'Save Image Locally',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getOpenImageScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return OpenImage();
        },
      ),
    );
  }
}
