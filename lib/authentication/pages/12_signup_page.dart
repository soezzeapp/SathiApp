import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sathiclub/authentication/bloc/authentication_bloc.dart';
import 'package:sathiclub/constants/themeColors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey= GlobalKey<FormState>();
  String _email ='';
  String _password='';
  bool _secureText = true;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined,color:Colors.white),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context,state){
            if(state is  SignUpState){
              if(state.isLoading==true){
                _isLoading = true;
              }else{
                _isLoading = false;
              }
            }
            else if(state is  InfoWelcomeAndTermsState){
              Navigator.of(context).pop();
            }
          },
        builder: (context, state){
          if(state is SignUpState){
            return  Form(
              key:_formKey,
              child: SingleChildScrollView(
                child: Column(
                  children:  [
                    const SizedBox(
                      height: 10,
                    ),
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
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Create an account',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                          ),),
                      ),
                    ),
                    emailField(),
                    const SizedBox(
                      height: 40,
                    ),
                    passwordField(),
                    const SizedBox(
                      height: 40,
                    ),
                    continueButton(),
                    const Padding(
                      padding: EdgeInsets.only(top:16,bottom: 4),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('By Signing up you agree with our',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('terms & condition of use',
                          style: TextStyle(
                            color: themeButtonColor,
                            fontSize: 16,
                          ),),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else {return Container();}

        }

      ),
    );
  }
  Widget emailField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child:TextFormField(
          decoration:const InputDecoration(
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
              hintText:'Email',
              hintStyle: TextStyle(fontSize:22,color: Colors.grey,),
              prefixIcon:Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(FontAwesomeIcons.solidEnvelope,color:Colors.white,size:30),
              ),
              errorStyle: TextStyle(color: Colors.white)
          ),
          style:const TextStyle(color:Colors.white),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator:(value){
            const pattern =r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
            final regExp=RegExp(pattern);
            if(!regExp.hasMatch(value!)){return '      Enter a Valid Email';}
            if(value.length<3){return '      Enter at least 3 characters';} else{return null;}},
          onSaved:(value)=>setState(()=>_email=value!),

        ),
      ),
    );

  }
  Widget passwordField(){
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child:TextFormField(
          decoration: InputDecoration(
              contentPadding:const EdgeInsets.symmetric(vertical:18) ,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius:  BorderRadius.all(Radius.circular(24.0)),
                borderSide: BorderSide(
                  color: Colors.grey, width: 1.0,),
              ),
              focusedErrorBorder:const OutlineInputBorder(
                borderRadius:  BorderRadius.all(Radius.circular(24.0)),
                borderSide: BorderSide(
                  color: Colors.white, width: 1.0,),
              ),
              hintText:'Password',
              hintStyle: const TextStyle(fontSize:22,color: Colors.grey,),
              prefixIcon:const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(FontAwesomeIcons.lock,color:Colors.white,size:30),
              ),
              suffixIcon: Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  icon:Icon(_secureText?Icons.security:Icons.remove_red_eye,color:Colors.white,size:30),
                  onPressed:(){
                    setState(() {
                      _secureText =!_secureText;
                    });
                  },),

              ),
              errorStyle: const TextStyle(color: Colors.white)
          ),
          obscureText: _secureText,
          style:const TextStyle(color:Colors.white),
          //maxLength: 30,
          onSaved:(value)=>setState(()=>_password=value!),
          validator:(value){if(value!.length<7){return '      Enter at least 7 characters';}
          else if(value.length>30){return '      Enter below 30 characters';} else{return null;}
          },
          //textInputAction: TextInputAction.next,
        ),
      ),
    );

  }
  Widget continueButton(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
            style:ElevatedButton.styleFrom(
              primary: _isLoading?themeButtonColor.withOpacity(.5):themeButtonColor,
              onPrimary: Colors.white,
              minimumSize: const Size(double.infinity,50),
            ),
            child:Text(_isLoading?'PROCESSING...':'CONTINUE',style: const TextStyle(fontSize: 18),),
            onPressed:(){
              final isValid = _formKey.currentState!.validate();
              if(isValid){_formKey.currentState!.save();
              if(!_isLoading){
                setState(() {_isLoading = true;});
                context.read<AuthenticationBloc>().add(
                    RegisterEvent(emailId: _email,password: _password,context: context));
                }
              }
            }
        ),
      ),
    );

  }
}
