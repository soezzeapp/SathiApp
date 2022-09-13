import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/themeColors.dart';
import '../bloc/authentication_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKeySignIn = GlobalKey<FormState>();
  String _email = '';
  String _password ='';
  bool _secureText = true;
  bool isLoadingSignIn = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc,AuthenticationState>(
        listener: (context,state){
          if(state is LogInState){
             if(state.isLoading==true){
              isLoadingSignIn = true;
              }else{
              setState(() { isLoadingSignIn = false;});
              }
            }
          },
        builder: (context,state) {
        return signInPage();
      }
    );
  }


  Widget backButtonSignIn(){
    return IconButton(
      icon:Icon(Icons.arrow_back_outlined,color:themeColorSubtitle),
      onPressed: (){
        context.read<AuthenticationBloc>().add(BackFromLoginEvent());
      },
    );

  }
  Widget signInPage(){
    return Form(
      key:_formKeySignIn,
      child: SingleChildScrollView(
        child: Column(
          children:  [
            const SizedBox(height: 40,),
            Align(
                alignment: Alignment.centerLeft,
                child: backButtonSignIn()),
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('',
                style:TextStyle (
                    fontSize: 18,
                    color: Colors.grey),),
            ),
            const SizedBox(
              height: 60,
            ),
            emailField(),
            const SizedBox(
              height: 50,
            ),
            passwordField(),
            const SizedBox(
              height: 50,
            ),
            continueButtonSignIn(),
          ],
        ),
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
  Widget continueButtonSignIn(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
            style:ElevatedButton.styleFrom(
              primary: isLoadingSignIn?themeButtonColor.withOpacity(.5): themeButtonColor,
              onPrimary: Colors.white,
              minimumSize: const Size(double.infinity,50),
            ),
            child:Text(isLoadingSignIn?'PROCESSING...':'Sign In',style: const TextStyle(fontSize: 18),),
            onPressed:(){
              final isValid = _formKeySignIn.currentState!.validate();
              if(isValid){_formKeySignIn.currentState!.save();
              if(!isLoadingSignIn){
                setState(() {
                  isLoadingSignIn = true;
                });
                context.read<AuthenticationBloc>().add(LoginEvent(
                    email: _email,password: _password,context:context ));
              }


              }

            }
        ),
      ),
    );

  }
}
