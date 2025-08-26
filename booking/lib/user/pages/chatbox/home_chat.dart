import 'package:booking/user/pages/chatbox/chat_page.dart';
import 'package:booking/user/pages/chatbox/chat_service.dart';
import 'package:booking/user/pages/chatbox/user_tile.dart';
import 'package:flutter/material.dart';

class HomeChat extends StatelessWidget {
  HomeChat({super.key});

  final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Danh sách CSKH'),
        backgroundColor: const Color(0xff3CA0B6), // Màu nền của AppBar
        foregroundColor: Colors.white, // Màu chữ trong AppBar
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: chatService.getCSKHStream(),
      builder: (context, snapshot) {
        // Xử lý lỗi
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }

        // Xử lý trạng thái đang tải
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Kiểm tra dữ liệu
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        // Trả về danh sách người dùng
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    print(userData);
    print(userData['username']); // In ra email của người dùng
    return Container(
      margin: EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              nameCSKH: userData['username'] ?? '', // Cung cấp giá trị mặc định
            ),
          ),
        );
        },
        child: Row(
          children: [
            Icon(Icons.person, size: 40),
            SizedBox(width: 25,), // Biểu tượng người dùng
            Text(userData['username'] ?? 'No email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25
            ),),
            
            
          ],
        ),
      ),
    );
    // return UserTile(
    //   text: userData['username'] ?? 'No email', // Cung cấp giá trị mặc định
    //   onTap: () {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => ChatPage(
    //           nameCSKH: userData['username'] ?? '', // Cung cấp giá trị mặc định
    //         ),
    //       ),
    //     );
    //     print('User tapped: ${userData['username']}');
    //   },
    // );
  }
}