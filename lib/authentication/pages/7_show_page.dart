import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/themeColors.dart';
import '../bloc/authentication_bloc.dart';
import '../models/UserModel.dart';

class PreferencePage extends StatefulWidget {
  final String mUid;
  final UserModel mUser;
  final bool fromSignup;
  const PreferencePage({Key? key,required this.mUid,required this.mUser,required this.fromSignup}) : super(key: key);

  @override
  _PreferencePageState createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  String _preference='Men';
  int selectedValueRadioPreference= 1;
  bool _isSaving = false;
  @override void initState() {
    super.initState();
    if(widget.mUser.preference!='default'){
       if(widget.mUser.preference=='Men'){selectedValueRadioPreference=1;_preference='Men';}
       else if(widget.mUser.preference=='Women'){selectedValueRadioPreference=0;_preference='Women';}
       else if(widget.mUser.preference=='Everyone'){selectedValueRadioPreference=2;_preference='Everyone';}
              }
  }
  @override
  Widget build(BuildContext context) {
    return preferencePage();
  }


  Widget preferencePage(){
    return SingleChildScrollView(
      child: Column(
        children:  [
          if(widget.fromSignup)
          const SizedBox(height:40,),
          if(widget.fromSignup)
          Align(
              alignment: Alignment.centerLeft,
              child:backButtonPreference()),
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
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Select your preference',
              style:TextStyle (
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('',
              style:TextStyle (
                  fontSize: 18,
                  color: themeColorSubtitle),),
          ),
          const SizedBox(
            height: 20,
          ),
          preferenceField(),
          const SizedBox(
            height: 50,
          ),
          continueButtonPreference(),
        ],
      ),
    );
  }
  Widget backButtonPreference(){
    return IconButton(
      icon:const Icon(Icons.arrow_back,color:themeColorSubtitle),
      onPressed: (){
        context.read<AuthenticationBloc>().add(BackFromPreferenceStateEvent(uid:widget.mUid,user:widget.mUser));
      },
    );

  }
  Widget preferenceField(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<int>(
                  value: 1,
                  groupValue: selectedValueRadioPreference,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadioPreference=1; _preference='Men';
                  })
              ),
              GestureDetector(
                onTap:()=>setState(() {
                  selectedValueRadioPreference=1; _preference='Men';
                }),
                child: Text("Men",style: TextStyle(fontSize: 22,
                  color:selectedValueRadioPreference==1?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<int>(
                  value: 0,
                  groupValue: selectedValueRadioPreference,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadioPreference=0; _preference='Women';
                  })),

              GestureDetector(
                onTap: ()=>setState(() {
                  selectedValueRadioPreference=0; _preference='Women';
                }),
                child: Text("Women",style: TextStyle(fontSize: 22,
                  color:selectedValueRadioPreference==0?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<int>(
                  value: 2,
                  groupValue: selectedValueRadioPreference,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadioPreference=2; _preference='Everyone';
                  })),

              GestureDetector(
                onTap: ()=>setState(() {
                  selectedValueRadioPreference=2; _preference='Everyone';
                }),
                child: Text("Everyone",style: TextStyle(fontSize: 22,
                  color:selectedValueRadioPreference==2?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
      ],
    );

  }
  Widget continueButtonPreference(){
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
                          title: 'Preference',
                          value: _preference,
                          context: context,
                          interests: state.interests,
                          photos: state.photos));
                    }
                  }
              ),
            );
          }else{
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
                    context.read<AuthenticationBloc>().add(UpdateInfoPreferenceEvent(uid:widget.mUid,preference:_preference));
                  }

              ),
            );
          }

        }
      ),
    );

  }
}
