import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sathiclub/home/repository/firebaseHomeApi.dart';

import '../../authentication/models/ProfileModel.dart';

enum CardStatus { like, dislike, superLike }

class CardProvider extends ChangeNotifier{
  final String _currentUID = FirebaseAuth.instance.currentUser!.uid;
  List <ProfileModel>_profiles = [];
  Offset _position = Offset.zero;
  bool _isDragging = false;
  Size _screenSize = Size.zero;
  double _angle = 0;



  List<ProfileModel> get profiles=>_profiles;
  Offset get position =>_position;
  bool get isDragging =>_isDragging;
  double get angle =>_angle;

  set profiles(List<ProfileModel>value ){
    _profiles = value;
    notifyListeners();
  }

  void setScreenSize(Size screenSize)=>_screenSize = screenSize;

  void startPosition(DragStartDetails details){
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details){
  _position += details.delta;
  final x = _position.dx;
  _angle = 45 *x/_screenSize.width;
  notifyListeners();
  }

  void endPosition(){
   _isDragging = false;//this is to get out the image of screen
   final status = getStatus(force: true);

       switch (status){
         case CardStatus.like:
           like();
         break;

         case CardStatus.dislike:
         dislike();
         break;

         case CardStatus.superLike:
         superLike();
         break;

         default:
           resetPosition();
       }
   //resetPosition();
   notifyListeners();
  }
  void resetPosition(){
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }
  double getStatusOpacity(){
    const delta =100;
    final pos = max(_position.dx.abs(),_position.dy.abs());
    final opacity = pos/delta;
    return min(opacity,1);
  }
  CardStatus ? getStatus({bool force = false}){
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs()<20;
    if(force){
      const delta = 100;
      if(x>=delta){
        return CardStatus.like;
      }else if(x<= -delta){
        return CardStatus.dislike;
      }else if(y<= -delta/2 && forceSuperLike){
        return CardStatus.superLike;
      }

    }else{
      const delta = 20;
      if(x>=delta){
        return CardStatus.like;
      }else if(x<= -delta){
        return CardStatus.dislike;
      }else if(y<= -delta/2 && forceSuperLike){
        return CardStatus.superLike;
      }
    }

  }
  void dislike(){
    _angle = -20;
    _position -= Offset(2*_screenSize.width,0);
    _nextCard();
    notifyListeners();
  }

  Future<void> like() async {
    _angle = 20;
    _position += Offset(2*_screenSize.width,0);
    _nextCard();
    await FirebaseHomeApi().hitLike(currentUID:_currentUID,likedUID:_profiles.last.user.id);
    notifyListeners();
  }
  Future<void> superLike() async {
    _angle = 0;
    _position -= Offset(0,_screenSize.height);
    _nextCard();
    await FirebaseHomeApi().hitSuperLike(currentUID:_currentUID,likedUID:_profiles.last.user.id);
    notifyListeners();
  }

  Future _nextCard()async{
    if(profiles.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 200));
    profiles.removeLast();
    resetPosition();
  }





}