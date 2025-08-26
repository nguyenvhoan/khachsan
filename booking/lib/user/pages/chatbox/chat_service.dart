import 'package:booking/user/pages/chatbox/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

 class ChatService {
  // This class is responsible for managing chat-related operations.
  // It can include methods for sending messages, receiving messages,
  // and managing chat history.

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // List<Map<String,dynamic> = [
  //       {
  //         'email': 'test@gmail.com',
  //         'id':'...'
  //       },
  //       {
  //         'email': 'test@gmail.com',
  //         'id':'...'
  //       }
  // ]


Stream<List<Map<String, dynamic>>> getCSKHStream() {
  return _firestore.collection('Admin').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final user = doc.data() as Map<String, dynamic>;
      return user['role'] == 'CSKH' ? user : null;
    }).where((user) => user != null).cast<Map<String, dynamic>>().toList(); // Lọc bỏ null và ép kiểu
  });
}
Stream<List<Map<String,dynamic>>> getUserStream() {
  return _firestore.collection('user').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
    final user = doc.data();
    return user;
    }).toList();
  });
}

  Future<void> sendMessage(String message , String receivedEmail, String senterEmail) async{
    //get current user info
      
      final Timestamp timestamp = Timestamp.now();
    //create a new message
    Message newMessage = Message(
      senderId: 'currentUserId', 
      senderEmail: senterEmail, 
      receiverId: receivedEmail, 
      message: message, 
      timestamp: timestamp
      );
    //construct chat room id for two users 
    List<String> ids = [senterEmail, receivedEmail];
    ids.sort();
    String chatRoomId = ids.join('_');
    print(chatRoomId);
    //add new message to database
    await _firestore
    .collection('chat_room')
    .doc(chatRoomId)
    .collection('messages')
    .add(newMessage.toMap());
  
  }
  
  Stream<QuerySnapshot> getMessages(String userEmail, otherEmail) {
      List<String> ids = [userEmail, otherEmail];
      ids.sort();
      String chatRoomId = ids.join('_');
       print(chatRoomId);
      return _firestore
          .collection('chat_room')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots();
      
    }
  void receiveMessage() {
    // Logic to receive a message
  }

  void getChatHistory() {
    // Logic to retrieve chat history
  }
}