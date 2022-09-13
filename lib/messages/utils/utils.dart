import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import '../../common/widgets/ShowSnackBar.dart';



Future<File?>pickImageFromGallery(BuildContext context)async{
  File ? mImage;
  try{
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage!=null){
      mImage = File(pickedImage.path);
      print('Normal file path');
      print(pickedImage.path);
    }

  }catch(e){
    showSnackBar(context: context, content: e.toString());

  }
  return mImage;
}
Future<File?>pickVideoFromGallery(BuildContext context)async{
  File ? mVideo;
  try{
    final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if(pickedVideo!=null){
      mVideo = File(pickedVideo.path);
    }

  }catch(e){
    showSnackBar(context: context, content: e.toString());

  }
  return mVideo;
}
Future<GiphyGif?>pickGIF(BuildContext context)async{
  GiphyGif ? gif;
  try{
    gif = await Giphy.getGif(context:context,apiKey:'ExlWOFFuFeX3eukXwP1mNR0A3Ua5BCw1');
  }catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return gif;

}