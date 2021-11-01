import 'package:flutter/material.dart';
import 'package:flutterapps/Screens/ListingsScreen.dart';
import 'package:flutterapps/Screens/PhotoGallery.dart';
import 'package:flutterapps/Screens/ProfileScreen.dart';

class TabContainer extends StatefulWidget {
  const TabContainer({Key? key}) : super(key: key);

  @override
  _TabContainerState createState() => _TabContainerState();
}

class _TabContainerState extends State<TabContainer> {
  int _currentIndex = 0;
  List<Widget> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      ListingsScreen(),
      PhotoGallery(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.photo),
            label: 'Photo Gallery',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label:'Profile'
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) async {
    print(index);
    setState(() {
      _currentIndex = index;
    });
  }

}