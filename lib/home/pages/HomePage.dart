
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sathiclub/authentication/models/ProfileModel.dart';
import 'package:sathiclub/home/pages/SingleProfileView.dart';
import 'package:sathiclub/home/provider/CardProvider.dart';

import '../../authentication/bloc/authentication_bloc.dart';
import '../../constants/themeColors.dart';
import '../model/ProfileIndexModel.dart';
import 'SathiCard.dart';
import '../bloc/home_bloc.dart';
import 'SingleProfileViewIndexed.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(GetAllUsersHomeEvent());
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<HomeBloc,HomeState>(
        listener:(context,state){
          if(state is LoadedHomeState) {
          final provider = Provider.of<CardProvider>(context,listen: false);
                provider.profiles = state.profiles;
            }
        },
        builder:(context, state) {
          if(state is LoadingHomeState){
            return const Center(
                child: CircularProgressIndicator());
          }
          else if (state is LoadedHomeState){
            final provider = Provider.of<CardProvider>(context);
            //final profiles = state.profiles;
            List<ProfileModel>profiles = provider.profiles;
            return SafeArea(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      child:
                      profiles.isEmpty?
                      Center(
                        child: ElevatedButton(
                          child:const Text('Restart'),
                          onPressed: (){
                            //BlocProvider.of<HomeBloc>(context).getAllUsersHomeEvent();
                            BlocProvider.of<HomeBloc>(context).add(GetAllUsersHomeEvent());
                            final provider = Provider.of<CardProvider>(context,listen: false);
                            provider.profiles = state.profiles;
                            setState(() {
                              profiles = provider.profiles;
                              //print(profiles.length);
                            });

                          },
                        ),

                      ):
                          Stack(
                            children: profiles.map((profile)=> SathiCard(
                              profile:profile,
                              isFront :profiles.last == profile,
                            )).toList(),
                          ),

                  ),
                  Positioned(
                    bottom: -2,
                      child: buildButtons()),
                ],
              ),
            );
            }
          else if (state is LoadedHomeGridState){
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: state.profiles.isNotEmpty ?
              GridView.builder(
                  itemCount: state.profiles.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, index) {
                    GeoPoint usersLocation =state.profiles[index].user.activeLocation;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                        },
                        child: Stack(
                          alignment:Alignment.bottomLeft ,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(state.profiles[index].user.profileUrl,
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
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                     SingleProfileViewPage(profile:state.profiles[index])));
                                  },
                                  child: Align(
                                    alignment:Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(state.profiles[index].user.name+' '+state.profiles[index].user.age.toString(),
                                        overflow:  TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 18, color: Colors.white),),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:10.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration:BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: state.profiles[index].user.online?Colors.green:Colors.blueAccent,
                                        ),
                                        width:12,
                                        height: 12,
                                      ),
                                      const SizedBox(width: 8,),
                                      if(state.profiles[index].user.online)
                                        const Text('Online',
                                          style: TextStyle(
                                              fontSize:16,
                                              color: Colors.white
                                          ),
                                        ),
                                      if(!state.profiles[index].user.online)
                                        Text(state.profiles[index].user.activeDate.toString().substring(0,16),
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
                          ],
                        ),
                      ),
                    );
                  })
                  : const Center(child: Text('No User To Show')),
            );

          }
          else if (state is LoadedHomeRadarState){
            return Stack(
              children: [
                Center(
                  child: Container(
                    child:Lottie.asset('assets/images/radar.json'),
                  ),
                ),
                Center(
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 121,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:11,childAspectRatio: 1/1),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            SingleProfileViewIndexedPage(profile:
                            state.indexedProfiles[
                            getIndex(gridIndex: index, allMap: state.indexedPairsMap)
                            ])));
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                /*decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green,
                                      width: 1,
                                  ),
                                ),*/
                                child:
                                index==60?CircleAvatar(
                                  backgroundImage:NetworkImage(state.mUser.profileUrl)
                                ):
                                state.indexes.contains(index)?
                                CircleAvatar(
                                    backgroundImage:NetworkImage(state.indexedProfiles[
                                      getIndex(gridIndex: index, allMap: state.indexedPairsMap)
                                    ].user.profileUrl)
                                )
                                    :Container()
                              ),
                              state.indexes.contains(index)?
                              Positioned(
                                child:
                                Container(
                                  decoration:BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: state.indexedProfiles[
                                    getIndex(gridIndex: index, allMap: state.indexedPairsMap)
                                    ].user.online
                                        ?Colors.green:Colors.grey,
                                  ),
                                  width:12,
                                  height: 12,
                                ),
                                /*CircleAvatar(
                                  radius: 10,
                                  backgroundColor:Colors.black,
                                  child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      getDistance(
                                        profilePosition:state.indexedProfiles[
                                        getIndex(gridIndex: index, allMap: state.indexedPairsMap)
                                        ].user.activeLocation,
                                        currentPosition: state.mUser.activeLocation
                                      ).toString(),
                                    style: TextStyle(color: Colors.white),

                                  ),
                                ),*/
                              ):Container()

                            ],
                          ),
                        );
                      }),
                )
              ],
            );
          }


          else { return const Center(
              child: Text('Error while fetching data')); }
          }
      ),
    );
  }
  Widget buildButtons(){
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status ==CardStatus.superLike;

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          Padding(
            padding: const EdgeInsets.only(right: 24,bottom:8),
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
                  final provider = Provider.of<CardProvider>(context, listen: false);
                  provider.dislike();
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:8),
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
                  final provider = Provider.of<CardProvider>(context, listen: false);
                  provider.superLike();

                },

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24,bottom:8),
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
                  final provider = Provider.of<CardProvider>(context, listen: false);
                  provider.like();
                },
              ),
            ),
          ),
        ]
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
  int getIndex ({required int gridIndex,required Map<int,int>allMap}){
    int index = 0;
    final  gotIndex =  allMap[gridIndex];
    if(gotIndex!=null){
      index = gotIndex;
    }
    return index;

  }




}
