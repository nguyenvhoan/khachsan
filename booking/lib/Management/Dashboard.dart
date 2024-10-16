import 'package:booking/Management/Discount/DiscountListPage.dart';
import 'package:booking/Management/Map/map_screen.dart';
import 'package:booking/Management/Order/order_screen.dart';
import 'package:booking/Management/Restaurant.dart';
import 'package:booking/Management/Restaurant/TableType.dart';
import 'package:booking/Management/Restaurant/table_screen.dart';
import 'package:booking/Management/RoomType/room_screen.dart';
import 'package:booking/Management/Room/roomtype_screen.dart';
import 'package:booking/Management/Room_type.dart';
import 'package:booking/Management/item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:booking/Management/Service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AnimationController _controller;
  // Biến trạng thái để theo dõi nội dung hiện tại
  Widget _currentPage = const RoomScreen();

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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius:
                                      30, // Đặt bán kính cho CircleAvatar để tạo hình tròn
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: Image.asset(
                                      'asset/images/tn.JPG',

                                      fit: BoxFit
                                          .cover, // Đảm bảo hình ảnh lấp đầy hình tròn
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Employee Management',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 21, 142, 241),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Sidebar items

                          const Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: const Text(
                              'Hotel management',
                              style: TextStyle(
                                fontFamily: 'Candal',
                                color: Color(0xff3CA0B6),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SidebarItem(
                            title: 'Type Room',
                            icon: Icons.hotel,
                            onTap: () {
                              setState(() {
                                _currentPage = const RoomScreen();
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
                            title: 'Room',
                            icon: Icons.king_bed,
                            onTap: () {
                              setState(() {
                                _currentPage =
                                    RoomtypeScreen(); // Thay thế bằng trang Service của bạn
                              });
                              _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                            },
                          ),
                          SidebarItem(
                            title: 'Discount',
                            icon: Icons.discount,
                            onTap: () {
                              setState(() {
                                _currentPage =
                                    DiscountListPage(); // Thay thế bằng trang Service của bạn
                              });
                              _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                            },
                          ),
                          SidebarItem(
                            title: 'Map Room',
                            icon: Icons.map,
                            onTap: () {
                              setState(() {
                                _currentPage =
                                    MapScreen(); // Thay thế bằng trang Service của bạn
                              });
                              _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: const Text(
                              'Restaurant management',
                              style: TextStyle(
                                fontFamily: 'Candal',
                                color: Color(0xff3CA0B6),
                                fontSize: 15,
                              ),
                            ),
                          ),

                          SidebarItem(
                            title: 'Table Type',
                            icon: Icons.table_bar,
                            onTap: () {
                              setState(() {
                                _currentPage =
                                    Tabletype(); // Thay thế bằng trang Service của bạn
                              });
                              _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                            },
                          ),
                          SidebarItem(
                            title: 'Table ',
                            icon: Icons.table_restaurant_outlined,
                            onTap: () {
                              setState(() {
                                _currentPage =
                                    TableScreen(); // Thay thế bằng trang Service của bạn
                              });
                              _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: const Text(
                              'Manage bookings  ',
                              style: TextStyle(
                                fontFamily: 'Candal',
                                color: Color(0xff3CA0B6),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SidebarItem(
                            title: 'Order ',
                            icon: Icons.shopping_cart_outlined,
                            onTap: () {
                              setState(() {
                                _currentPage =
                                    OrderScreen(); // Thay thế bằng trang Service của bạn
                              });
                              _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                            },
                          ),
                          SidebarItem(
                            title: 'The booking has been arranged ',
                            icon: Icons.list_alt,
                            onTap: () {
                              setState(() {
                                _currentPage =
                                    OrderScreen(); // Thay thế bằng trang Service của bạn
                              });
                              _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                            },
                          ),
                        ],
                      ),
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
