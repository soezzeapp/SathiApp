import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../constants/themeColors.dart';
import '../bloc/authentication_bloc.dart';
import '../models/UserModel.dart';

class LocationPage extends StatefulWidget {
  final String mUid;
  final UserModel mUser;
  const LocationPage({Key? key,required this.mUid,required this.mUser}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool isFetchingCurrentLocation = false;
  bool hasSelectedCurrentLocation = false;
  GeoPoint _geoPoint = const GeoPoint(1.11,1.11);

  @override void initState() {
    super.initState();
    if(widget.mUser.activeLocation !=const GeoPoint(1.11,1.11)){
      _geoPoint = widget.mUser.activeLocation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return locationPage();
  }

  Widget backButtonLocation(){
    return IconButton(
      icon:const Icon(Icons.arrow_back,color:themeColorSubtitle),
      onPressed: (){
        context.read<AuthenticationBloc>().add(BackFromLocationStateEvent(uid:widget.mUid,user: widget.mUser));
      },
    );

  }
  Widget locationPage(){
    return SingleChildScrollView(
      child: Column(
        children:  [
          const SizedBox(height: 40,),
          Align(
              alignment: Alignment.centerLeft,
              child:backButtonLocation()),
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
          const SizedBox(height: 20,),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Allow to get your Location ',
              style:TextStyle (
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Please click on button below',
              style:TextStyle (
                  fontSize: 18,
                  color: themeColorSubtitle),),
          ),
          const SizedBox(
            height:40,
          ),
          Container(
            height:300,
            decoration:const BoxDecoration(
              image:DecorationImage(image: AssetImage('assets/images/location_image.png',),
                fit:BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          allowButtonLocation(),

        ],
      ),
    );
  }
  Widget allowButtonLocation(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
            style:ElevatedButton.styleFrom(
              primary:themeButtonColor,
              onPrimary: Colors.white,
              minimumSize: const Size(double.infinity,50),
            ),
            child:const Text('ALLOW',style: TextStyle(fontSize: 18,),),
            onPressed:() async {
              final mGeoPoint = await getCurrentPosition();
              if(mGeoPoint!=const GeoPoint(1.11,1.11)){
                context.read<AuthenticationBloc>().add(UpdateInfoLocationEvent(uid:widget.mUid,location:mGeoPoint));
              }
            }
        ),
      ),
    );

  }
  Future<GeoPoint> getCurrentPosition() async {
    GeoPoint geopoint = _geoPoint;
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied||permission==LocationPermission.deniedForever){
      LocationPermission asked = await Geolocator.requestPermission();
      LocationPermission permissionCheckedAgain = await Geolocator.checkPermission();
      if(permissionCheckedAgain == LocationPermission.denied||permissionCheckedAgain==LocationPermission.deniedForever)
      {
        const message = 'Permission Denied';
        const snackBar = SnackBar(content:Text(message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isFetchingCurrentLocation = false;
        });
      } else{
        final currentLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high );
        isFetchingCurrentLocation = false;
        hasSelectedCurrentLocation = true;
        setState(() {
          geopoint = GeoPoint(currentLocation.latitude,currentLocation.longitude);
        });

      }
    }
    else{
      final currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high );
      isFetchingCurrentLocation = false;
      hasSelectedCurrentLocation= true;
      setState(() {
        geopoint =  GeoPoint(currentLocation.latitude,currentLocation.longitude);
      });
    }
    setState(() { _geoPoint = geopoint;});
    return geopoint;
  }
}
