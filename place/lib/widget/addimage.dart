import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class AddImage extends StatefulWidget {
  final Function getImage;
  AddImage(this.getImage);
  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  File _storeImage;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 600);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storeImage = File(imageFile.path);
    });
    final fileName = path.basename(imageFile.path);
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');
    widget.getImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storeImage != null
              ? Image.file(
                  _storeImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Found',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(width: 10),
        Expanded(
            child: TextButton.icon(
          onPressed: _takePicture,
          icon: Icon(Icons.camera),
          label: Text(
            'Take Picture',
            textAlign: TextAlign.center,
          ),
        )),
      ],
    );
  }
}
