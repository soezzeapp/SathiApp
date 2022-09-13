import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/themeColors.dart';
import '../bloc/authentication_bloc.dart';
import '../models/UserModel.dart';

class OrientationPage extends StatefulWidget {
  final String mUid ;
  final UserModel mUser;
  final bool fromSignup;
  const OrientationPage({Key? key,required this.mUid, required this.mUser,required this.fromSignup}) : super(key: key);

  @override
  _OrientationPageState createState() => _OrientationPageState();
}

class _OrientationPageState extends State<OrientationPage> {
  String _orientation  ='Straight';
  int selectedValueRadioOrientation = 0;
  bool _isSaving = false;

  @override void initState() {
    super.initState();
     if(widget.mUser.orientation!='default'){
       if(widget.mUser.orientation=='Straight'){selectedValueRadioOrientation=0;_orientation='Straight';}
       else if(widget.mUser.orientation=='Gay'){selectedValueRadioOrientation=1;_orientation='Gay';}
       else if(widget.mUser.orientation=='Lesbian'){selectedValueRadioOrientation=2;_orientation='Lesbian';}
       else if(widget.mUser.orientation=='Bisexual'){selectedValueRadioOrientation=3;_orientation='Bisexual';}
       else if(widget.mUser.orientation=='Asexual'){selectedValueRadioOrientation=4;_orientation='Asexual';}
       else if(widget.mUser.orientation=='Demisexual'){selectedValueRadioOrientation=5;_orientation='Demisexual';}
       else if(widget.mUser.orientation=='Pansexual'){selectedValueRadioOrientation=6;_orientation='Pansexual';}
       else if(widget.mUser.orientation=='Queer'){selectedValueRadioOrientation=7;_orientation='Queer';}
       else if(widget.mUser.orientation=='Questioning'){selectedValueRadioOrientation=1;_orientation='Questioning';}
          }
  }

