import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sathiclub/authentication/models/InterestModel.dart';
import 'package:sathiclub/authentication/models/PhotoModel.dart';

import '../../common/widgets/ShowSnackBar.dart';
import '../../constants/themeColors.dart';
import '../bloc/authentication_bloc.dart';
import '../models/UserModel.dart';
import '../repository/firebaseApi.dart';
import '../repository/firebaseAuthApi.dart';

class PhotoPage extends StatefulWidget {
  final String mUid;
  final UserModel mUser;
  final List<PhotoModel>mPhotos;
  final bool fromSignup;

  const PhotoPage({Key? key,
    required this.mUid,
    required this.mUser,
    required this.mPhotos,
    required this.fromSignup,

  }) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  List<File?>fileImageList=[];
  File?fileImage ;
  List<Uint8List?>memoryImageList=[];
  Uint8List ?memoryImage ;
  List<UploadTask?>taskList=[];
  UploadTask? task;
  String  urlDownload ='';
  List<String>urlDownloadList=[];
  String  networkUrl ='';
  List<String>networkUrlList=[];
  bool hasPicked =false;
  List<bool>hasPickedList = [];
  int profilePicIndex = 7;
  final String _profilePicURl='';
  bool pickUploadComplete = false;
  int imageUploadCount = 0;
  bool _isSaving = false;

