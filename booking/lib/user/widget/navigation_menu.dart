import 'package:booking/user/pages/home_page.dart';
import 'package:booking/user/pages/restaurant_page.dart';
import 'package:booking/user/pages/room_page.dart';
import 'package:flutter/material.dart';

class NavigationMenu extends StatefulWidget {
  var account;

  
   NavigationMenu({super.key});
   

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}
bool themeColor = false;
dynamic colorTheme() {
  if (themeColor) {
    return Colors.black;
  } else {
    return Colors.blue[200];
  }
}
class _NavigationMenuState extends State<NavigationMenu> {
   late var account;
   
  int myCurrentindex=0;
  List<Widget> get page => [
    HomePage(),
    RoomPage(),
    RoomPage(),
    RestaurantPage(),
  ] ;
  
@override
  void initState() {
    super.initState();
    account = widget.account;
    print(account);
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor:  Colors.white,
      bottomNavigationBar: Container(
  
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), 
           spreadRadius: 5,
           blurRadius: 7, 
             offset: Offset(0, 3), 
          ),
        ],
      ),
  child: ClipRRect(
    
    
    
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: myCurrentindex,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xff57A5EC),
        onTap: (index) {
          setState(() {
            myCurrentindex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.door_back_door),
            label: 'Room',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.percent_outlined),
            label: 'Discount',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Restaurant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            
          ),
        ],
      ),
    ),
  ),

      body: page[myCurrentindex],
    );
  }
}