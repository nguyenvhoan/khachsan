import 'package:booking/user/pages/home_page.dart';
import 'package:booking/user/pages/profile_page.dart';
import 'package:booking/user/pages/restaurant_page.dart';
import 'package:booking/user/pages/room_page.dart';
import 'package:booking/user/pages/voucher_page.dart';
import 'package:flutter/material.dart';

class NavigationMenu extends StatefulWidget {
  var account;

  
   NavigationMenu({super.key, required this.account});
   

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
   
   
  int myCurrentindex=0;
  void onTabTapped(int index) {
    setState(() {
      myCurrentindex = index;
    });
  }
  List<Widget> get page => [
    HomePage(),
    RoomPage(account:widget.account ,),
    VoucherPage(account: widget.account,),
    RestaurantPage(account: widget.account,),
    ProfilePage(account: widget.account,)
  ] ;
  
@override
  void initState() {
    super.initState();
    print('---------------------------------------------------------------');
    print('Đã đăng nhập với tài khoản '+ widget.account);
        print('---------------------------------------------------------------');

    
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