  @override void initState() {
    super.initState();
    fileImageList =List<File?>.generate(6, (int index) => fileImage);
    memoryImageList =List<Uint8List?>.generate(6, (int index) => memoryImage);
    taskList =List<UploadTask?>.generate(6, (int index) => task);
    urlDownloadList =List<String>.generate(6, (int index) => urlDownload);
    networkUrlList =List<String>.generate(6, (int index) => networkUrl);
    hasPickedList =List<bool>.generate(6, (int index) => hasPicked);
    
    if(widget.mPhotos.isNotEmpty){
      for(int i =0;i<widget.mPhotos.length;i++){
        if(widget.mPhotos[i].id==0){networkUrlList[0]=widget.mPhotos[i].url;urlDownloadList[0]=widget.mPhotos[i].url;}
        else if(widget.mPhotos[i].id==1){ networkUrlList[1]=widget.mPhotos[i].url;urlDownloadList[1]=widget.mPhotos[i].url;}
        else if(widget.mPhotos[i].id==2){ networkUrlList[2]=widget.mPhotos[i].url;urlDownloadList[2]=widget.mPhotos[i].url;}
        else if(widget.mPhotos[i].id==3){ networkUrlList[3]=widget.mPhotos[i].url;urlDownloadList[3]=widget.mPhotos[i].url;}
        else if(widget.mPhotos[i].id==4){ networkUrlList[4]=widget.mPhotos[i].url;urlDownloadList[4]=widget.mPhotos[i].url;}
        else if(widget.mPhotos[i].id==5){ networkUrlList[5]=widget.mPhotos[i].url;urlDownloadList[5]=widget.mPhotos[i].url;}
      }
      getImageUploadCount();
      profilePicIndex=widget.mUser.profileIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return photoPage();
  }

  Widget backButtonPhoto(){
    return IconButton(
      icon:const Icon(Icons.arrow_back,color:themeColorSubtitle),
      onPressed: (){
        context.read<AuthenticationBloc>().add(BackFromPhotoStateEvent(uid:widget.mUid,user:widget.mUser));
      },
    );

  }
  Widget photoPage(){
    return Column(
      children:  [
        if(widget.fromSignup)
        const SizedBox(height: 40,),
        if(widget.fromSignup)
        Align(
            alignment: Alignment.centerLeft,
            child:  backButtonPhoto()),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment:Alignment.centerLeft,
            child: Text('Pick your photos  ',
              style:TextStyle (
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(8,8,8,0),
          child: Text('Add atleast two photos to Next.Press on check to select profile picture.',
            style:TextStyle (
                fontSize: 18,
                color: themeColorSubtitle),),
        ),
        photosGridView(),
        continueButtonPhoto(),
      ],
    );
  }
  Widget photosGridView(){
    return Flexible(
      child: GridView.builder(
          itemCount: 6,
          shrinkWrap: true,
          physics:  NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: .7,
            mainAxisSpacing: 1,
            crossAxisSpacing: 2,
          ),

          itemBuilder: (BuildContext context, index) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: GestureDetector(
                onTap: (){
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      //color: Colors.white,
                      child:photoField(index: index),
                    ),
                  ],
                ),
              ),
            );
          }),
    );

  }
  Widget photoField({required int index, }) {
    const double screenWidth = 200;
    const double screenHeight = 280;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: screenHeight *.55 *.8,
                  width: screenWidth / 2,
                  color:memoryImageList[index]!= null ||networkUrlList[index]!=''?Colors.transparent: const Color(0xFFFFCECC),
                  child: memoryImageList[index]!= null ? Image.memory(
                    memoryImageList[index]!, fit: BoxFit.contain,
                    height: screenHeight * .55 * .8,) :
                  CachedNetworkImage(
                    imageUrl:networkUrlList[index],
                    placeholder: (context, url) =>  Image.asset(
                        "assets/images/image_2_blank.png"),
                    errorWidget: (context, url, error) => Image.asset('assets/images/image_2_blank.png', fit: BoxFit.cover,
                      height: screenHeight * .55 * .8,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                pickImage(index: index).
                then((_) => storeImage(index:index)).
                then((_)=>  context.read<AuthenticationBloc>().add(AddPhotoEvent(
                    uid:widget.mUid,url:urlDownloadList[index],index: index)));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(bottom: 36),
                    child: CircleAvatar(
                        backgroundColor: themeButtonColor,
                        child: Icon(Icons.add,color:Colors.white,size:36)),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom:-5,
              right:-5,
              child: GestureDetector(
                onTap:(){
                  clickImage(index: index)
                      .then((_)=> storeImage(index:index)).
                  then((_)=>  context.read<AuthenticationBloc>().add(AddPhotoEvent(
                      uid:widget.mUid,url:urlDownloadList[index],index: index)));
                },
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(36,36,24,36),
                  child: Icon(Icons.camera_alt,size:32,color:themeButtonColor),
                ),
              ),
            ),
            if(memoryImageList[index] != null||networkUrlList[index]!='')
            Positioned(
                bottom:5,
                left:-5,
                child: GestureDetector(
                  onTap:(){
                    if(urlDownloadList[index]!=''){
                      context.read<AuthenticationBloc>().add(UpdateProfilePicIndexEvent(
                          uid:widget.mUid,index: index,profileUrl:urlDownloadList[index]));
                      setState(() {
                        profilePicIndex= index;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16,36,28,14),
                    child: Icon(Icons.check_circle ,size:32,
                        color:index==profilePicIndex?Colors.green:Colors.grey),
                  ),
                ),
              ),
            Positioned(
                bottom: -5,
                child: SizedBox(
                    width: 160,
                    child: taskList[index]!=null?buildUploadStatus(taskList[index]!):Container())),
          ],
        ),
        if(memoryImageList[index] != null||networkUrlList[index]!='')
          Positioned(
            top: 5,
            right: -3,
            child: IconButton(
              icon: const Icon(Icons.cancel,color: Colors.red,size: 24,),
              onPressed: (){
                setState(() {
                  memoryImageList[index]=null;
                  taskList[index]=null;
                });
                if(urlDownloadList[index]==''){
                  deleteStoreImage(networkUrlList[index]).
                  then((_)=>context.read<AuthenticationBloc>().add(DeletePhotoEvent(
                      uid:widget.mUid,index:index.toString())));
                  networkUrlList[index]='';
                }
                else{
                  deleteStoreImage(urlDownloadList[index]).
                  then((_)=>context.read<AuthenticationBloc>().add(DeletePhotoEvent(
                      uid:widget.mUid,index:index.toString())));
                  setState(() {
                    urlDownloadList[index]='';
                  });
                }
              },
            ),
          ),

      ],
    );
  }
  Future pickImage({required int index}) async {
    try {
      final image = (await ImagePicker().pickImage(
        source: ImageSource.gallery,
      ));
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => fileImageList[index]=imageTemporary);
      final bytes = await image.readAsBytes();
      setState(() => memoryImageList[index] = bytes);
      hasPickedList[index] = true;
    } on PlatformException catch (e) {
      print("Failed to pick image:$e");
    }
  }
  Future clickImage({required int index}) async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final bytes = await image.readAsBytes();
      setState(() => memoryImageList[index] = bytes);
      hasPickedList[index] = true;
    }on PlatformException catch (e){
      print("Failed to pick image:$e");
    }

  }
  Widget buildUploadStatus(UploadTask task){
    return StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder:(context,snapshot){
          if(snapshot.hasData){
            final snap = snapshot.data;
            final progress = snap!.bytesTransferred/snap.totalBytes;
            final percentage = (progress*100).toStringAsFixed(2);
            if(progress==1){
              pickUploadComplete=true;
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(8,24,8,0),
              child:
              Column(
                children: [
                  LinearProgressIndicator(value: progress,
                    backgroundColor: themeColorSubtitle,
                    color:  themeButtonColor,
                  ),
                  Text('$percentage%',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: themeColorSubtitle),),
                ],
              ),);
          }else{
            return Container();
          }
        }
    );

  }
  Future storeImage({ required int index})async{
    String id = widget.mUser.id;
    if(memoryImageList[index]==null) return;
    //String fileName = File(fileImage!.path).uri.pathSegments.last;
    final destination = '$id/photos/$index';
    taskList[index] = FirebaseApi.uploadBytes(destination,memoryImageList[index]!);
    setState(() {});
    if (taskList[index]==null) return ;
    final snapshot=await taskList[index]! .whenComplete(() => (){});
    urlDownloadList[index] = await snapshot.ref.getDownloadURL();
    final count = getImageUploadCount();
    if(count==1){
      FirebaseAuthApi().updateProfilePhotoIndex(widget.mUser.id,index,urlDownloadList[index]);
      setState(() {profilePicIndex = index;});
    }
    //final urlDownload = await snapshot.ref.getDownloadURL();
    //print('Download-Link:$urlDownload');

  }
  Future<void> deleteStoreImage(String url) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
      getImageUploadCount();
    } catch (e) {
      print("Error deleting db from cloud: $e");
    }
  }
  Widget continueButtonPhoto(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocBuilder<AuthenticationBloc,AuthenticationState>(
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
                          title: 'Photos',
                          value: 'Photos',
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
                    primary:imageUploadCount>=2?themeButtonColor:Colors.white70,
                    onPrimary: imageUploadCount>=2?Colors.white:themeColorSubtitle,
                    minimumSize: const Size(double.infinity,50),
                  ),
                  child:const Text('Next',style: TextStyle(fontSize: 18,),),
                  onPressed:(){
                    if(imageUploadCount>=2){
                      if(urlDownloadList[profilePicIndex]==''){
                        showSnackBar(context: context, content: "Please Select Profile Pic");
                      } else{
                        context.read<AuthenticationBloc>().add(UpdatePhotoEvent(uid:widget.mUid,));
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
  int getImageUploadCount(){
    imageUploadCount =0;
    for(int i =0;i<6;i++){
      if(urlDownloadList[i]!=''||networkUrlList[i]!=''){
        imageUploadCount = imageUploadCount+1;
      }
    }
    setState(() {
      imageUploadCount;
      //print(imageUploadCount);
    });
    return imageUploadCount;
  }
}
