import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sathiclub/authentication/common/defaultUserModel.dart';

import '../../constants/themeColors.dart';
import '../bloc/authentication_bloc.dart';
import '../models/UserModel.dart';

class GenderPage extends StatefulWidget {
  final String mUid ;
  final UserModel mUser;
  final bool fromSignup;
  const GenderPage({Key? key, required this.mUid,required this.mUser,required this.fromSignup}) : super(key: key);
  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  int selectedValueRadio = 1;
  String _gender ='Male';
  bool _isSaving = false;
  @override void initState() {
    if(widget.mUser.gender!='default'){
      if(widget.mUser.gender=='Male'){ selectedValueRadio=1;_gender='Male';}
      else if(widget.mUser.gender=='Female'){ selectedValueRadio=0;_gender='Female';}
      else if(widget.mUser.gender=='Other'){ selectedValueRadio=2;_gender='Other';}
      else if(widget.mUser.gender=='Undisclosed'){ selectedValueRadio=3;_gender='Undisclosed';}
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return genderPage();
  }
  Widget genderPage(){
    return SingleChildScrollView(
      child: Column(
        children:  [
          if(widget.fromSignup)
          const SizedBox(height: 40,),
          if(widget.fromSignup)
          Align(
              alignment: Alignment.centerLeft,
              child: backButtonGender()),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 54,
              width: 104,
              decoration:const BoxDecoration(
                image:DecorationImage(image: AssetImage('assets/images/sathi_icon_white.png'),
                  fit:BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Select your Gender ',
              style:TextStyle (
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Your Gender will be public',
              style:TextStyle (
                  fontSize: 18,
                  color: themeColorSubtitle),),
          ),
          genderField(),
          const SizedBox(
            height: 20,
          ),
          continueButtonGender(),
        ],
      ),
    );
  }
  Widget backButtonGender(){
    return IconButton(
      icon:const Icon(Icons.arrow_back,color:themeColorSubtitle),
      onPressed: (){
        context.read<AuthenticationBloc>().add(BackFromGenderStateEvent(uid:widget.mUid,));
      },
    );

  }
  Widget genderField(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16,8,16,8),
          child: Row(
            children: [
              Radio<int>(
                  value: 1,
                  groupValue: selectedValueRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  activeColor:themeButtonColor,
                  onChanged:(value)=>setState(() {
                    selectedValueRadio=1; _gender='Male';

                  })
              ),
              GestureDetector(
                onTap:(){
                  setState(() {selectedValueRadio=1; _gender='Male';});
                },
                child: Text("Male",style: TextStyle(fontSize: 22,
                  color:selectedValueRadio==1?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16,8,16,8),
          child: Row(
            children: [
              Radio<int>(
                  value: 0,
                  groupValue: selectedValueRadio,
                  activeColor:themeButtonColor,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadio=0; _gender='Female';
                  })),
              GestureDetector(
                onTap:(){setState(() {selectedValueRadio=0; _gender='Female'; });},
                child: Text("Female",style: TextStyle(fontSize: 22,
                  color:selectedValueRadio==0?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16,8,16,8),
          child: Row(
            children: [
              Radio<int>(
                  value: 2,
                  groupValue: selectedValueRadio,
                  activeColor:themeButtonColor,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadio=2; _gender='Other';
                  })),
              GestureDetector(
                onTap: (){
                  setState(() {selectedValueRadio=2; _gender='Other'; });},
                child: Text("Other",style: TextStyle(fontSize: 22,
                  color:selectedValueRadio==2?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding:const EdgeInsets.fromLTRB(16,8,16,8),
          child: Row(
            children: [
              Radio<int>(
                  value: 3,
                  groupValue: selectedValueRadio,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadio=3; _gender='Undisclosed';
                  })),
              GestureDetector(
                onTap: (){
                  setState(() {selectedValueRadio=3; _gender='Undisclosed';});
                },
                child: Text("Undisclosed",style: TextStyle(fontSize: 22,
                  color:selectedValueRadio==3?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
      ],
    );

  }
  Widget continueButtonGender(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocBuilder<AuthenticationBloc,AuthenticationState>(
        builder: (context,state) {
          if(state is AuthenticatedState){
            return Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    primary:  _isSaving?themeButtonColor.withOpacity(.5):themeButtonColor,
                    onPrimary: Colors.white,
                    minimumSize: const Size(double.infinity,50),
                  ),
                  child:Text(_isSaving?'Saving':'Save',style: TextStyle(fontSize: 18),),
                  onPressed:(){
                    if(!_isSaving){
                      setState(() {_isSaving = true;});
                      context.read<AuthenticationBloc>().add(ChangeUserInfoEvent(
                          uid: widget.mUid,
                          title: 'Gender',
                          value: _gender,
                          context: context,
                          interests: state.interests,
                          photos: state.photos));
                    }
                  }
              ),
            );
          }
          return Container(
            alignment: Alignment.center,
            child: ElevatedButton(
                style:ElevatedButton.styleFrom(
                  primary: themeButtonColor,
                  onPrimary: Colors.white,
                  minimumSize: const Size(double.infinity,50),
                ),
                child:const Text('Next',style: TextStyle(fontSize: 18),),
                onPressed:(){
                  context.read<AuthenticationBloc>().add(UpdateInfoGenderEvent(uid:widget.mUid,gender:_gender));
                }

            ),
          );
        }
      ),
    );

  }
}
