import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with TickerProviderStateMixin {
  bool _show = true;
  late AnimationController _controller;
  late Animation<Offset> _drawerAnimationMenu;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Animation duration
    );
    _drawerAnimationMenu = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  void _toggleDrawer() {
    setState(() {
      if (_controller.isDismissed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      _show = !_show;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: [
      if (_show == true)
        // Sidebar
        SlideTransition(
          position: _drawerAnimationMenu,
          child: Stack(
            children: [
              Container(
                width: 270, // Set sidebar width
                color: Color(0xFF1f1d2c),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sidebar header (Logo and App Name)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'assets/images/tn.JPG',
                              width: 200,
                              height: 200,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Employee Management',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sidebar items
                    // _buildDrawerItem(
                    //     0, 'Dashboard', Icons.dashboard, _toggleNotify),
                    // _buildDrawerItem(1, 'Reports', Icons.bar_chart),
                    // _buildDrawerItem(2, 'Calendar', Icons.calendar_today),
                    // _buildDrawerItem(3, 'Email', Icons.email),
                    // _buildDrawerItem(4, 'Profile', Icons.person),
                    // _buildDrawerItem(5, 'Settings', Icons.settings),
                    // Spacer(),
                    // _buildDrawerItem(
                    //     -1, 'Upgrade your account', Icons.upgrade),
                  ],
                ),
              ),
              Positioned(
                  right: -50,
                  top: 330,
                  left: 220,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF1f1d2c),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: _toggleDrawer,
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ))
            ],
          ),
        )
      else
        Material(
          color: Colors.transparent,
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 60,
                  ),
                  Positioned(
                      left: -20,
                      top: 330,
                      right: 10,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF2A2A40),
                          border: Border.all(
                            color: Colors.transparent,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: _toggleDrawer,
                                icon: Icon(
                                  Icons.keyboard_double_arrow_right_rounded,
                                  size: 35,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ))
                ],
              ),
            ],
          ),
        )
    ]));
  }
}
