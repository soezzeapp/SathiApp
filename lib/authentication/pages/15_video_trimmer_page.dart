import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sathiclub/profile/bloc/profile_video_bloc.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:path/path.dart'as basePath;

import '../../constants/themeColors.dart';
import '../bloc/authentication_bloc.dart';
import '../models/UserModel.dart';
import '../repository/firebaseApi.dart';
import '../repository/firebaseFileApi.dart';

class VideoTrimmerPage extends StatefulWidget {
  final File ?mVideo;
  final String mUid;
  final UserModel mUser;
  final bool fromSignup;
  const VideoTrimmerPage({Key? key,
    required this.mVideo,
    required this.mUser,
    required this.fromSignup,
    required this.mUid,
  }) : super(key: key);

  @override
  _VideoTrimmerPageState createState() => _VideoTrimmerPageState();
}

class _VideoTrimmerPageState extends State<VideoTrimmerPage> {
 final Trimmer _trimmer = Trimmer();
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool _progressVisibility = false;
  String? _value;
  bool _isSaving = false;

  UploadTask ?task;
  UploadTask ?taskThumbnail;

  @override void initState()  {
    super.initState();
    try{_trimmer.loadVideo(videoFile: widget.mVideo!);

    }catch(e){
      print(e);
    }
  }
 @override
 void dispose() {
   _trimmer.dispose();
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    return  Builder(
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.only(bottom: 30.0),
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 80,),
              Visibility(
                visible: _progressVisibility,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.red,
                ),
              ),
              task!=null?buildUploadStatus(task!):Container(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    primary: _isSaving?themeButtonColor.withOpacity(.5):themeButtonColor,
                    onPrimary: Colors.white,
                    minimumSize: const Size(double.infinity,50),
                  ),
                  onPressed:()
                  //_progressVisibility ? null : ()
                  async {
                    if(!_isSaving){
                      setState(() {_isSaving = true;});
                      await _saveVideo();
                    }
                  },
                  child: Text(_isSaving?'Saving':'Save',style: TextStyle(fontSize: 18),),
                ),
              ),
              Expanded(
                child: VideoViewer(trimmer: _trimmer),
              ),
              Center(
                child: TrimEditor(
                  trimmer: _trimmer,
                  durationTextStyle: TextStyle(fontSize: 18,color: Colors.white, decoration: TextDecoration.none,),
                  viewerHeight: 50.0,
                  viewerWidth: MediaQuery.of(context).size.width,
                  maxVideoLength: Duration(seconds: 30),
                  onChangeStart: (value) {
                    _startValue = value;
                  },
                  onChangeEnd: (value) {
                    _endValue = value;
                  },
                  onChangePlaybackState: (value) {
                    setState(() {
                      _isPlaying = value;
                    });
                  },
                ),
              ),
              TextButton(
                child: _isPlaying
                    ? Icon(
                  Icons.pause,
                  size: 80.0,
                  color: Colors.white,
                )
                    : Icon(
                  Icons.play_arrow,
                  size: 80.0,
                  color: Colors.white,
                ),
                onPressed: () async {
                  bool playbackState = await _trimmer.videPlaybackControl(
                    startValue: _startValue,
                    endValue: _endValue,
                  );
                  setState(() {
                    _isPlaying = playbackState;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

 Future<String?> _saveVideo() async {
   setState(() {_progressVisibility = true;});
   await _trimmer
       .saveTrimmedVideo(
       startValue: _startValue,
       endValue: _endValue,
       onSave: (value){
         setState(() {_progressVisibility = false;});
         _value = value;
         uploadFile(value);
       }
    );
   return _value;
 }

 Future uploadFile(String? path) async{
   String id = widget.mUser.id;
   if(path==null)return;
   final mVideo = File(path);
   final thumbnailuint8Listdata = await VideoThumbnail.thumbnailData(video: path,
       imageFormat:ImageFormat.PNG,quality: 25,maxHeight: 300,maxWidth: 300);

   final fileName = basePath.basename(mVideo.path).replaceAll('image_picker', '');

   final destination = '$id/videos/$fileName';
   final destinationThumbnail = '$id/videos/$fileName-thumbnail';

   task = FirebaseApi.uploadBytes(destinationThumbnail, thumbnailuint8Listdata!);
   setState(() {});
   final snapshotThumbnail = await task!.whenComplete(() {});
   final urlDownloadThumbnail = await snapshotThumbnail.ref.getDownloadURL();

   task = FirebaseFileApi.uploadFile(destination, mVideo);
   setState(() {});
   final snapshot = await task!.whenComplete(() {});
   final urlDownload = await snapshot.ref.getDownloadURL();
   setState(() {});
   if(task == null ){
     Navigator.of(context).pop();
     return;
   }

   context.read<ProfileVideoBloc>().add(SaveProfileVideos(userId: widget.mUid,
       url: urlDownload,
       thumbnailUrl:urlDownloadThumbnail));
   Navigator.of(context).pop();
 }


 Widget buildUploadStatus(UploadTask task)=>StreamBuilder<TaskSnapshot>(
     stream:task.snapshotEvents,
     builder:(context,snapshot){
       if(snapshot.hasData){
         final snap = snapshot.data!;
         final progress = snap.bytesTransferred/snap.totalBytes;
         final percentage = (progress*100).toStringAsFixed(2);
         return Text('$percentage %',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),);
       }else{
         return Container();
       }
     });
}



