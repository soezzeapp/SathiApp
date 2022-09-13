import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sathiclub/constants/themeColors.dart';
import 'package:sathiclub/home/provider/CardProvider.dart';

import '../../authentication/bloc/authentication_bloc.dart';
import '../../authentication/models/ProfileModel.dart';
import '../../home/bloc/home_bloc.dart';
import '../bloc/grid_bloc.dart';

class GridPage extends StatefulWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
    int pageIndex = 0;
    List<ProfileModel>profiles=[];
    List<ProfileModel>gridProfiles=[];
    List<ProfileModel>likeProfiles=[];

  @override void initState() {
    super.initState();
    BlocProvider.of<GridBloc>(context).add(GetLikesGridStateEvent());

  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<GridBloc,GridState>(
            builder:(context, state) {
              if(state is LoadingGridState){
                return const Center(
                    child: CircularProgressIndicator());
              }
              else if (state is LoadedLikesGridState){
                profiles = state.profileLikes;
                return Scaffold(
                  body: SafeArea(
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
                                                image: CachedNetworkImageProvider(profiles[index].user.profileUrl,
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
                                                child: Text(
                                                  overflow: TextOverflow.ellipsis,
                                                  profiles[index].user.name+', '+profiles[index].user.age.toString(),
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
                                      ],
                                    ),
                                  ),
                                );
                              })
                            : const Center(child: Text('No User To Show')),
                        )
                      ],
                    ),
                  ),
                );
              }


              else { return const Center(
                  child: Text('Error while fetching data')); }
            }


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
