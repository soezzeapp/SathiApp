import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:country_picker/country_picker.dart';
import 'package:sathiclub/authentication/bloc/authentication_bloc.dart';
import '../../constants/themeColors.dart';
import '../models/UserModel.dart';

class PhonePage extends StatefulWidget {
  final String mUid;
  final UserModel mUser;
  final bool fromSignup;
  const PhonePage({Key? key,required this.mUid, required this.mUser,required this.fromSignup}) : super(key: key);

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final _formKeyPhone = GlobalKey<FormState>();
  String _phone ='';
  bool _isSaving = false;
  Country?country;
  String code = '+977';
  final TextEditingController _controllerPhone = TextEditingController();

  @override void initState() {
    if(widget.mUser.mobile!='default'){
      List<String> result = widget.mUser.mobile.split('-');
      code = result.first;
      _controllerPhone.text = result.last;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return phonePage();
  }

  Widget phonePage(){
    return Form(
      key:_formKeyPhone,
      child: SingleChildScrollView(
        child: Column(
          children:  [
            if(widget.fromSignup)
              SizedBox(height: 40,),
            if(widget.fromSignup)
              Align(
                  alignment: Alignment.centerLeft,
                  child: backButtonPhone()),
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
              child: Text('Enter your Mobile No. ',
                style:TextStyle (
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white),),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextButton(onPressed: (){ pickCountry();},
                child: const Text('Pick country',style: TextStyle(fontSize: 18,color: themeButtonColor),),)
            ),
            const SizedBox(
              height: 60,
            ),
            phoneField(),
            const SizedBox(
              height: 50,
            ),
            continueButtonPhone(),
          ],
        ),
      ),
    );

  }
  Widget backButtonPhone(){
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
  Widget phoneField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),

        child:Row(
          children: [
            Flexible(
                flex: 1,
                child:
                country==null?
                Text(code,style: TextStyle(color: Colors.white,fontSize: 18),):
                Text('+${country!.phoneCode}',style: TextStyle(color: Colors.white,fontSize: 18),)),
            const SizedBox(width: 10,),
            Flexible(
              flex: 5,
              child: TextFormField(
                controller: _controllerPhone,
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
                  hintText:'Mobile No.',
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
                onSaved:(value)=>setState(()=>_phone=value!),

              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget continueButtonPhone(){
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
                      final isValid = _formKeyPhone.currentState!.validate();
                      if(isValid){
                        _formKeyPhone.currentState!.save();
                        if(!widget.fromSignup){
                          if(!_isSaving){
                            setState(() {_isSaving = true;});
                            String phoneNumber = _controllerPhone.text.trim();
                            if(country!=null){
                             phoneNumber = '+${country!.phoneCode}-$phoneNumber';
                            }else{
                              phoneNumber = '+977-$phoneNumber';
                            }

                            context.read<AuthenticationBloc>()
                                .add(ChangeUserInfoEvent(
                              uid:widget.mUid,
                              title: 'Phone',
                              value:phoneNumber,
                              context: context,
                              interests: state.interests,
                              photos: state.photos,
                            ));
                          }
                        }
                      }
                    }

                ),
              );
            }else {
              return  Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style:ElevatedButton.styleFrom(
                      primary: themeButtonColor,
                      onPrimary: Colors.white,
                      minimumSize: const Size(double.infinity,50),
                    ),
                    child:widget.fromSignup?Text('Next',style: TextStyle(fontSize: 18),):
                    Text('Save',style: TextStyle(fontSize: 18),),
                    onPressed:() {
                      final isValid = _formKeyPhone.currentState!.validate();
                      if(isValid){
                        _formKeyPhone.currentState!.save();
                        if(widget.fromSignup){

                        }
                      }
                    }

                ),
              );
            }

          }
      ),
    );

  }
  void pickCountry(){
    showCountryPicker(context: context, onSelect:(Country _country){
      setState(() {
        country = _country;
      });
    });

  }
}
