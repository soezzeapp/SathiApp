import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:sathiclub/authentication/bloc/authentication_bloc.dart';
import 'package:sathiclub/home/provider/CardProvider.dart';
import '../../authentication/models/ProfileModel.dart';
import '../bloc/home_bloc.dart';
import 'SingleProfileView.dart';

class SathiCard extends StatefulWidget {
  //final String urlImage;
  final ProfileModel profile;
  final bool isFront;
  const SathiCard({Key? key,
    //required this.urlImage,
    required this.isFront,
    required this.profile,
  }) : super(key: key);

  @override
  _SathiCardState createState() => _SathiCardState();
}

class _SathiCardState extends State<SathiCard> {
  int displayIndex = 0;
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final provider = Provider.of<CardProvider>(context,listen: false);
      provider.setScreenSize(size);
    });

  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child:widget.isFront? buildFrontCard():buildCard(),
    );
  }

  Widget buildFrontCard() =>GestureDetector(
    child: LayoutBuilder(
      builder: (context,constraints) {
        final provider = Provider.of<CardProvider>(context);
        final position = provider.position;
        final milliseconds =provider.isDragging?0:400;
        final center = constraints.smallest.center (Offset.zero);
        final angle = provider.angle * pi /180;
        final rotatedMatrix = Matrix4.identity()
          ..translate(center.dx,center.dy)
          ..rotateZ(angle)
          ..translate(-center.dx,-center.dy);
        return AnimatedContainer(
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: milliseconds),
          transform: rotatedMatrix..translate(position.dx,position.dy),
          child: Stack(
            children: [
              buildCard(),
              buildStamps(),
            ],
          ),

        );

      }
    ),
    onPanStart: (details){
      final provider = Provider.of<CardProvider>(context,listen:false);
        provider.startPosition(details);
  },
    onPanUpdate: (details){
      final provider = Provider.of<CardProvider>(context,listen:false);
        provider.updatePosition(details);
    },
    onPanEnd: (details){
      final provider = Provider.of<CardProvider>(context,listen:false);
        provider.endPosition();
    },
  );

  Widget buildCard()=>ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: CachedNetworkImage(
      imageUrl:widget.profile.user.profileUrl,
      imageBuilder:(context,imageProvider )=>Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(widget.profile.user.profileUrl,),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.transparent,Colors.black],
                begin:Alignment.topCenter,
                end:Alignment.bottomCenter,
                stops: [0.7,1]
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child:Column(
              children: [
                const Spacer(),
                buildName(),
                buildStatus(),
                buildDistance(),
                const SizedBox(height: 30,),
              ],
            )
          ),
        ),
      ),
      placeholder: (context, url) => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              /*
              image: DecorationImage(
                image: AssetImage('assets/images/sathi_icon_background.jpg'),
                fit: BoxFit.fitWidth,
              ),*/
            ),
          ),
          Center(
              child: Lottie.asset('assets/images/loading-heart.json')),
        ],
      ),
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage('assets/images/sathi_icon_background.jpg'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    ),
  );

  Widget buildStamps(){
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();
    switch (status){
      case CardStatus.like:
        final child = buildStamp(angle:-0.5,color: Colors.green, text: 'LIKE',opacity:opacity);
        return Positioned(top:64,left:50,child: child);
      case CardStatus.dislike:
        final child = buildStamp(angle:0.5,color: Colors.red, text: 'NOPE',opacity:opacity);
        return Positioned(top:64,right:50,child: child);
      case CardStatus.superLike:
        final child = buildStamp(angle:-0.5,color: Colors.blue, text: 'SUPER\nLIKE',opacity:opacity);
        return Positioned(bottom:128,left:20,right:20,child: child);
      default:return Container();
    }
  }

  Widget buildStamp({double angle =0,
    required Color color,
    required String text,
    required double opacity,
  }){
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle:angle,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color,width: 4)
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }

  Widget buildName(){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            SingleProfileViewPage(profile:widget.profile)));

      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0,8,0,8),
        child: Row(
          children: [
            Flexible(
              child: Text(
                widget.profile.user.name,
                overflow:TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(width: 16,),
            Text(
              '${widget.profile.user.age}',
              style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget buildStatus(){
      return Row(
        children: [
          Container(
            decoration:BoxDecoration(
              shape: BoxShape.circle,
              color: widget.profile.user.online?Colors.green:Colors.blueAccent,
            ),
            width:12,
            height: 12,
          ),
          const SizedBox(width: 8,),
          if(widget.profile.user.online)
          const Text('Online',
            style: TextStyle(
              fontSize:16,
              color: Colors.white
            ),
          ),
          if(!widget.profile.user.online)
          Text('Last Active : '+widget.profile.user.activeDate.toString().substring(0,16),
            style: const TextStyle(
                fontSize:16,
                color: Colors.white
            ),
          ),
        ],
      );

  }
  Widget buildDistance(){
    return BlocBuilder<AuthenticationBloc,AuthenticationState>(
      builder: (context,state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0,8,0,8),
          child:Row(
            children: [
              const Icon(Icons.location_on,color: Colors.white,size: 14,),
              const SizedBox(width: 8,),
             if(state is AuthenticatedState)
              Text('${getDistance(currentPosition: state.user.activeLocation,
                  profilePosition: widget.profile.user.activeLocation)} kilometers away',
                  style: const TextStyle(
                      fontSize:16,
                      color: Colors.white
                  ),
                ),

            ],
          )
        );
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
