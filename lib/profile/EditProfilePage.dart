import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sathiclub/authentication/pages/16_change_password.dart';
import 'package:sathiclub/authentication/pages/4_dob_page.dart';
import 'package:sathiclub/authentication/pages/8_passion_page.dart';

import '../authentication/models/InterestModel.dart';
import '../authentication/models/PhotoModel.dart';
import '../authentication/models/UserModel.dart';
import '../authentication/pages/11_welcome_page.dart';
import '../authentication/pages/13_phone_page.dart';
import '../authentication/pages/14_video_page.dart';
import '../authentication/pages/15_video_trimmer_page.dart';
import '../authentication/pages/3_name_page.dart';
import '../authentication/pages/5_gender_page.dart';
import '../authentication/pages/6_orientation_page.dart';
import '../authentication/pages/7_show_page.dart';
import '../authentication/pages/9_photo_page.dart';

class EditProfilePage extends StatefulWidget {
  final File ? mVideo;
  final String mUid;
  final UserModel mUser;
  final List<InterestModel>mInterests;
  final List<PhotoModel>mPhotos;
  final String title;
  const EditProfilePage(
  {Key? key,
  required this.mUid,
  required this.mUser,
  required this.mInterests,
  required this.mPhotos,
  required this.title,
  required this.mVideo,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,),
        body:Container(
          child:
          widget.title=='Name'?NamePage(mUid: widget.mUid,mUser: widget.mUser,fromSignup: false,):
          widget.title=='Date of Birth'? DateOfBirthPage(mUid: widget.mUid,mUser: widget.mUser,fromSignup: false,):
          widget.title=='Phone'?  PhonePage(mUid: widget.mUid,mUser: widget.mUser,fromSignup: false,):
          widget.title=='Gender'? GenderPage(mUid: widget.mUid,mUser: widget.mUser,fromSignup: false,):
          widget.title=='Orientation'?  OrientationPage(mUid: widget.mUid,mUser: widget.mUser,fromSignup: false,):
          widget.title=='Preference'?  PreferencePage(mUid: widget.mUid,mUser: widget.mUser,fromSignup: false,):
          widget.title=='Description'?  CongratulationPage(mUid: widget.mUid,mUser: widget.mUser,fromSignup: false,):
          widget.title=='Interests'?  InterestPage(mUid: widget.mUid,mUser: widget.mUser,mInterests:widget.mInterests,fromSignup: false,):
          widget.title=='Photos'?  PhotoPage(mUid: widget.mUid,mUser: widget.mUser,mPhotos:widget.mPhotos,fromSignup: false,):
          widget.title=='Videos'?  VideoTrimmerPage(mUid: widget.mUid,mUser: widget.mUser,fromSignup: false,mVideo: widget.mVideo,):
          widget.title=='ChangePassword'?  ChangePasswordPage(mUid: widget.mUid,mUser: widget.mUser,fromSignup: false,):
          Container(),
        )
        );

  }
}
