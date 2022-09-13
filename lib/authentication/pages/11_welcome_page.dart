import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/themeColors.dart';
import '../bloc/authentication_bloc.dart';
import '../models/UserModel.dart';

class CongratulationPage extends StatefulWidget {
  final String mUid;
  final UserModel mUser;
  final bool fromSignup;
  const CongratulationPage({Key? key,
    required this.mUid,
    required this.mUser,
    required this.fromSignup}) : super(key: key);

  @override
  _CongratulationPageState createState() => _CongratulationPageState();
}

class _CongratulationPageState extends State<CongratulationPage> {
  final _formKeyDescription = GlobalKey<FormState>();
  String _description = 'default';
  bool _isSaving = false;
  final TextEditingController _controllerDescription = TextEditingController();

  @override void initState() {
    if(widget.mUser.description!='default'){
      _controllerDescription.text = widget.mUser.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return congratulationPage();
  }

  Widget congratulationPage(){
    return SingleChildScrollView(
      child: Form(
        key:_formKeyDescription,
        child: Column(
          children:  [
            if(widget.fromSignup)
            const SizedBox(height: 40,),
            if(widget.fromSignup)
            Align(
                alignment: Alignment.centerLeft,
                child:backButtonCongratulation()),
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
            const SizedBox(height: 40,),
            if(widget.fromSignup)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Congratulations ! \nSign up was successful. ',
                style:TextStyle (
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white),),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: widget.fromSignup?Text('Fill in your short description [Optional]'):
                Text('Fill in your short description',
                style:TextStyle (
                    fontSize: 18,
                    color: themeColorSubtitle),),
            ),
            const SizedBox(
              height: 40,
            ),
            descriptionField(),
            const SizedBox(
              height: 50,
            ),
            letsGetStartedButton(),
          ],
        ),
      ),
    );
  }
  Widget backButtonCongratulation(){
    return IconButton(
      icon:const Icon(Icons.arrow_back,color:themeColorSubtitle),
      onPressed: (){
        context.read<AuthenticationBloc>().add(BackFromInfoDescriptionStateEvent(uid:widget.mUid,user:widget.mUser));
      },
    );

  }
  Widget descriptionField(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration:BoxDecoration(
          color: lightBlack,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextFormField(
          controller: _controllerDescription,
          textAlign: TextAlign.start,
          decoration: const InputDecoration(
            fillColor: Colors.blue,
            contentPadding:EdgeInsets.symmetric(vertical: 80,horizontal: 10),
            hintText:"DESCRIPTION " ,
            hintStyle:TextStyle(color:Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1,),
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1,),
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:  BorderRadius.all(Radius.circular(24.0)),
              borderSide: BorderSide(
                color: Colors.grey, width: 1.0,),
            ),
            focusedErrorBorder:OutlineInputBorder(
              borderRadius:  BorderRadius.all(Radius.circular(24.0)),
              borderSide: BorderSide(
                color: Colors.white, width: 1.0,),
            ),
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style:TextStyle(color:Colors.white),
          onSaved:(value)=>setState(()=>_description=value!),
        ),
      ),
    );
  }
  Widget letsGetStartedButton(){
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
                    final isValid = _formKeyDescription.currentState!.validate();
                    if(isValid) {
                      if (!_isSaving) {
                        _formKeyDescription.currentState!.save();
                        setState(() {_isSaving = true;});
                        context.read<AuthenticationBloc>().add(
                            ChangeUserInfoEvent(
                                uid: widget.mUid,
                                title: 'Description',
                                value: _description,
                                context: context,
                                interests: state.interests,
                                photos: state.photos));
                      }
                    }
                  }
              ),
            );
          }else{
            return Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    primary:themeButtonColor,
                    onPrimary: Colors.white,
                    minimumSize: const Size(double.infinity,50),
                  ),
                  child:const Text('LET\'S GET STARTED',style: TextStyle(fontSize: 18,),),
                  onPressed:(){
                    final isValid = _formKeyDescription.currentState!.validate();
                    if(isValid){
                      _formKeyDescription.currentState!.save();
                      context.read<AuthenticationBloc>().add(UpdateInfoDescriptionStateEvent(uid:widget.mUid,description:_description,context: context));
                    }
                  }
              ),
            );
          }
        }
      ),
    );

  }
}

