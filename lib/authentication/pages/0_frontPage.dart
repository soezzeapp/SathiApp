
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sathiclub/authentication/common/defaultUserModel.dart';
import 'package:sathiclub/common/widgets/ShowSnackBar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/themeColors.dart';

import '../../home/pages/HomePage.dart';
import '../../route/RoutePage.dart';
import '../bloc/authentication_bloc.dart';
import '../models/UserModel.dart';
import '../repository/firebaseAuthApi.dart';
import '10_location_page.dart';
import '11_welcome_page.dart';
import '12_signup_page.dart';
import '../repository/firebaseApi.dart';
import '../../constants/constants.dart';
import '1_login_page.dart';
import '2_terms_page.dart';
import '3_name_page.dart';
import '4_dob_page.dart';
import '5_gender_page.dart';
import '6_orientation_page.dart';
import '7_show_page.dart';
import '8_passion_page.dart';
import '9_photo_page.dart';

class MyFrontPage extends StatefulWidget {
  const MyFrontPage({Key? key,}) : super(key: key);
  @override
  State<MyFrontPage> createState() => _MyFrontPageState();
}

class _MyFrontPageState extends State<MyFrontPage> {
  bool backGroundDeActivated = false;
  String mUid = '';
  UserModel mUser = DefaultUser.defaultUser;
  final coupleImages=[
    'assets/images/a_couple_one.png',
    'assets/images/b_couple_two.png',
    'assets/images/c_couple_three.png',
  ];
  final coupleTitles=[
    'Find Perfect Match',
    'Find Your Love',
    'Find your Someone',
  ];

  final coupleSubTitles=[
    'Next to share your heart with people even if it has been broken.',
    'To love is to recognize yourself in another.',
    'There is always some madness in love. But there is also always some reason in madness.',
  ];
  int activeIndex = 0;
  TextEditingController _textEditingControllerFront = TextEditingController();

  @override void initState() {
    backGroundDeActivated = false;
    _textEditingControllerFront.text = coupleSubTitles[0];
    super.initState();
  }

  @override
  void dispose() {
    _textEditingControllerFront.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration:const BoxDecoration(
            image:DecorationImage(image: AssetImage('assets/images/0_backgroundimage.jpg'),
              fit:BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor:Colors.black,
          body:BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context,state){
            }    ,
            builder: (context, state){
              if(state is InitialAuthenticationState || state is SignUpState){
              return frontPage();
              }
              else if(state is InfoWelcomeAndTermsState){
                return TermsPage(mUid: state.userId,mUser: state.user);
              }
              else if(state is InfoNameState){
                return NamePage(mUid:state.userId, mUser: state.user,fromSignup:true,);
              }
              else if(state is InfoBirthDateState){
                return DateOfBirthPage(mUid: state.userId,mUser:state.user,fromSignup: true,);
              }
              else if(state is InfoGenderState){
                return GenderPage(mUid:state.userId,mUser:state.user,fromSignup: true,);
              }
              else if(state is InfoOrientationState){
                return OrientationPage(mUid:state.userId,mUser:state.user,fromSignup: true,);
              }
              else if(state is InfoPreferenceState){
                return PreferencePage(mUid:state.userId, mUser:state.user,fromSignup: true,);
              }
              else if(state is InfoInterestsState){
                return InterestPage(mUid:state.userId, mUser:state.user,mInterests: state.interests,fromSignup: true,);
              }
              else if (state is InfoPhotoState){
                return PhotoPage(mUid: state.userId,mUser: state.user,mPhotos:state.photos,fromSignup: true,);
              }
              else if (state is InfoLocationState){
                return LocationPage(mUid:state.userId,mUser:state.user);
              }
              else if (state is InfoDescriptionState){
                return CongratulationPage(mUid:state.userId,mUser:state.user,fromSignup: true,);
              }
              else if (state is LogInState){
                return LoginPage();
              }
              else{ return frontPage();}
              },
          ),
        ),
      ],
    );
  }

  Widget frontPage(){
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                height: 54,
                width: 104,
                decoration:const BoxDecoration(
                  image:DecorationImage(image: AssetImage('assets/images/sathi_icon.png'),
                    fit:BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36,36,36,0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 280,
                  height: 280,
                  child: PageView(
                      onPageChanged: (index){
                       setState(() {
                         _textEditingControllerFront.text=coupleSubTitles[index];
                         activeIndex = index;});},
                      children:[
                        Container(
                          width: 280,
                          height: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/a_couple_one.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                        ),
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/b_couple_two.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),

                        ),
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/c_couple_three.jpg'),
                              fit: BoxFit.cover,

                            ),
                          ),
                        ),
                      ]
                  ),
                ),
              ),
            ),
            buildIndicator(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8,8,8,0),
              child: Text(
                coupleTitles[activeIndex],
                style: const TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16,0,16,0),
              child: TextFormField(
                controller: _textEditingControllerFront,
                enabled: false,
                minLines: 2,
                maxLines:null,
                style: const TextStyle(color: Colors.grey,),),
            ),
            //const SizedBox(height: 100,),
            createAccountButton(),
           // signInButton(),
            Padding(
              padding: const EdgeInsets.fromLTRB(40,8,40,16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Text(
                    'Already have an account ?',
                    style: TextStyle(
                      fontSize:14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  signInButtonTwo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
  Widget createAccountButton(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
            style:ElevatedButton.styleFrom(
              primary: themeButtonColor,
              onPrimary: Colors.white,
              minimumSize: const Size(double.infinity,50),
            ),
            child:const Text('Create Account',style: TextStyle(fontSize: 18),),
            onPressed:(){
              context.read<AuthenticationBloc>().add(InitiateRegisterEvent());
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
            }
        ),
      ),
    );

  }
  Widget buildIndicator(){
    return Padding(
      padding: const EdgeInsets.only(top:24),
      child: AnimatedSmoothIndicator(
        activeIndex: activeIndex ,
        count:coupleImages.length,
        effect: const WormEffect(
          activeDotColor:themeButtonColor,
        ),
      ),
    );

  }
  Widget signInButton(){
    return Padding(padding: const EdgeInsets.all(16.0),
      child: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
          style:ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.black,
            minimumSize: const Size(double.infinity,50),
          ),
          child:const Text('SIGN IN',style: TextStyle(fontSize: 18,color: Colors.deepOrange),),
          onPressed:(){
            context.read<AuthenticationBloc>().add(InitiateLoginEvent());
          },
        ),
      ),
    );

  }
  Widget signInButtonTwo(){
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
       child:const Text( 'Sign In ?',style: TextStyle(
           fontSize:14,
           fontWeight: FontWeight.bold,
           color: themeButtonColor
       ),),
        onPressed: (){context.read<AuthenticationBloc>().add(InitiateLoginEvent());},

      ),
    );
  }

}