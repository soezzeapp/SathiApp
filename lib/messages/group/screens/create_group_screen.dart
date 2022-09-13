import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathiclub/common/widgets/ShowSnackBar.dart';
import 'package:sathiclub/messages/group/screens/select_contacts_group.dart';

import '../../../constants/themeColors.dart';
import '../../utils/utils.dart';
import '../bloc/group_bloc.dart';



class CreateGroupScreen extends StatefulWidget {
  static const String routeName = '/create-group';
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  File? image;
  final TextEditingController groupNameController = TextEditingController();

  void selectImage()async{
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  @override
  void dispose(){
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:AppBar(
        backgroundColor: Colors.black,
          title:  const Text('Create Group')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              alignment: Alignment.center,
              children:[
                image==null?
                const CircleAvatar(
                  radius:50,
                  backgroundImage:NetworkImage('https://images.pexels.com/photos/1808329/pexels-photo-1808329.jpeg?cs=srgb&dl=pexels-darwis-alwan-1808329.jpg&fm=jpg') ,
                ):
                CircleAvatar(
                  backgroundImage:FileImage(image!) ,
                  radius:50,
                ),
                Positioned(
                    bottom: 5,
                    left:60,
                    child: IconButton(onPressed: () {
                      selectImage();
                    }, icon: const Icon(Icons.camera_alt_rounded)))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                    hintText: 'Enter Group Name'
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.topLeft,
              child: const Text('Select Contacts',style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white,
              ),),
            ),
            const SelectContactsGroup(),
          ],
        ),
      ),
      floatingActionButton:  BlocBuilder<GroupBloc,GroupState>(
          builder: (context,state){
            if(state is LoadedGroupState){
              return FloatingActionButton(
                onPressed: (){
                  if(image!=null){
                    BlocProvider.of<GroupBloc>(context).add(CreateGroupEvent(
                        context: context,
                        name: groupNameController.text,
                        profilePic:image!,
                        selectedContacts: state.users));
                    Navigator.pop(context);
                  }
                  else{
                    showSnackBar(context: context, content: 'Please Select Image First');
                  }

                },
                backgroundColor: themeButtonColor,
                child: const Icon(Icons.done,color:Colors.white),
              );
            }else{
              return Container();
            }

        }
      ),
    );
  }
}
