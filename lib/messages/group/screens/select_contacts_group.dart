import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathiclub/messages/group/bloc/group_bloc.dart';

import '../../../constants/themeColors.dart';


class SelectContactsGroup extends StatefulWidget {
  const SelectContactsGroup({Key? key}) : super(key: key);

  @override
  _SelectContactsGroupState createState() => _SelectContactsGroupState();
}

class _SelectContactsGroupState extends State<SelectContactsGroup> {
  List<int>selectedContactsIndex = [];
  void selectContact(int index,){
    if(selectedContactsIndex.contains(index)){
      selectedContactsIndex.remove(index);
    }
    else{
      selectedContactsIndex.add(index);
    }
  }
  void initState() {
    super.initState();
    BlocProvider.of<GroupBloc>(context).add(GetAllUsersGroupEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc,GroupState>(
      builder: (context,state){
        if(state is LoadedGroupState){
          return Expanded(
              child:ListView.builder(
                  itemCount:state.users.length ,
                  itemBuilder:(context,index) {
                    final contact = state.users[index];
                    return InkWell(
                        onTap:(){setState(() {
                          selectContact(index);
                        });},
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                              title: Text(contact.name,
                                style: const TextStyle(fontSize: 18,color: Colors.white,),
                              ),
                              leading: selectedContactsIndex.contains(index)?
                               const Icon(Icons.done,color: themeButtonColor,):null
                          ),
                        ));
                  }));
        }else{
          return Container();
        }

      }
    );

  }
}
