import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';
import '../../constants/themeColors.dart';
import '../bloc/authentication_bloc.dart';
import '../models/InterestModel.dart';
import '../models/UserModel.dart';

class InterestPage extends StatefulWidget {
  final String mUid;
  final UserModel mUser;
  final bool fromSignup;
  final List<InterestModel> mInterests;
  const InterestPage({Key? key,required this.mUid, required this.mUser,
    required this.mInterests,required this.fromSignup}) : super(key: key);
  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  List<bool>interestsBool =[];
  bool _isSaving = false;
  @override void initState() {
    super.initState();
    getInterestsBool();
    for(int i=0;i<widget.mInterests.length;i++) {
         for(int j=0;j<Constants.interestTags.length;j++){
              if(Constants.interestTags[j]==widget.mInterests[i].interest){
                            interestsBool[j]=true;
                  }
              }
       }
  }

  @override
  Widget build(BuildContext context) {
    return interestsPage();
  }

  Widget interestsPage(){
    return Column(
      children:  [
        if(widget.fromSignup)
        SizedBox(height: 40,),
        if(widget.fromSignup)
        Align(
            alignment: Alignment.centerLeft,
            child:backButtonInterests()),
        const SizedBox(height: 20,),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Select your passion ',
              style:TextStyle (
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(8,8,8,0),
          child: Text('Select a few of your interests to match with users who have similar things in common.',
            style:TextStyle (
                fontSize: 18,
                color: themeColorSubtitle),),
        ),
        interestTagsGridView(),

        const SizedBox(
          height: 50,
        ),
        continueButtonInterests(),
      ],
    );
  }
  Widget backButtonInterests(){
    return IconButton(
      icon:const Icon(Icons.arrow_back,color:themeColorSubtitle),
      onPressed: (){
        context.read<AuthenticationBloc>().add(BackFromInterestsStateEvent(uid:widget.mUid,user:widget.mUser));
      },
    );

  }
  Widget interestTagsGridView(){
    return Flexible(
      child: GridView.builder(
          itemCount: Constants.interestTags.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),

          itemBuilder: (BuildContext context, index) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: GestureDetector(
                onTap: (){
                  if(interestsBool[index]==true){
                    context.read<AuthenticationBloc>().add(DeleteInfoInterestsEachEvent(
                        uid:widget.mUid,interest:Constants.interestTags[index]));
                  }
                  setState(() {
                    interestsBool[index]=!interestsBool[index];
                  });
                  if(interestsBool[index]==true){
                    context.read<AuthenticationBloc>().add(AddInfoInterestsEachEvent(
                        uid:widget.mUid,interest:Constants.interestTags[index]));
                  }
                },
                child: Column(
                  children: [
                    Flexible(
                      //color: Colors.white,
                        child:Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border. all(
                                color: interestsBool[index]==true?themeButtonColor:const Color(0xFF282828),),
                              color: interestsBool[index]==true?themeButtonColor:const Color(0xFF282828),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(Constants.interestTags[index],
                                  style: TextStyle(color: interestsBool[index]==true?Colors.white:themeColorSubtitle)),
                            ))
                    ),

                  ],
                ),
              ),
            );
          }),
    );

  }
  void getInterestsBool(){
    for(int i=0;i<Constants.interestTags.length;i++){
      interestsBool.add(false);
    }

  }
  Widget continueButtonInterests(){
    List<String>_interests = [];
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
                          title: 'Interests',
                          value: 'Interests',
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
                    int count = 0;
                    for(int i=0;i<interestsBool.length;i++){
                      if(interestsBool[i]==true){
                        count = count+1;
                        _interests.add(Constants.interestTags[i]);
                      }
                    }
                    if(count==0){
                      const msg = 'Please pick your interests first' ;
                      const snackBar = SnackBar(content:Text(msg));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }else{
                      context.read<AuthenticationBloc>().add(UpdateInfoInterestsEvent(uid:widget.mUid,interests:_interests));
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
