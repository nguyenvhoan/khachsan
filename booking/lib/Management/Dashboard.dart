import 'package:appthoitiet/Management/Romm.dart';
import 'package:appthoitiet/Management/item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:appthoitiet/Management/Room_type.dart';
import 'package:appthoitiet/Management/Service.dart'; // Giả sử bạn có trang Service

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AnimationController _controller;
  // Biến trạng thái để theo dõi nội dung hiện tại
  Widget _currentPage = const RoomType();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _toggleDrawer() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 61, 165, 239),
                  Color.fromARGB(255, 22, 21, 55),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      _controller.isDismissed ? Icons.menu : Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: _toggleDrawer,
                  ),
                  const Text(
                    'Management',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                      width: 48), // Đảm bảo khoảng cách đều cho 2 bên
                ],
              ),
            ),
          ),
        ),
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double sidebarWidth = 270;

            return Stack(
              children: [
                // Main content area
                Positioned(
                  left: kIsWeb ? sidebarWidth * _controller.value : 0,
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: _currentPage, // Hiển thị nội dung hiện tại
                ),
                // Sidebar
                Positioned(
                  left: -sidebarWidth + sidebarWidth * _controller.value,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: sidebarWidth,
                    color: const Color(0xFF1f1d2c),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  'assets/images/tn.JPG',
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
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
                        SidebarItem(
                          title: 'Type Room',
                          icon: Icons.hotel,
                          onTap: () {
                            setState(() {
                              _currentPage = const RoomType();
                            });
                            _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                          },
                        ),
                        SidebarItem(
                          title: 'Service',
                          icon: Icons.star,
                          onTap: () {
                            setState(() {
                              _currentPage =
                                  const Service(); // Thay thế bằng trang Service của bạn
                            });
                            _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                          },
                        ),
                        SidebarItem(
                          title: 'Romm',
                          icon: Icons.king_bed,
                          onTap: () {
                            setState(() {
                              _currentPage =
                                  const Room(); // Thay thế bằng trang Service của bạn
                            });
                            _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
