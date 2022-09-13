
import 'package:flutter/material.dart';

import '../../like/pages/GridPage.dart';
import 'MatchPage.dart';

class MatchRoutePage extends StatefulWidget {
  const MatchRoutePage({Key? key}) : super(key: key);

  @override
  _MatchRoutePageState createState() => _MatchRoutePageState();
}

class _MatchRoutePageState extends State<MatchRoutePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
          backgroundColor: Colors.black,
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: "Matches",
              ),
              Tab(
                text: 'Likes',
              ),
            ],
          ),
        ),
        body: TabBarView(
                      children: <Widget>[
                       MatchPage(),
                       GridPage(),
                      ],
                    ),

      ),
      length: 2,
      initialIndex: 0,
    );
  }


}
