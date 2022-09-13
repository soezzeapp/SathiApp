import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sathiclub/authentication/bloc/authentication_bloc.dart';
import 'package:sathiclub/common/widgets/ShowSnackBar.dart';
import '../../constants/themeColors.dart';
import '../models/UserModel.dart';

class ChangePasswordPage extends StatefulWidget {
  final String mUid;
  final UserModel mUser;
  final bool fromSignup;
  const ChangePasswordPage({Key? key,required this.mUid, required this.mUser,required this.fromSignup}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKeyPassword = GlobalKey<FormState>();
  String _oldPassword ='';
  String _newPassword ='';
  String _confirmNewPassword='';
  bool _isSaving = false;

  @override void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return changePasswordPage();
  }

  Widget changePasswordPage(){
    return Form(
      key:_formKeyPassword,
      child: SingleChildScrollView(
        child: Column(
          children:  [
            if(widget.fromSignup)
              SizedBox(height: 40,),
            if(widget.fromSignup)
              Align(
                  alignment: Alignment.centerLeft,
                  child: backButtonPassword()),
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
            const SizedBox(height: 60,),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Enter your old password and new password ',
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
            oldPasswordField(),
            newPasswordField(),
            confirmNewPasswordField(),
            const SizedBox(
              height: 50,
            ),
            continueButtonPassword(),
          ],
        ),
      ),
    );

  }
  Widget backButtonPassword(){
    return IconButton(
      icon:const Icon(Icons.arrow_back,color:themeColorSubtitle),
      onPressed: (){
        if(widget.fromSignup){
          context.read<AuthenticationBloc>().add(BackFromNameStateEvent(uid:widget.mUid,user: widget.mUser));
        }else{
          Navigator.of(context).pop();
        }
      },
    );

  }
  Widget oldPasswordField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),

        child:TextFormField(
          decoration: const InputDecoration(
            contentPadding:EdgeInsets.symmetric(vertical:18) ,
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
            hintText:'Old Password',
            hintStyle: TextStyle(fontSize:22,color: Colors.grey,),
            prefixIcon:Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(FontAwesomeIcons.pen,color:Colors.white,size:30),
            ),
            errorStyle: TextStyle(color: Colors.white),
          ),
          style:const TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator:(value){
            if(value!.length<3){return '      Enter at least 3 characters';} else{return null;}},
          onSaved:(value)=>setState(()=>_oldPassword=value!),

        ),
      ),
    );
  }
  Widget newPasswordField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),

        child:TextFormField(
          decoration: const InputDecoration(
            contentPadding:EdgeInsets.symmetric(vertical:18) ,
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
            hintText:'New Password',
            hintStyle: TextStyle(fontSize:22,color: Colors.grey,),
            prefixIcon:Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(FontAwesomeIcons.pen,color:Colors.white,size:30),
            ),
            errorStyle: TextStyle(color: Colors.white),
          ),
          style:const TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator:(value){
            if(value!.length<3){return '      Enter at least 3 characters';} else{return null;}},
          onSaved:(value)=>setState(()=>_newPassword=value!),

        ),
      ),
    );
  }
  Widget confirmNewPasswordField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),

        child:TextFormField(
          decoration: const InputDecoration(
            contentPadding:EdgeInsets.symmetric(vertical:18) ,
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
            hintText:'Confirm New',
            hintStyle: TextStyle(fontSize:22,color: Colors.grey,),
            prefixIcon:Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(FontAwesomeIcons.pen,color:Colors.white,size:30),
            ),
            errorStyle: TextStyle(color: Colors.white),
          ),
          style:const TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator:(value){
            if(value!.length<3){return '      Enter at least 3 characters';} else{return null;}},
          onSaved:(value)=>setState(()=>_confirmNewPassword=value!),

        ),
      ),
    );
  }

  Widget continueButtonPassword(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocBuilder<AuthenticationBloc,AuthenticationState>(
          builder: (context,state) {
            if(state is AuthenticatedState){
              return Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style:ElevatedButton.styleFrom(
                      primary: _isSaving?themeButtonColor.withOpacity(.5):themeButtonColor,
                      onPrimary: Colors.white,
                      minimumSize: const Size(double.infinity,50),
                    ),
                    child: Text(_isSaving?'Saving':'Save',style: TextStyle(fontSize: 18),),
                    onPressed:() {
                      final isValid = _formKeyPassword.currentState!.validate();
                      if(isValid){
                        _formKeyPassword.currentState!.save();
                        if(!widget.fromSignup){
                          if(!_isSaving){
                            setState(() {_isSaving = true;});
                            if(_oldPassword==widget.mUser.password){
                              if(_newPassword==_confirmNewPassword){
                                context.read<AuthenticationBloc>()
                                    .add(ChangeUserInfoEvent(
                                  uid:widget.mUid,
                                  title: 'ChangePassword',
                                  value: _newPassword,
                                  context: context,
                                  interests: state.interests,
                                  photos: state.photos,
                                ));
                              }else{
                                setState(() {_isSaving = false;});
                                showSnackBar(context: context, content: 'New Password don\'t match');
                              }
                            }else{
                              setState(() {_isSaving = false;});
                              showSnackBar(context: context, content: 'Old Password don\'t match');

                            }

                          }
                        }
                      }
                    }

                ),
              );
            }else {
              return  Container();
            }

          }
      ),
    );

  }
}
