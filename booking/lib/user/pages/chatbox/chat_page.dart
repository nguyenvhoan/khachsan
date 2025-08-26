import 'package:booking/user/pages/chatbox/auth_service.dart';
import 'package:booking/user/pages/chatbox/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {
   ChatPage({super.key, required this.nameCSKH});
  final String nameCSKH;




final TextEditingController messageController = TextEditingController();
final ChatService chatService = ChatService();
final AuthService authService = AuthService();
FirebaseFirestore firestore = FirebaseFirestore.instance;
void sendMessage() async{
  if(messageController.text.isNotEmpty){
    //get current user info
    await chatService.sendMessage(messageController.text, nameCSKH, authService.getCurrentUser()!.email!);
    messageController.clear();
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameCSKH),
        backgroundColor: const Color(0xff3CA0B6), // Màu nền của AppBar
        foregroundColor: Colors.white, // Màu chữ trong AppBar
      ),
      body: Column(
        children: [
          //display all messages
          Expanded(child: _buildMessageList()), // List of messages
          //user input
          Container(
            margin: EdgeInsets.only(left: 10, bottom: 5),
            child: _buildUserInput()
            ),
        ],
      ),
    );
  }
 String convertDateFormat(String inputDate) {
  // Chuyển đổi chuỗi thành DateTime
  DateTime dateTime = DateTime.parse(inputDate);

  // Định dạng lại thành "giờ:phút ngày/tháng/năm"
  return DateFormat('H:mm d/M/y').format(dateTime);
}
  Widget _buildMessageList(){
    String senderId=authService.getCurrentUser()!.email!;
    return StreamBuilder(
      stream: chatService.getMessages(senderId, nameCSKH), 
      builder: (context,snapshot){
        //error
        if(snapshot.hasError){
          return const Center(child: Text('Error'));
        }
        //loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        //return list view
        return ListView(
          children: snapshot.data!.docs.map<Widget>((messageData) {
            final message = messageData.data() as Map<String, dynamic>;
            return Container(
              
              child: Column(
                crossAxisAlignment:senderId==message['senderEmail']? CrossAxisAlignment.end :CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      convertDateFormat(message['timestamp'].toDate().toString()),
                      style: TextStyle(
                        color: Colors.grey, 
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:senderId==message['senderEmail']? const Color.fromARGB(255, 218, 210, 210) :const Color.fromARGB(255, 136, 197, 247),

                    ),
                    margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                           Text(message['senderEmail'],
                           style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                              color: Colors.black
                           ),),
                           Text(message['message'],
                           style: TextStyle(
                            fontSize: 16,
                              color: Colors.black
                           ),)
                          ]),
                    ),
                  )
                ],
              ),
            );
            
            // return ListTile(
            //   title: Text(message['senderEmail']),
            //   subtitle: Text(message['message'],
            //   style: TextStyle(
            //     color:senderId==message['senderEmail']? Colors.red : Colors.black,
            //   ),),
              
            // );
          }).toList(),
        );
      }
    );
  }
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Text(data['message']);
  }
  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            decoration: const InputDecoration(
              hintText: 'Type a message',
              border: OutlineInputBorder(),
            ), 
            )
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 53, 113, 218),
              border: Border.all(
                color: Colors.grey,
                width: 1,
                ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: IconButton(
                onPressed: sendMessage, 
                icon: Icon(Icons.arrow_right_alt_outlined),
                ),
            ),
          )
      ],
    );
  }
}