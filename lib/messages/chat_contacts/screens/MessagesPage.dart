import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../constants/themeColors.dart';
import '../../chat/screens/mobile_chat_screen.dart';
import '../../group/screens/create_group_screen.dart';
import '../bloc/chat_contact_bloc.dart';
import '../group_bloc/group_chat_contact_bloc.dart';

class MessagesPage extends StatefulWidget {

  const MessagesPage({Key? key}) : super(key: key);
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {

  @override void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  return Stack(
    children: [
      Scaffold(
        extendBody: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text('Messages',style: TextStyle(color:Colors.white),),
          actions: [
            /*IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),*/
            PopupMenuButton(
                icon:const Icon(Icons.more_vert,color: Colors.grey,),
                itemBuilder: (context)=>[
                  PopupMenuItem(
                    child: const Text('Create Group'),
                    onTap: ()=> Future(()=>Navigator.pushNamed(context, CreateGroupScreen.routeName),),

                  )
                ])
          ],

        ),
        body:  Column(
          children: [
            BlocBuilder<GroupChatContactBloc,GroupChatContactState>(
                builder: (context, state) {
                  if(state is LoadingChatContactState){
                    return const Center(
                        child: CircularProgressIndicator());
                  }
                  else if(state is LoadedGroupChatContactState){
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.groupContacts.length,
                      itemBuilder: (context, index) {
                        var chatContactData = state.groupContacts[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context,
                                    MobileChatScreen.routeName,
                                    arguments: {
                                      'name':chatContactData.name,
                                      'id' :chatContactData.groupId,
                                      'isGroupChat':true,
                                      'profilePic':chatContactData.groupPic,
                                    }
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  title: Text(
                                    chatContactData.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      chatContactData.lastMessage,
                                      style: const TextStyle(fontSize: 15,color: Colors.grey),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        chatContactData.groupPic,
                                    ),
                                    radius: 30,
                                  ),
                                  trailing: Text(
                                    DateFormat.Hm().format(chatContactData.timeSent),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(color: dividerColor, indent: 85),
                          ],
                        );
                      },
                    );
                  }
                  else{
                    return Center(
                      child: Text('Error',style: TextStyle(color: Colors.black),),
                    );
                  }

                }
            ),
            BlocBuilder<ChatContactBloc,ChatContactState>(
              builder: (context, state) {
                if(state is LoadingChatContactState){
                  return const Center(
                      child: CircularProgressIndicator());
                }
                else if(state is LoadedChatContactState){
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.chatContacts.length,
                    itemBuilder: (context, index) {
                      var chatContactData = state.chatContacts[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                MobileChatScreen.routeName,
                                arguments: {
                                  'name':chatContactData.name,
                                  'id' :chatContactData.contactId,
                                  'isGroupChat':false,
                                  'profilePic':chatContactData.profilePic,
                                }
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                title: Text(
                                  chatContactData.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    chatContactData.lastMessage,
                                    style: const TextStyle(fontSize: 15,color: Colors.grey),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                     chatContactData.profilePic
                                  ),
                                  radius: 30,
                                ),
                                trailing: Text(
                                  DateFormat.Hm().format(chatContactData.timeSent),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: dividerColor, indent: 85),
                        ],
                      );
                    },
                  );
                }
                else{
                  return Center(
                    child: Text('Error',style: TextStyle(color: Colors.black),),
                  );
                }

              }
              ),
          ],
        )

          ),
    ],
  );
  }
}