  @override
  Widget build(BuildContext context) {
    return orientationPage();
  }
  Widget orientationPage(){
    return SingleChildScrollView(
      child: Column(
        children:  [
          if(widget.fromSignup)
          const SizedBox(height: 40,),
          if(widget.fromSignup)
          Align(
              alignment: Alignment.centerLeft,
              child: backButtonOrientation()),
          const SizedBox(height: 20,),
          const Padding(
            padding: EdgeInsets.fromLTRB(8,0,8,8,),
            child: Text('Select your sexual orientation  ',
              style:TextStyle (
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(' Select One',
              style:TextStyle (
                  fontSize: 18,
                  color: themeColorSubtitle),),
          ),
          orientationField(),
          continueButtonOrientation(),
        ],
      ),
    );
  }
  Widget backButtonOrientation(){
    return IconButton(
      icon: Icon(Icons.arrow_back,color:themeColorSubtitle),
      onPressed: (){
        context.read<AuthenticationBloc>().add(BackFromOrientationStateEvent(uid:widget.mUid,user: widget.mUser));
      },
    );

  }
  Widget orientationField(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16,2,16,2),
          child: Row(
            children: [
              Radio<int>(
                  value: 0,
                  groupValue: selectedValueRadioOrientation,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadioOrientation=0; _orientation='Straight';
                  })
              ),
              GestureDetector(
                onTap: ()=>setState(() {
                  selectedValueRadioOrientation=0; _orientation='Straight';
                }),
                child: Text("Straight",style: TextStyle(fontSize: 22,
                  color:selectedValueRadioOrientation==0?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16,2,16,2),
          child: Row(
            children: [
              Radio<int>(
                  value: 1,
                  groupValue: selectedValueRadioOrientation,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadioOrientation=1; _orientation='Gay';
                  })
              ),
              GestureDetector(
                onTap: ()=>setState(() {
                  selectedValueRadioOrientation=1; _orientation='Gay';
                }),
                child: Text("Gay",style: TextStyle(fontSize: 22,
                  color:selectedValueRadioOrientation==1?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16,2,16,2),
          child: Row(
            children: [
              Radio<int>(
                  value: 2,
                  groupValue: selectedValueRadioOrientation,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadioOrientation=2; _orientation='Lesbian';
                  })
              ),
              GestureDetector(
                onTap: ()=>setState(() {
                  selectedValueRadioOrientation=2; _orientation='Lesbian';
                }),
                child: Text("Lesbian",style: TextStyle(fontSize: 22,
                  color:selectedValueRadioOrientation==2?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16,2,16,2),
          child: Row(
            children: [
              Radio<int>(
                  value: 3,
                  groupValue: selectedValueRadioOrientation,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadioOrientation=3; _orientation='Bisexual';
                  })
              ),
              GestureDetector(
                onTap: ()=>setState(() {
                  selectedValueRadioOrientation=3; _orientation='Bisexual';
                }),
                child: Text("Bisexual",style: TextStyle(fontSize: 22,
                  color:selectedValueRadioOrientation==3?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16,2,16,2),
          child: Row(
            children: [
              Radio<int>(
                  value: 4,
                  groupValue: selectedValueRadioOrientation,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadioOrientation=4; _orientation='Asexual';
                  })
              ),
              GestureDetector(
                onTap: ()=>setState(() {
                  selectedValueRadioOrientation=4; _orientation='Asexual';
                }),
                child: Text("Asexual",style: TextStyle(fontSize: 22,
                  color:selectedValueRadioOrientation==4?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16,2,16,2),
          child: Row(
            children: [
              Radio<int>(
                  value: 5,
                  groupValue: selectedValueRadioOrientation,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadioOrientation=5; _orientation='Demisexual';
                  })
              ),
              GestureDetector(
                onTap: ()=>setState(() {
                  selectedValueRadioOrientation=5; _orientation='Demisexual';
                }),
                child: Text("Demisexual",style: TextStyle(fontSize: 22,
                  color:selectedValueRadioOrientation==5?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16,2,16,2),
          child: Row(
            children: [
              Radio<int>(
                  value: 6,
                  groupValue: selectedValueRadioOrientation,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadioOrientation=6; _orientation='Pansexual';
                  })
              ),
              GestureDetector(
                onTap: ()=>setState(() {
                  selectedValueRadioOrientation=6; _orientation='Pansexual';
                }),
                child: Text("Pansexual",style: TextStyle(fontSize: 22,
                  color:selectedValueRadioOrientation==6?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16,2,16,2),
          child: Row(
            children: [
              Radio<int>(
                  value: 7,
                  groupValue: selectedValueRadioOrientation,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadioOrientation=7; _orientation='Queer';
                  })
              ),
              GestureDetector(
                onTap: ()=>setState(() {
                  selectedValueRadioOrientation=7; _orientation='Queer';
                }),
                child: Text("Queer",style: TextStyle(fontSize: 22,
                  color:selectedValueRadioOrientation==7?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16,2,16,2),
          child: Row(
            children: [
              Radio<int>(
                  value: 8,
                  groupValue: selectedValueRadioOrientation,
                  activeColor:themeColorRadio,
                  fillColor: MaterialStateColor.resolveWith((states) => themeButtonColor),
                  onChanged:(value)=>setState(() {
                    selectedValueRadioOrientation=8; _orientation='Questioning';
                  })
              ),
              GestureDetector(
                onTap: ()=>setState(() {
                  selectedValueRadioOrientation=8; _orientation='Questioning';
                }),
                child: Text("Questioning",style: TextStyle(fontSize: 22,
                  color:selectedValueRadioOrientation==8?themeButtonColor:Colors.white,
                )),
              ),
            ],
          ),
        ),

      ],
    );

  }
  Widget continueButtonOrientation(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
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
                          title: 'Orientation',
                          value: _orientation,
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
                    context.read<AuthenticationBloc>().add(UpdateInfoOrientationEvent(uid:widget.mUid,orientation:_orientation));
                  }

              ),
            );
          }

        }
      ),
    );

  }
}
