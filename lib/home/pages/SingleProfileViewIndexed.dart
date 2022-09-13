import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sathiclub/home/bloc/selected_user_video_view_bloc/selected_user_video_view_bloc.dart';
import 'package:sathiclub/home/model/ProfileIndexModel.dart';
import 'package:sathiclub/profile/repository/FirebaseProfileApi.dart';

import '../../authentication/models/InterestModel.dart';
import '../../authentication/models/ProfileModel.dart';
import '../../authentication/models/VideoModel.dart';
import '../../common/widgets/potrait_landscape_video_player_widget.dart';
import '../../constants/themeColors.dart';
import '../provider/CardProvider.dart';


class SingleProfileViewIndexedPage extends StatefulWidget {
  final ProfileIndexModel profile;
  const SingleProfileViewIndexedPage({Key? key,required this.profile}) : super(key: key);

  @override
  _SingleProfileViewIndexedPageState createState() => _SingleProfileViewIndexedPageState();
}

class _SingleProfileViewIndexedPageState extends State<SingleProfileViewIndexedPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SelectedUserVideoViewBloc>(context).add(
        GetSelectedUserVideoViewEvent(userId: widget.profile.user.id));

  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.height;
    return Center(
      child: Scaffold(
        backgroundColor: Colors.black,
        body:SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                      width: screenWidth,
                      height: screenHeight*.70,
                      child://Image.network(widget.profile.user.profileUrl,fit: BoxFit.cover,),
                      CachedNetworkImage(
                        imageUrl: widget.profile.user.profileUrl,
                        fit:BoxFit.cover,
                        errorWidget:
                            (context, url, error) {
                          return Image.asset(
                              "assets/images/sathi_icon.png");
                        },
                      )
                  ),
                  Positioned(
                    top: 20,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,8,8,8,),
                      child: IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();},
                        icon: Icon(Icons.arrow_back,color: Colors.white,),),
                    ),
                  ),
                  Positioned(
                      top: screenWidth*.2,
                      right: 8,
                      child: buildButtonsColumn()),
                  SizedBox(height: 10,),
                  Positioned(
                      bottom: screenHeight/8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(widget.profile.user.name+', '+widget.profile.user.age.toString(),
                                  style: TextStyle(
                                      fontSize:24,
                                      color: Colors.grey),),
                              ),),
                            if(widget.profile.user.description !='default')
                              Container(
                                width: screenWidth,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(16,8,36,8),
                                  child: Text(
                                    widget.profile.user.description,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize:18,
                                        color: Colors.grey),),
                                ),),
                          ],
                        ),
                      )),
                  Positioned(
                    bottom: -screenWidth/10,
                    child: SizedBox(
                      height:screenWidth/6,
                      width:screenWidth,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          //physics: NeverScrollableScrollPhysics(),
                          //shrinkWrap: true,
                          itemCount: widget.profile.photos.length,
                          itemBuilder:(BuildContext context, int index){
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: screenWidth/6,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(widget.profile.photos[index].url,fit: BoxFit.cover,)),
                              ),
                            );

                          } ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenWidth/8,),
              titleValue('Interests',getInterestString(widget.profile.interests)),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24,16,8,8),
                  child: Text('Basic',style: TextStyle(color: Colors.grey,fontSize: 18),),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24,16,8,8),
                    child: Text('Gender',style: TextStyle(color: Colors.grey,fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24,16,8,8),
                    child: Text(widget.profile.user.gender,style: TextStyle(color: Colors.white,fontSize: 18),),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24,16,8,8),
                    child: Text('Orientation',style: TextStyle(color: Colors.grey,fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24,16,8,8),
                    child: Text(widget.profile.user.orientation,style: TextStyle(color: Colors.white,fontSize: 18),),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24,16,8,8),
                    child: Text('Preference',style: TextStyle(color: Colors.grey,fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24,16,8,8),
                    child: Text(widget.profile.user.preference,style: TextStyle(color: Colors.white,fontSize: 18),),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24,24,8,8),
                  child: Text('Videos',style: TextStyle(color: Colors.grey,fontSize: 18),),
                ),
              ),
              BlocBuilder<SelectedUserVideoViewBloc,SelectedUserVideoViewState>(
                  builder: (context,state) {
                    if(state is LoadedSelectedUserVideoViewState){
                      return SizedBox(
                          height:screenWidth/4,
                          width:screenWidth,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: ScrollController(),
                              itemCount: state.videos.length,
                              itemBuilder:(BuildContext context,index){
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                        PortraitLandscapePlayerWidget( mVideo:state.videos[index].url)));
                                  },
                                  child: Stack(
                                    alignment:Alignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Container(
                                              height:screenWidth/4,
                                              width:screenWidth/4 ,
                                              child:CachedNetworkImage(
                                                imageUrl: state.videos[index].thumbnail,
                                                fit:BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) {
                                                  return Image.asset(
                                                      "assets/images/sathi_icon.png");
                                                },
                                              )
                                          ),
                                        ),
                                      ),
                                      CircleAvatar(
                                          backgroundColor: themeButtonColor,
                                          radius:36,
                                          child: Icon(Icons.play_arrow,color: Colors.white,size: 36,))
                                    ],
                                  ),
                                );

                              }
                          )
                      );
                    }else{
                      return Container();
                    }

                  }
              ),

            ],
          ),
        ) ,
      ),
    );
  }
  Widget titleValue (String title, String value ){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24,16,8,8),
          child: Text(title,style: TextStyle(color: Colors.grey,fontSize: 18),),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24,0,8,16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value=='default'?'':value,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white,fontSize: 18),),
            ],
          ),
        )
      ],
    );

  }
  String getInterestString(List<InterestModel>interests){
    String interestString ='';
    for (int i=0;i<interests.length;i++){
      interestString = interestString + interests[i].interest+', ';
    }
    return interestString;

  }
  Widget buildButtonsColumn(){
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status ==CardStatus.superLike;
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          Padding(
            padding: const EdgeInsets.fromLTRB(8,8,8,16),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape:MaterialStateProperty.all<CircleBorder>(const CircleBorder()),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                    backgroundColor: MaterialStateProperty.all<Color>(isDislike?const Color(0xFF8C8121):Colors.yellow),
                    //overlayColor:getColor(Colors.white,Colors.yellow),
                    overlayColor: MaterialStateProperty.resolveWith(
                            (states) {
                          return states.contains(MaterialState.pressed)
                              ? Colors.black26
                              : null;
                        }
                    )
                  //side:getBorder(Colors.white,Colors.yellow),
                ),
                child: const Icon(Icons.clear,
                  color: Colors.white,
                  size: 28,),
                onPressed: (){

                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8,8,8,16),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style:  ButtonStyle(
                    shape:MaterialStateProperty.all<CircleBorder>(const CircleBorder()),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                    backgroundColor: MaterialStateProperty.all<Color>(isSuperLike?const Color(0xFF236B8C):Colors.lightBlueAccent),
                    //overlayColor:getColor(Colors.white,Colors.yellow),
                    overlayColor: MaterialStateProperty.resolveWith(
                            (states) {
                          return states.contains(MaterialState.pressed)
                              ? Colors.black26
                              : null;
                        }
                    )
                  //side:getBorder(Colors.white,Colors.yellow),
                ),
                child: const Icon(Icons.keyboard_double_arrow_up,color: Colors.white,size:28,),
                onPressed: (){

                },

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8,8,8,16),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape:MaterialStateProperty.all<CircleBorder>(const CircleBorder()),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent),
                    backgroundColor: MaterialStateProperty.all<Color>(isLike?const Color(0xFF8C2347):Colors.pinkAccent),
                    //overlayColor:getColor(Colors.white,Colors.yellow),
                    overlayColor: MaterialStateProperty.resolveWith(
                            (states) {
                          return states.contains(MaterialState.pressed)
                              ? Colors.black26 : null;
                        }
                    )
                ),
                child: const Icon(Icons.favorite,color: Colors.white,size: 28,),
                onPressed: (){

                },
              ),
            ),
          ),
        ]
    );

  }
}
