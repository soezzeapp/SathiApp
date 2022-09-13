import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sathiclub/authentication/pages/12_signup_page.dart';
import 'package:sathiclub/authentication/pages/0_frontPage.dart';
import 'package:sathiclub/home/bloc/selected_user_video_view_bloc/selected_user_video_view_bloc.dart';
import 'package:sathiclub/messages/chat/bloc/message_reply_bloc/message_reply_bloc.dart';
import 'package:sathiclub/messages/chat/bloc/receiver_user_bloc/receiver_user_bloc.dart';
import 'package:sathiclub/messages/chat_contacts/bloc/chat_contact_bloc.dart';
import 'package:sathiclub/messages/repository/chat_repository.dart';
import 'package:sathiclub/profile/bloc/profile_video_bloc.dart';
import 'package:sathiclub/route/RoutePage.dart';
import 'package:sathiclub/router.dart';
import 'package:sathiclub/settings/chat_setting/chat_setting_bloc.dart';
import 'authentication/bloc/authentication_bloc.dart';
import 'home/bloc/home_bloc.dart';
import 'home/bloc/view_bloc/view_bloc.dart';
import 'home/provider/CardProvider.dart';
import 'like/bloc/grid_bloc.dart';
import 'matches/bloc/match_bloc.dart';
import 'messages/call/bloc/call_bloc.dart';
import 'messages/chat/bloc/chat_bloc.dart';
import 'messages/chat_contacts/group_bloc/group_chat_contact_bloc.dart';
import 'messages/group/bloc/group_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context)=>CardProvider(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc()..add(CheckAuthenticationStageEvent(uid:'currentUser'))),
          BlocProvider<ViewBloc>(create: (_) => ViewBloc()..add(GetViewEvent())),
          BlocProvider<HomeBloc>(
              create: (_) => HomeBloc()),
          BlocProvider<GridBloc>(
              create: (_) => GridBloc()),
          BlocProvider<MatchBloc>(
              create: (_) => MatchBloc()),
          BlocProvider<ChatContactBloc>(create: (_) =>
          ChatContactBloc()..add(WatchChatContactsEvent())),
          BlocProvider<GroupChatContactBloc>(create: (_) =>
          GroupChatContactBloc()..add(WatchGroupChatContactsEvent())),
          BlocProvider<ChatBloc>(create: (_) => ChatBloc()),
          BlocProvider<ReceiverUserBloc>(create: (_) => ReceiverUserBloc()),
          BlocProvider<MessageReplyBloc>(create: (_) => MessageReplyBloc()),
          BlocProvider<CallBloc>(create: (_) => CallBloc()..add(WatchCallEvent())),
          BlocProvider<GroupBloc>(create: (_) => GroupBloc()),
          BlocProvider<ChatSettingBloc>(create: (_) => ChatSettingBloc()),
          BlocProvider<ProfileVideoBloc>(create: (_) => ProfileVideoBloc()),
          BlocProvider<SelectedUserVideoViewBloc>(create: (_) => SelectedUserVideoViewBloc())
         ],
        child :MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute:(settings) =>generateRoute(settings),
        home: BlocBuilder<AuthenticationBloc,AuthenticationState>(
          builder: (context,state) {
            if(state is AuthenticatedState){
              return const RoutePage();
            }else{
              return MyFrontPage();
            }

          }
        ),
      )),
    );
  }
}


