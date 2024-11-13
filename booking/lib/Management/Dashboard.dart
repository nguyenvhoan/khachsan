import 'package:booking/Management/Discount/DiscountListPage.dart';
import 'package:booking/Management/Map/map_screen.dart';
import 'package:booking/Management/Order/order_screen.dart';
import 'package:booking/Management/Restaurant.dart';
import 'package:booking/Management/Restaurant/TableType.dart';
import 'package:booking/Management/Restaurant/table_screen.dart';
import 'package:booking/Management/RoomType/room_screen.dart';
import 'package:booking/Management/Room/roomtype_screen.dart';
import 'package:booking/Management/Room_type.dart';
import 'package:booking/Management/ThongKe/ThongKe.dart';
import 'package:booking/Management/ThongKe/doanhthu.dart';
import 'package:booking/Management/bookingHistory/booking_history_user.dart';
import 'package:booking/Management/item.dart';
import 'package:booking/Management/role/create_account_admin.dart';
import 'package:booking/Management/role/create_role.dart';
import 'package:booking/model/database_service.dart';
import 'package:booking/user/pages/intro_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:booking/Management/Service.dart';

class Dashboard extends StatefulWidget {
   Dashboard({super.key, required this.role});
  String role;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AnimationController _controller;
  // Biến trạng thái để theo dõi nội dung hiện tại
  Widget _currentPage = const RoomScreen();
  final DatabaseService _databaseService =DatabaseService();

  @override
  void initState() {  
    _databaseService.deleteExpiredUsers();
    _databaseService.deleteExpiredtable();
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }
void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
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
          automaticallyImplyLeading:false,
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
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: GestureDetector(
                                    onTap: () async{
                                     try {
                                        await FirebaseAuth.instance.signOut();
                                        print("Đăng xuất thành công");
                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>Landing()));
                                      } catch (e) {
                                        print("Lỗi đăng xuất: $e");
                                     }
                                  
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 5, bottom: 5, right: 10,left: 10),
                                      child: Text('Log Out')),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Sidebar items

                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
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
                               if (widget.role == 'owner' ) {
                                setState(() {
                                  _currentPage = const RoomScreen();
                                });
                                _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                              } else {
                                _showSnackBar(context, 'Bạn không có quyền truy cập vào mục này.');
                              }
                              _toggleDrawer(); 
                              // Đóng sidebar sau khi chọn mục
                            },
                           
                          ),
                          SidebarItem(
                            title: 'Service',
                            icon: Icons.star,
                            onTap: () {
                              if (widget.role == 'owner' ) {
                                setState(() {
                                  _currentPage = const Service();
                                });
                                _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                              } else {
                                _showSnackBar(context, 'Bạn không có quyền truy cập vào mục này.');
                              }
                              _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                            },
                          ),
                          SidebarItem(
                            title: 'Room',
                            icon: Icons.king_bed,
                            onTap: () {
                              if (widget.role == 'owner' ) {
                                setState(() {
                                  _currentPage = const RoomScreen();
                                });
                                _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                              } else {
                                _showSnackBar(context, 'Bạn không có quyền truy cập vào mục này.');
                              }
                              _toggleDrawer();// Đóng sidebar sau khi chọn mục
                            },
                          ),
                          SidebarItem(
                            title: 'Discount',
                            icon: Icons.discount,
                            onTap: () {
                              if (widget.role == 'owner' ) {
                                setState(() {
                                  _currentPage =  DiscountListPage();
                                });
                                _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                              } else {
                                _showSnackBar(context, 'Bạn không có quyền truy cập vào mục này.');
                              }
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
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              'Account Management',
                              style: TextStyle(
                                fontFamily: 'Candal',
                                color: Color(0xff3CA0B6),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SidebarItem(
                            title: 'Create Account',
                            icon: Icons.account_balance,
                            onTap: () {
                               if (widget.role == 'owner' ) {
                                setState(() {
                                  _currentPage = const CreateAccountAdmin();
                                });
                                _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                              } else {
                                _showSnackBar(context, 'Bạn không có quyền truy cập vào mục này.');
                              }
                              _toggleDrawer(); 
                              // Đóng sidebar sau khi chọn mục
                            },
                           
                          ),
                          SidebarItem(
                            title: 'Role',
                            icon: Icons.roller_shades,
                            onTap: () {
                               if (widget.role == 'owner' ) {
                                setState(() {
                                  _currentPage = const CreateRole();
                                });
                                _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                              } else {
                                _showSnackBar(context, 'Bạn không có quyền truy cập vào mục này.');
                              }
                              _toggleDrawer(); 
                              // Đóng sidebar sau khi chọn mục
                            },
                           
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
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
                            padding: EdgeInsets.all(15.0),
                            child: Text(
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
                                    BookingHistoryUser(); // Thay thế bằng trang Service của bạn
                              });
                              _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                            },
                          ),
                          SidebarItem(
                            title: 'Thong ke ',
                            icon: Icons.chalet,
                            onTap: () {
                              setState(() {
                                _currentPage =
                                    Thongke(); // Thay thế bằng trang Service của bạn
                              });
                              _toggleDrawer(); // Đóng sidebar sau khi chọn mục
                            },
                          ),
                          SidebarItem(
                            title: 'Thong ke ',
                            icon: Icons.chalet,
                            onTap: () {
                              setState(() {
                                _currentPage =
                                    Doanhthu(); // Thay thế bằng trang Service của bạn
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
