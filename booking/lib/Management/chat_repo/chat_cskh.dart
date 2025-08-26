import 'package:booking/Management/chat_repo/chat_page.dart';
import 'package:booking/user/pages/chatbox/chat_page.dart';
import 'package:booking/user/pages/chatbox/chat_service.dart';
import 'package:booking/user/pages/chatbox/user_tile.dart';
import 'package:flutter/material.dart';

class ChatCskh extends StatelessWidget {
  ChatCskh({super.key,required this.nameCSKH});
  String nameCSKH;
  final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: chatService.getUserStream(),
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
    print(userData['email']); // In ra email của người dùng
    return Container(
      child: GestureDetector(
        onTap: (){
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPageCSKH(
              email: userData['email'] ?? '',
              nameCSKH: nameCSKH, // Cung cấp giá trị mặc định
            ),
          ),
        );
        print('User tapped: ${userData['email']}');
        },
        child: Text(userData['email'] ?? 'No email'),
      ),
  
        
      
    );
  }
}