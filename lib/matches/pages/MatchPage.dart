import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../authentication/bloc/authentication_bloc.dart';
import '../../authentication/models/ProfileModel.dart';
import '../../constants/themeColors.dart';
import '../../messages/chat/screens/mobile_chat_screen.dart';
import '../bloc/match_bloc.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  List<ProfileModel>profiles=[];

  @override void initState() {
    super.initState();
    BlocProvider.of<MatchBloc>(context).getMatchesEvent();

  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<MatchBloc,MatchState>(
          listener:(context,state){
            if(state is LoadedMatchState) {
              profiles= state.profiles;
            }
          },

        builder: (context,state) {
            if(state is LoadingMatchState){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(state is LoadedMatchState)
              {
                profiles= state.profiles;
                return SafeArea(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        child: profiles.isNotEmpty ?
                        GridView.builder(
                            itemCount: profiles.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),

                            itemBuilder: (BuildContext context, index) {
                              GeoPoint usersLocation =profiles[index].user.activeLocation;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: (){ },
                                  child: Stack(
                                    alignment:Alignment.bottomLeft ,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(18.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(profiles[index].user.profileUrl
                                                //errorListener:AssetImage() ,

                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          width: screenWidth/2.5,
                                          child:  Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [Colors.transparent,Colors.black],
                                                  begin:Alignment.topCenter,
                                                  end:Alignment.bottomCenter,
                                                  stops: [0.6,1]
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment:CrossAxisAlignment.end ,
                                        children: [
                                          Align(
                                            alignment:Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(state.profiles[index].user.name+' '+state.profiles[index].user.age.toString(),
                                                overflow:  TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 18, color: Colors.white),),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(left:10.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration:BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: profiles[index].user.online?Colors.green:Colors.blueAccent,
                                                  ),
                                                  width:12,
                                                  height: 12,
                                                ),
                                                const SizedBox(width: 8,),
                                                if(profiles[index].user.online)
                                                  const Text('Online',
                                                    style: TextStyle(
                                                        fontSize:16,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                if(!profiles[index].user.online)
                                                  Text(profiles[index].user.activeDate.toString().substring(0,16),
                                                    style: const TextStyle(
                                                        fontSize:12,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          BlocBuilder<AuthenticationBloc,AuthenticationState>(
                                              builder: (context,state) {
                                                return Padding(
                                                    padding: const EdgeInsets.fromLTRB(10,8,0,8),
                                                    child:Row(
                                                      children: [
                                                        const Icon(Icons.location_on,color: Colors.white,size: 14,),
                                                        const SizedBox(width: 8,),
                                                        if(state is AuthenticatedState)
                                                          Text('${getDistance(currentPosition: state.user.activeLocation,
                                                              profilePosition: usersLocation)} km away',
                                                            style: const TextStyle(
                                                                fontSize:16,
                                                                color: Colors.white
                                                            ),
                                                          ),

                                                      ],
                                                    )
                                                );
                                              }
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        bottom:-2,
                                        right: 1,
                                        child: IconButton(
                                            icon:const Icon(Icons.message,color: Colors.white,),
                                            onPressed: (){
                                              Navigator.pushNamed(
                                                  context,
                                                  MobileChatScreen.routeName,
                                                  arguments: {
                                                    'name':profiles[index].user.name,
                                                    'id' :profiles[index].user.id,
                                                    'isGroupChat':false,
                                                    'profilePic':profiles[index].user.profileUrl,
                                                  }
                                              );

                                            },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })
                            : const Center(child: Text('No User To Show')),
                      )
                    ],
                  ),
                );
              }
            else if(state is NoMatchState){
              return  const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('when you match with other users they will appear here, where you can send them message',
                  style: TextStyle(color: Colors.grey),
                ),
              ));

            }
            else{
              return  Center(child: Container(
                child:const Text('Error Loading'),
              ));
            }

        }
      ),
    );
  }

  Widget chatButton(){
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
            child:const Text('Chat',style: TextStyle(fontSize: 18),),
            onPressed:(){
              //context.read<AuthenticationBloc>().add(UpdateInfoGenderEvent(uid:mUid,gender:_gender));
            }

        ),
      ),
    );

  }


  int getDistance({required GeoPoint currentPosition, required GeoPoint profilePosition})  {
    int distance = 1 ;
    double _distanceInMeters =  Geolocator.distanceBetween(
      profilePosition.latitude,
      profilePosition.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );
    double _distanceInKiloMeters = _distanceInMeters/1000;

    distance = _distanceInKiloMeters.toInt();
    return distance;

  }



}
