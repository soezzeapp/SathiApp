import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sathiclub/authentication/repository/firebaseAuthApi.dart';
import 'package:sathiclub/messages/call/screens/call_pickup_screen.dart';


import '../constants/themeColors.dart';
import '../like/pages/GridPage.dart';
import '../home/pages/HomePage.dart';
import '../matches/pages/MatchPage.dart';
import '../matches/pages/MatchRoutePage.dart';
import '../messages/chat_contacts/screens/MessagesPage.dart';
import '../profile/ProfilePage.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage>with WidgetsBindingObserver {
  int currentIndex = 0;
  final screens =[
    const HomePage(),
    const MatchRoutePage(),
    const MessagesPage(),
    const ProfilePage(),
    Center(
        child: Container(child:Text('BuildOnProgress'))),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        FirebaseAuthApi().updateOnlineStateAndActiveDate(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        FirebaseAuthApi().updateOnlineStateAndActiveDate(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallPickupScreen(
      scaffold: Scaffold(
            body:IndexedStack(
              index: currentIndex,
              children: screens,
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
              ),
              child: SizedBox(
                height: 100,
                    child: BottomNavigationBar(
                      currentIndex: currentIndex,
                      onTap:(index){
                        setState(()=> currentIndex= index);
                      },
                      type:BottomNavigationBarType.fixed,
                      backgroundColor: Colors.black,
                      unselectedItemColor: Colors.white,
                      selectedItemColor: themeButtonColor,
                      unselectedFontSize: 14,
                      iconSize: 24,
                      selectedFontSize: 16,
                      //showSelectedLabels: false,
                      items: [
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ImageIcon(
                              const AssetImage("assets/images/home.png",),
                              color: currentIndex==0?themeButtonColor:Colors.white,
                            ),
                          ),
                          label: 'Home',
                          //backgroundColor: Colors.black,
                        ),
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ImageIcon(
                              const AssetImage("assets/images/heart.png"),
                              color:currentIndex==1?themeButtonColor: Colors.white,
                            ),
                          ),
                          label: 'Matches',
                          //backgroundColor: Colors.black,
                        ),
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ImageIcon(
                              const AssetImage("assets/images/inbox.png"),
                              color: currentIndex==2?themeButtonColor: Colors.white,
                            ),
                          ),
                          label: 'Inbox',
                          //backgroundColor: Colors.black,
                        ),
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ImageIcon(
                              const AssetImage("assets/images/profile.png"),
                              color: currentIndex==3?themeButtonColor: Colors.white,
                            ),
                          ),
                          label: 'Profile'
                          //backgroundColor:Colors.black,
                        ),
                        BottomNavigationBarItem(
                          icon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.diamond,
                                color:currentIndex==4?themeButtonColor: Colors.white,
                                size: 28,
                              )
                            /*ImageIcon(
                              const AssetImage("assets/images/heart.png"),
                              color:currentIndex==1?themeButtonColor: Colors.white,
                            ),*/
                          ),
                          label: 'Picks',
                          //backgroundColor: Colors.black,
                        ),
                      ],
                    )
                ),
              ),
            )
       
        );

  }


}
