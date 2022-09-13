import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../constants/themeColors.dart';
import '../bloc/authentication_bloc.dart';
import '../models/UserModel.dart';

class TermsPage extends StatefulWidget {
  final String mUid;
  final UserModel mUser;
  const TermsPage({Key? key,required this.mUid,required this.mUser}) : super(key: key);

  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  @override
  Widget build(BuildContext context) {
    return welcomePage();
  }

  Widget welcomePage(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              Text('Welcome to Sathi Club',style: TextStyle(
                fontSize: 24,
                color: Colors.black.withOpacity(.8),
                fontWeight: FontWeight.bold,
              ),),
              const Text('Please follow these house rules',style: TextStyle(
                fontSize: 16,
                color: themeColorSubtitle,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0,8,8,8),
                    child: Icon(Icons.check_circle_sharp ,color: themeButtonColor,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Be yourself.',style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(.8),
                      fontWeight: FontWeight.bold,
                    ),),
                  ),

                ],
              ),
              const Text('Make sure your photos, age and bio are true to who you are.',style: TextStyle(
                fontSize: 16,
                color: themeColorSubtitle,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0,8,8,8),
                    child: Icon(Icons.check_circle_sharp ,color: themeButtonColor,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Stay safe.',style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(.8),
                      fontWeight: FontWeight.bold,
                    ),),
                  ),

                ],
              ),
              const Text('Don\'t be too quick to give out personal information. Date Safely.',style: TextStyle(
                fontSize: 16,
                color: themeColorSubtitle,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0,8,8,8),
                    child: Icon(Icons.check_circle_sharp ,color: themeButtonColor,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Play it cool.',style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(.8),
                      fontWeight: FontWeight.bold,
                    ),),
                  ),

                ],
              ),
              const Text('Respect others and treat them as you would like to be treated.',style: TextStyle(
                fontSize: 16,
                color: themeColorSubtitle,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0,8,8,8),
                    child: Icon(Icons.check_circle_sharp ,color: themeButtonColor,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Be proactive.',style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(.8),
                      fontWeight: FontWeight.bold,
                    ),),
                  ),

                ],
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Always report bad behaviour.',style: TextStyle(
                  fontSize: 16,
                  color: themeColorSubtitle,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              const SizedBox(height: 20),
              acceptTermsButton(),
            ],
          ),
        ),
      ),
    );



  }
  Widget acceptTermsButton(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
            style:ElevatedButton.styleFrom(
              primary: themeButtonColor,
              onPrimary: Colors.white,
              minimumSize: const Size(double.infinity,50),
            ),
            child:const Text('I AGREE',style: TextStyle(fontSize: 18),),
            onPressed:(){
              context.read<AuthenticationBloc>().add(UpdateInfoWelcomeAndTermsEvent(uid:widget.mUid,agreedTerms:true));
            }
        ),
      ),
    );

  }
}
