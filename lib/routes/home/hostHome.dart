import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/routes/_router.dart';


class HostHomePage extends StatefulWidget {
  HostHomePageState createState() => HostHomePageState();
}

class HostHomePageState extends State<HostHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Placeholder(color: Colors.purple)
    );
  }
}









class HostRouter extends StatefulWidget {
  @override
  HostRouterState createState() => HostRouterState();
}

class HostRouterState extends State<HostRouter> {
  int _navIndex = 0;
  ScrollController _scrollController = ScrollController();
  final _bottomNavBarKey = GlobalKey<ScaffoldState>();

  static const TextStyle navStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final _navigationOptions = [Loading(), HostHomePage(), HostHomePage(), HostHomePage()];

  @override
  void initState() {
    _navIndex = 1;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _bottomNavBarKey,
      drawer: HumanatyDrawer(),
      bottomNavigationBar: bottomNavBar(),
      body: _navigationOptions[_navIndex]
    );
  }

  Widget bottomNavBar(){
    return BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: selectNav,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.menu), title: Text("Menu")),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Map")),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), title: Text("My Events")),
        ],
        selectedItemColor: Pallete.humanGreen,
      );
  }
  void selectNav(int index) {
    print(index);
    setState(() {
      index != 0 ? _navIndex = index : _bottomNavBarKey.currentState.openDrawer();    
    });
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }
}