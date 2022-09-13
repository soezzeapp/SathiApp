import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sathiclub/authentication/bloc/authentication_bloc.dart';
import 'package:sathiclub/authentication/common/defaultUserModel.dart';
import 'package:sathiclub/common/widgets/video_player_both_widget.dart';
import 'package:sathiclub/home/bloc/home_bloc.dart';
import 'package:sathiclub/profile/EditProfilePage.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'as customBoxShadow;

import '../authentication/models/InterestModel.dart';
import '../authentication/models/PhotoModel.dart';
import '../authentication/models/ProfileModel.dart';
import '../authentication/models/UserModel.dart';
import '../authentication/pages/15_video_trimmer_page.dart';
import '../authentication/pages/3_name_page.dart';
import '../common/widgets/potrait_landscape_video_player_widget.dart';
import '../constants/themeColors.dart';
import '../home/bloc/view_bloc/view_bloc.dart';
import '../messages/chat/widgets/video_player_item.dart';
import 'bloc/profile_video_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State <ProfilePage>with TickerProviderStateMixin{
  late TabController _tabController ;
  bool _secureText = true;
  UserModel mUser = DefaultUser.defaultUser;
  List<InterestModel>mInterests = [];
  List<PhotoModel>mPhotos = [];
  bool toNextPage = false;
  File ? mVideo;
  bool isPressedGridView = false;
  bool isPressedSwipeView = false;
  bool isPressedRadarView = false;
  List<ProfileModel>profiles=[];
  List<ProfileModel>profileData=[];
  double distancePreference = 80;
  double agePreference = 30;
  List<dynamic> agePreferenceList= [25,30];
  bool isInit = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<ProfileVideoBloc>().add(GetAllProfileVideos());
    isInit = true;
   // distancePreference = state.profile.user.distancePreference.toDouble();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    Offset distance = isPressedGridView ? Offset (10,10):Offset (10,10);
    //Offset (28,28);
    double blur =isPressedGridView ? 5.0: 5.0;
    //30.0;
    return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            centerTitle: true,
            title: const Text('Profile',style: TextStyle(color:Colors.white),),
          ),
          body: BlocBuilder<AuthenticationBloc,AuthenticationState>(
            builder: (context,state) {
              if (state is AuthenticatedState)
              {
                mUser = state.profile.user;
                mInterests = state.profile.interests;
                mPhotos = state.profile.photos;
                //agePreferenceList = state.profile.user.agePreference.toList();
                //agePreference = agePreferenceList[1].toDouble;
                if(isInit){
                  distancePreference = state.profile.user.distancePreference.toDouble();
                  agePreferenceList = state.profile.user.agePreference;
                  isInit = false;
                }
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          backgroundImage: CachedNetworkImageProvider(mUser.profileUrl),),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            state.user.name + ', ' + state.user.age.toString()
                            , style: TextStyle(color: Colors.white, fontSize: 20),),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: screenHeight / 6,
                                    color: lightBlack,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Membership',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16
                                            ),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('12 Months',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12
                                            ),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: screenHeight / 6,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  16, 0, 8, 0),
                                              child: Container(
                                                child: Image.asset(
                                                    'assets/images/coin.png'),
                                              ),
                                            )),
                                        Flexible(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(0, 8, 0, 8),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text('Total Coins',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                      ),),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      8.0),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      state.user.coins.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,),),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          indicatorColor: themeButtonColor,
                          indicatorWeight: 10,
                          labelPadding: EdgeInsets.symmetric(horizontal: 30),
                          tabs: [
                            Container(
                              child: Text(
                                'About',
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                            Container(
                              width: 75.0,
                              child: Text(
                                'Gallery',
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                            Container(
                              child: Text(
                                'Setting',
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 1500,
                          child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20,),
                                    titleText('Email'),
                                    valueTextEmail(state.user.email),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(24,16,8,0),
                                      child: Text('Password',style: TextStyle(color: Colors.grey,fontSize: 18),),
                                    ),
                                    passwordField(state.user.password),
                                    titleValue('Name',state.user.name),
                                    titleValue('Date of Birth',state.user.birthDate.toString().substring(0,10)),
                                    titleValue('Phone',state.user.mobile),
                                    titleValue('Gender',state.user.gender),
                                    titleValue('Orientation',state.user.orientation),
                                    titleValue('Preference',state.user.preference),
                                    titleValue('Description',state.user.description),
                                    titleValue('Interests',getInterestString(state.interests)),
                                    Container(),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8,8,8,8),
                                          child: Text('Photos',
                                            style: TextStyle(color: Colors.grey,fontSize: 18),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8,8,16,8),
                                          child: TextButton(
                                            onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (
                                                  context) =>
                                                  EditProfilePage(
                                                    title: 'Photos',
                                                    mUid: mUser.id,
                                                    mUser: mUser,
                                                    mInterests: mInterests,
                                                    mPhotos: mPhotos,
                                                    mVideo: null,
                                                  )));

                                            },
                                            child: Text('Add More',
                                              style: TextStyle(color: Colors.grey,fontSize: 18),),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:screenWidth/2,
                                      width:screenWidth,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        controller: ScrollController(),
                                        itemCount: state.photos.length,
                                        itemBuilder:(BuildContext context,index){
                                          return Container(
                                            height:screenWidth/2,
                                            width:screenWidth/2 ,
                                            child: CachedNetworkImage(
                                              imageUrl: state.photos[index].url,
                                              fit:BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) {
                                                return Image.asset(
                                                    "assets/images/sathi_icon.png");
                                              },
                                            ),
                                          );
                                        }
                                      )


                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8,8,8,8),
                                          child: Text('Videos',
                                            style: TextStyle(color: Colors.grey,fontSize: 18),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8,8,16,8),
                                          child: TextButton(
                                            onPressed: () async{
                                              await selectVideo();
                                              if(mVideo!=null){
                                                Navigator.push(context, MaterialPageRoute(builder: (
                                                    context) =>
                                                    EditProfilePage(
                                                      title: 'Videos',
                                                      mUid: mUser.id,
                                                      mUser: mUser,
                                                      mInterests: mInterests,
                                                      mPhotos: mPhotos,
                                                      mVideo: mVideo,
                                                    )));
                                              }
                                            },
                                            child: Text('Add More',
                                              style: TextStyle(color: Colors.grey,fontSize: 18),),
                                          ),

                                        ),
                                      ],
                                    ),
                                    BlocBuilder<ProfileVideoBloc,ProfileVideoState>(
                                      builder: (context,state) {
                                        if(state is LoadedProfileVideoState){
                                          return SizedBox(
                                              height:screenWidth/2,
                                              width:screenWidth,
                                              child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  controller: ScrollController(),
                                                  itemCount: state.profileVideos.length,
                                                  itemBuilder:(BuildContext context,index){
                                                    return GestureDetector(
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                            PortraitLandscapePlayerWidget( mVideo:state.profileVideos[index].url)));
                                                      },
                                                      child: Stack(
                                                        alignment:Alignment.center,
                                                        children: [
                                                          Container(
                                                            height:screenWidth/2,
                                                            width:screenWidth/2 ,
                                                            child:Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: CachedNetworkImage(
                                                                imageUrl: state.profileVideos[index].thumbnail,
                                                                fit:BoxFit.cover,
                                                                errorWidget:
                                                                    (context, url, error) {
                                                                  return Image.asset(
                                                                      "assets/images/sathi_icon.png");
                                                                },
                                                              ),)
                                                            ),
                                                          CircleAvatar(
                                                            backgroundColor: themeButtonColor,
                                                            radius:36,
                                                              child: Icon(Icons.play_arrow,color: Colors.white,size: 36,))
                                                        ],
                                                      ),
                                                    );

                                                  }
                                              )
                                          );
                                        }else{
                                          return Container();
                                        }

                                      }
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Color(0xFF2E3239),
                                    child: Column(
                                      children: [
                                        BlocBuilder<HomeBloc,HomeState>(
                                          builder: (context,state) {
                                            if(state is LoadedHomeState){
                                              profiles = state.profiles;
                                              profileData = state.profileData;
                                            }
                                            else if(state is LoadedHomeGridState){
                                              profiles = state.profiles;
                                              profileData = state.profileData;
                                            }
                                            else if(state is LoadedHomeRadarState){
                                              profiles = state.profiles;
                                              profileData = state.profileData;
                                            }
                                            return BlocBuilder<ViewBloc,ViewState>(
                                              builder: (context,state) {
                                                isPressedSwipeView = state.view =='swipe'?true:false;
                                                isPressedGridView  = state.view =='grid'?true:false;
                                                isPressedRadarView = state.view =='radar'?true:false;
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      color: Colors.black,
                                                      height: 20,),
                                                    SizedBox(height:60),
                                                    GestureDetector(
                                                    onTap:(){
                                                            if(state.view!='swipe'){
                                                              context.read<ViewBloc>().add(ChangeViewEvent(view: 'swipe'));
                                                              context.read<HomeBloc>().add(ChangeToSwipeViewEvent(
                                                                  profiles: profiles,profileData:profileData));
                                                            }

                                                        },
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(8,8,8,8),
                                                        child: Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            AnimatedContainer(
                                                              duration: const Duration(milliseconds: 100),
                                                              child: Container(
                                                                width: screenWidth/2,
                                                                height: screenWidth/2,
                                                                decoration: customBoxShadow.BoxDecoration(
                                                                  color: Color(0xFF2E3239),
                                                                  borderRadius: BorderRadius.circular(25),
                                                                  gradient: LinearGradient(
                                                                    begin: Alignment.topLeft,
                                                                    end: Alignment.bottomRight,
                                                                    colors: [
                                                                      Color(0xFF2E3239),
                                                                      Color(0xFF2E3239),
                                                                    ],
                                                                  ),
                                                                  boxShadow: [
                                                                    customBoxShadow.BoxShadow(
                                                                      color: Color(0xff515151),
                                                                      //color: Color(0xFF35393F),
                                                                      offset: -distance,
                                                                      blurRadius: blur,
                                                                      spreadRadius: 0.0,
                                                                      inset:isPressedSwipeView,
                                                                    ),
                                                                  customBoxShadow.BoxShadow(
                                                                      color: Color(0xff151515),
                                                                      //color: Color(0xFF23262A),
                                                                      offset: distance,
                                                                      blurRadius:blur,
                                                                      spreadRadius: 0.0,
                                                                      inset:isPressedSwipeView,
                                                                    ),
                                                                  ]
                                                                ),

                                                              ),
                                                            ),
                                                            AnimatedContainer(
                                                              duration: const Duration(milliseconds: 100),
                                                              width: screenWidth/3,
                                                              height: screenWidth/3,
                                                              child:ColorFiltered(
                                                                colorFilter:isPressedSwipeView ?
                                                                ColorFilter.mode(
                                                                    Colors.transparent,BlendMode.plus,
                                                                )
                                                                    :
                                                                ColorFilter.mode(
                                                                    Colors.grey,BlendMode.modulate
                                                                ),
                                                                child: Image.asset(
                                                                  'assets/images/0_swipe_view.png',),
                                                              )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    if(state.view=='swipe')
                                                    Text('Swipeview Active',style: TextStyle(color: Colors.white),),
                                                    SizedBox(height:60),
                                                    GestureDetector(
                                                        onTap:(){
                                                          if(state.view!='grid'){
                                                            context.read<ViewBloc>().add(ChangeViewEvent(view: 'grid'));
                                                            context.read<HomeBloc>().add(
                                                                ChangeToGridViewEvent(
                                                                    profiles: profiles,profileData: profileData));
                                                          }else{
                                                            context.read<ViewBloc>().add(ChangeViewEvent(view: 'swipe'));
                                                          }
                                                        },
                                                        child: Padding(
                                                              padding: const EdgeInsets.fromLTRB(8,8,8,8),
                                                              child: Stack(
                                                                alignment: Alignment.center,
                                                                children: [
                                                                  AnimatedContainer(
                                                                    duration: const Duration(milliseconds: 100),
                                                                    child: Container(
                                                                      width: screenWidth/2,
                                                                      height: screenWidth/2,
                                                                      decoration: customBoxShadow.BoxDecoration(
                                                                          color: Color(0xFF2E3239),
                                                                          borderRadius: BorderRadius.circular(25),
                                                                          gradient: LinearGradient(
                                                                            begin: Alignment.topLeft,
                                                                            end: Alignment.bottomRight,
                                                                            colors: [
                                                                              Color(0xFF2E3239),
                                                                              Color(0xFF2E3239),
                                                                            ],
                                                                          ),
                                                                          boxShadow: [
                                                                            customBoxShadow.BoxShadow(
                                                                              color: Color(0xff515151),
                                                                              //color: Color(0xFF35393F),
                                                                              offset: -distance,
                                                                              blurRadius: blur,
                                                                              spreadRadius: 0.0,
                                                                              inset:isPressedGridView,
                                                                            ),
                                                                            customBoxShadow.BoxShadow(
                                                                              color: Color(0xff151515),
                                                                              //color: Color(0xFF23262A),
                                                                              offset: distance,
                                                                              blurRadius:blur,
                                                                              spreadRadius: 0.0,
                                                                              inset:isPressedGridView,
                                                                            ),
                                                                          ]
                                                                      ),

                                                                    ),
                                                                  ),
                                                                  AnimatedContainer(
                                                                      duration: const Duration(milliseconds: 100),
                                                                      width: screenWidth/3,
                                                                      height: screenWidth/3,
                                                                      child:ColorFiltered(
                                                                        colorFilter:isPressedGridView ?
                                                                        ColorFilter.mode(
                                                                          Colors.transparent,BlendMode.plus,
                                                                        )
                                                                            :
                                                                        ColorFilter.mode(
                                                                            Colors.grey,BlendMode.modulate
                                                                        ),
                                                                        child: Image.asset(
                                                                          'assets/images/1_grid_view.png',),
                                                                      )
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                      ),
                                                    if(state.view=='grid')
                                                    Text('Gridview Active',style: TextStyle(color: Colors.white),),
                                                    SizedBox(height:60),
                                                    GestureDetector(
                                                      onTap:(){
                                                        if(state.view!='radar'){
                                                          context.read<ViewBloc>().add(ChangeViewEvent(view:'radar'));
                                                          context.read<HomeBloc>().add(
                                                              ChangeToRadarViewEvent(
                                                                  profiles: profiles,
                                                                  profileData: profileData,
                                                                  mUser: mUser,
                                                              ));
                                                        }else{
                                                          context.read<ViewBloc>().add(ChangeViewEvent(view:'swipe'));
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(8,8,8,8),
                                                        child: Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            AnimatedContainer(
                                                              duration: const Duration(milliseconds: 100),
                                                              child: Container(
                                                                width: screenWidth/2,
                                                                height: screenWidth/2,
                                                                decoration: customBoxShadow.BoxDecoration(
                                                                    color: Color(0xFF2E3239),
                                                                    borderRadius: BorderRadius.circular(25),
                                                                    gradient: LinearGradient(
                                                                      begin: Alignment.topLeft,
                                                                      end: Alignment.bottomRight,
                                                                      colors: [
                                                                        Color(0xFF2E3239),
                                                                        Color(0xFF2E3239),
                                                                      ],
                                                                    ),
                                                                    boxShadow: [
                                                                      customBoxShadow.BoxShadow(
                                                                        color: Color(0xff515151),
                                                                        //color: Color(0xFF35393F),
                                                                        offset: -distance,
                                                                        blurRadius: blur,
                                                                        spreadRadius: 0.0,
                                                                        inset:isPressedRadarView,
                                                                      ),
                                                                      customBoxShadow.BoxShadow(
                                                                        color: Color(0xff151515),
                                                                        //color: Color(0xFF23262A),
                                                                        offset: distance,
                                                                        blurRadius:blur,
                                                                        spreadRadius: 0.0,
                                                                        inset:isPressedRadarView,
                                                                      ),
                                                                    ]
                                                                ),

                                                              ),
                                                            ),
                                                            AnimatedContainer(
                                                                duration: const Duration(milliseconds: 100),
                                                                width: screenWidth/3,
                                                                height: screenWidth/3,
                                                                child:ColorFiltered(
                                                                  colorFilter:isPressedRadarView ?
                                                                  ColorFilter.mode(
                                                                    Colors.transparent,BlendMode.plus,
                                                                  )
                                                                      :
                                                                  ColorFilter.mode(
                                                                      Colors.grey,BlendMode.modulate
                                                                  ),
                                                                  child: Image.asset(
                                                                    'assets/images/2_radar_view.png',),
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    if(state.view=='radar')
                                                    Text('Radarview Active',style: TextStyle(color: Colors.white),),
                                                    SizedBox(
                                                      height:100
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          left:16),
                                                      child: Align(
                                                        alignment:Alignment.topLeft,
                                                        child: Text('Distance Preference',style:TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.bold,
                                                        ),),
                                                      ),
                                                    ),
                                                    Container(
                                                      width:screenWidth,
                                                      height:100,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(8,8,32,0),
                                                              child: Align(
                                                                alignment:Alignment.topRight,
                                                                  child: Text((distancePreference.toInt()).toString()+ ' km',
                                                                    style:TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 24,

                                                                    ) ,)),
                                                            ),
                                                            Slider(
                                                             min:30.0, max:200.0, activeColor: Colors.white,
                                                             value:distancePreference,
                                                             onChanged:(value) {
                                                               updateDistance(distancePreference.toInt());
                                                               this.setState(() {distancePreference = value;});},),
                                                          ],
                                                        )),
                                                    SizedBox(
                                                        height:60
                                                    ),
                                                    Align(
                                                      alignment:Alignment.topLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left:16),
                                                        child: Text('Age Preference',style:TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.bold,
                                                        ),),
                                                      ),
                                                    ),
                                                    Container(
                                                        width:screenWidth,
                                                        height:100,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(8,8,32,0),
                                                              child: Align(
                                                                  alignment:Alignment.topRight,
                                                                  child: Text((agePreference.toInt()-5).toString()+' - '+agePreference.toInt().toString()+ ' years',
                                                                    style:TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 24,

                                                                    ) ,)),
                                                            ),
                                                            Slider(
                                                              min:18.0, max:100.0, activeColor: Colors.white,
                                                              value:agePreference,
                                                              onChanged:(value) {
                                                                updateAge([agePreference.toInt()-5,agePreference.toInt()]);
                                                                this.setState(() {agePreference = value;});},),
                                                          ],
                                                        )),

                                                  ],
                                                );
                                              }
                                            );
                                          }
                                        ),
                                        SizedBox(height: 40,),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            style:ElevatedButton.styleFrom(
                                              primary:themeButtonColor,
                                              onPrimary: Colors.white,
                                              minimumSize: const Size(double.infinity,50),
                                            ),
                                            child: Text('Logout',), onPressed: () {
                                            context.read<AuthenticationBloc>().add(
                                                LogoutEvent(uid: state.userId,));
                                          },),
                                        ),
                                      ],
                                    )
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                );
              }
              else {
                return Container();
              }
            }
           )
        );
      }

  Widget passwordField(String password){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(24,0,0,0),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 5,
                child: TextFormField(
                  initialValue: password,
                  enabled: false,
                  obscureText: _secureText,
                  style:const TextStyle(color:Colors.white,fontSize:18),
                  //maxLength: 30,
                  //textInputAction: TextInputAction.next,
                ),
              ),
              Flexible(
                flex: 1,
                child: TextFormField(
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon:Icon(_secureText?Icons.security:Icons.remove_red_eye,color:Colors.white,size:20),
                        onPressed:(){
                          setState(() {
                            _secureText =!_secureText;
                          });
                        },),
                      errorStyle: const TextStyle(color: Colors.white)
                  ),
                  style:const TextStyle(color:Colors.white,fontSize:18),
                  //maxLength: 30,

                  //textInputAction: TextInputAction.next,
                ),
              ),
              Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) =>
                          EditProfilePage(
                            title: 'ChangePassword',
                            mUid: mUser.id,
                            mUser: mUser,
                            mInterests: mInterests,
                            mPhotos: mPhotos,
                            mVideo: null,
                          )));
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(left:16),
                        child: Container(child: FaIcon(FontAwesomeIcons.solidPenToSquare,color: Colors.grey))
                    ),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top:0.0),
            child: Divider(color: Colors.grey,),
          ),
        ],
      ),
    );

  }
  Widget valueTextEmail(String value,){
    return Padding(
      padding: const EdgeInsets.fromLTRB(24,0,8,16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 5,
                child: Text(
                  value=='default'?'':value,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white,fontSize: 18),),
              ),
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container()
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Divider(color: Colors.grey,),
          ),
        ],
      ),
    );
  }
  Widget titleText(String title){
    return Padding(
      padding: const EdgeInsets.fromLTRB(24,16,8,8),
      child: Text(title,style: TextStyle(color: Colors.grey,fontSize: 18),),
    );
  }
  Widget titleValue (String title, String value ){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24,16,8,8),
          child: Text(title,style: TextStyle(color: Colors.grey,fontSize: 18),),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24,0,8,16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 5,
                    child: Text(
                      value=='default'?'':value,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white,fontSize: 18),),
                  ),
                  Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (
                                context) =>
                                EditProfilePage(
                                  title: title,
                                  mUid: mUser.id,
                                  mUser: mUser,
                                  mInterests: mInterests,
                                  mPhotos: mPhotos,
                                  mVideo: null,
                                )));
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Container(child: FaIcon(FontAwesomeIcons.solidPenToSquare,color: Colors.grey))
                        ),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Divider(color: Colors.grey,),
              ),
            ],
          ),
        )
      ],
    );

  }
  String getInterestString(List<InterestModel>interests){
    String interestString ='';
    for (int i=0;i<interests.length;i++){
      interestString = interestString + interests[i].interest+', ';
    }
   return interestString;

  }
  Future  selectVideo () async{
    final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery,);
    if(pickedVideo==null) return null;
    setState(() =>mVideo = File(pickedVideo.path));
  }
  Future<bool>updateDistance(int distancePreference)async{
    bool updated = false;
    try{
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userId);
      await docUser.update({
        'p_distancePreference':distancePreference,
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future<bool>updateAge(List<dynamic> agePreferenceList)async{
    bool updated = false;
    try{
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userId);
      await docUser.update({
        'q_agePreference':agePreferenceList,
      });
      updated = true;

    }catch(e){
      print(e);
      updated = false;
    }
    return updated;
  }


  }


