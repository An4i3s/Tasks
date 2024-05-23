import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget{

final void Function(File pickedImage) onPickImage;

const UserImagePicker({super.key, required this.onPickImage});


@override
  State<StatefulWidget> createState() {
   return _UserImagePickerState();
  }

}

class _UserImagePickerState extends State<UserImagePicker>{

  File? _pickeImageFile; 

   void _pickImage() async{
    //!MissingPluginException (MissingPluginException(No implementation found for method pickImage on channel plugins.flutter.io/image_picker))
   final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    if(pickedImage == null){
      return;
    }

   setState(() {
     _pickeImageFile = File(pickedImage.path);
   });

    widget.onPickImage(_pickeImageFile!);
   }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickeImageFile != null ? FileImage(_pickeImageFile!) : null,
        ),
        TextButton.icon(onPressed: _pickImage, icon: Icon(Icons.image), label: Text('Add Image', style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),)),
      ],
    );
  }

}