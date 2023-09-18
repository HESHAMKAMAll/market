import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source,context)async{
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if(_file!= null){
    return await _file.readAsBytes();
  }
  showSnackBar("No image selected",context);
}

showSnackBar(String content, BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content),duration: Duration(seconds: 2),));
}


const List<String> list = <String>['No Category', 'iPhone'];