import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart'as basePath;
import 'package:sathiclub/authentication/repository/firebaseFileApi.dart';
import 'package:video_compress/video_compress.dart';

import '../../constants/themeColors.dart';
import '../models/UserModel.dart';
import '../models/VideoModel.dart';
import '../repository/firebaseApi.dart';
import '../repository/videoCompressApi.dart';
import '../widgets/ProgressDialogWidget.dart';
import '15_video_trimmer_page.dart';

class VideoPage extends StatefulWidget {
  final String mUid;
  final UserModel mUser;
  final bool fromSignup;
  const VideoPage({Key? key,
    required this.mUid,
    required this.mUser,
    required this.fromSignup,
  }) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  File ? mVideo;
  bool _isCompressing = false;
  bool _isSaving = false;
  Uint8List ? thumbnailBytes;
  int ? videoSize;
  MediaInfo? compressVideoInfo;
  @override
  Widget build(BuildContext context) {
    return videoPage();
  }

  Widget videoPage(){
    final double screenWidth = MediaQuery.of(context).size.width;
    final fileName = mVideo!=null? basePath.basename(mVideo!.path).replaceAll('image_picker', ''):'';
    return SingleChildScrollView(
      child: Column(
        children: [
          if(widget.fromSignup)
            const SizedBox(height: 40,),
          if(widget.fromSignup)
          Align(
                alignment: Alignment.centerLeft,
                child:  Container()),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment:Alignment.center,
              child: Text('Pick your video  ',
                style:TextStyle (
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white),),
            ),
          ),
          SizedBox(height: 40,),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: screenWidth/1.5,
              width: screenWidth/1.5,
              color: Colors.white,
              child: GestureDetector(
                onTap: (){
                  selectVideo();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(mVideo==null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 36),
                      child: CircleAvatar(
                          backgroundColor: themeButtonColor,
                          child: Icon(Icons.add,color:Colors.white,size:36)),
                    ),
                    if(mVideo!=null)
                    buildThumbnail(),
                    SizedBox(height: 24,),
                    buildVideoInfo(),
                    buildCompressedInfo(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment:Alignment.center,
              child: Text(fileName,
                style:TextStyle (
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey),),
            ),
          ),
        ],
      ),
    );

  }

  Widget buildThumbnail()=>thumbnailBytes==null
      ?CircularProgressIndicator():
  Image.memory(thumbnailBytes!,height: 120,);
  Widget buildVideoInfo(){
    if(videoSize == null)return Container();
    final size = videoSize!/1000;
    return Column(
      children: [
        Text('Original video Info',
          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
        ),
        Text('Size:$size KB',
          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
        ),
        Text(mVideo!.path,
          style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
        )

      ],
    );
  }
  Widget saveVideoButton(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
            style:ElevatedButton.styleFrom(
              primary: _isSaving?themeButtonColor.withOpacity(.5):themeButtonColor,
              onPrimary: Colors.white,
              minimumSize: const Size(double.infinity,50),
            ),
            child: Text(_isSaving?'Saving':'Save',style: TextStyle(fontSize: 18),),
            onPressed:() {
                  if(!_isSaving){
                    setState(() {_isSaving = true;});
                  }
              }

        ),
      ),
    );
  }
  Widget compressVideoButton(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
            style:ElevatedButton.styleFrom(
              primary: _isCompressing?themeButtonColor.withOpacity(.5):themeButtonColor,
              onPrimary: Colors.white,
              minimumSize: const Size(double.infinity,50),
            ),
            child: Text(_isCompressing?'Compressing':'Compress',style: TextStyle(fontSize: 18),),
            onPressed:() {
              if(!_isCompressing){
                setState(() {_isCompressing = true;});
                  trimVideo(mVideo!);
              }
            }

        ),
      ),
    );
  }
  Widget clearVideoButton(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
            style:ElevatedButton.styleFrom(
              primary: themeButtonColor,
              onPrimary: Colors.white,
              minimumSize: const Size(double.infinity,50),
            ),
            child: Text('Clear',style: TextStyle(fontSize: 18),),
            onPressed:() {
              clearSelection();
            }

        ),
      ),
    );
  }

  Future selectVideo ()async{
    final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery,);
    if(pickedVideo==null) return;
    //setState(()=>mVideo = File(pickedVideo.path));
    mVideo = File(pickedVideo.path);
    //generateThumbnail(mVideo!);
    //getVideoSize(mVideo!);
    trimVideo(mVideo!);
  }
  Future generateThumbnail(File file )async{
    final thumbnailBytes = await VideoCompress.getByteThumbnail(file.path);
    //setState(()=>this.thumbnailBytes =thumbnailBytes );
  }
  Future getVideoSize(File file)async {
    final size = await file.length();
    setState(()=>videoSize = size);
  }
  void trimVideo(File file){

  }


  Future compressVideo() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder:(context)=>Dialog(
          child:ProgressDialogWidget()),
    );
    final info = await VideoCompressApi.compressVideo(mVideo!);
    if(info !=null){


    }else {
    }
    setState(()=> compressVideoInfo = info);
    setState(()=>_isCompressing = false);
    Navigator.of(context).pop();
  }
  Widget buildCompressedInfo(){
    if(compressVideoInfo==null) return Container();
    //final size = compressVideoInfo!.filesize!/1000;
    //print(compressVideoInfo!.filesize!/1000);
    return Column(
      children: [
        Text('Compress Video Info',style: TextStyle(
          fontSize: 18,fontWeight: FontWeight.bold,),),
        //Text('Size:$size KB'),
        Text('${compressVideoInfo!.path}')

      ],
    );
  }
  void clearSelection(){
    compressVideoInfo = null;
    mVideo = null;

  }




}

