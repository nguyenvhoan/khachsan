import 'package:booking/model/database_service.dart';
import 'package:booking/user/pages/detail_voucher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PointUser extends StatefulWidget {
     PointUser({super.key, required this.account});

  @override
  State<PointUser> createState() => _PointUserState();
  var account;
}

class _PointUserState extends State<PointUser> {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      Map<String,dynamic>? user;
     List<Map<String,dynamic>> lst=[];

  double _pointValue = 0.0;
  double _pointUsed = 0.0;
  final int _currentIndex = 5;
  final DatabaseService _databaseService=DatabaseService();
  Future<void> getUserById(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await db.collection('user').doc(id).get();

      if (documentSnapshot.exists) {
        setState(() {
          user = documentSnapshot.data() as Map<String, dynamic>?; 
      _pointValue=user!['score'].toDouble();
      _pointUsed=user!['scoreUsed'].toDouble();
  
        });
      } else {
        print('Tài liệu không tồn tại');
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu: $e');
    }
  } 
  
  @override
  void initState() {
    super.initState();
    getUserById(widget.account);
  }

 // Initial slider value
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    setState(() {
    getUserById(widget.account);
    });
    return Scaffold(
      appBar: AppBar(
          
          centerTitle: true,
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);},
             child: Image.asset( 'asset/images/icons/icon_back.png')),
          title:const Text(
                'Loyal Customer',
                style: TextStyle(
                  fontFamily: 'Candal',
                  color: Color(0xff3CA0B6),
                  fontSize: 32  ,
                ),
              ),
      ),
      body:user!=null ? Container(
        decoration:const  BoxDecoration(
          gradient: LinearGradient(
                colors: [
                Color(0xffFFFFFF), // Màu bắt đầu
                Color(0xff999999), // Màu kết thúc
              ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        ),
        child: Column(
        
          children:[ 
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
              gradient:const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xffFFFFFF), // Màu bắt đầu
                  Color(0xff999999), // Màu kết thúc
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: 
              [
                 Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child:  Text(user!['name'],
                  style:const TextStyle(
                    fontFamily: 'Candal',
                    color: Color(0xff3CA0B6),
                    fontSize: 25
                  ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.2), 
                      spreadRadius: 5,
                      blurRadius: 7, 
                      offset: const Offset(0, 3), 
                     ),
                    ],             
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[ 
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text('Spending',
                          style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 18),),
                        ),
                         Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text:_pointUsed.toInt().toString(),
                                style:const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                                ),
                                ),
                                  const TextSpan(text:' / 10tr',
                                style:TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                                ),
                                ),
                              ]
                            ),
                          )
                        ),
                        Row(
                          children:[ 
                            SizedBox(
                              height: 10,
                              width: size.width/1.5,
                           child:  SliderTheme( 
                          data:const SliderThemeData(
                            activeTickMarkColor:Colors.red,
                            thumbColor: Colors.red,
                            overlayColor: Colors.red,
                          activeTrackColor: Colors.red,
                           valueIndicatorColor: Colors.red, 
                          ),
                          child: Slider(
                            value: _pointUsed,
                            min: 0.0,
                            max: 10000000.0,
                            divisions: 100,
                            label: _pointUsed.round().toString(), onChanged: (double value) {  },
                          ),
                          ),
                            ),
                          const Icon(Icons.shop, color: Colors.blueAccent,)
                          ]
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15, top:10),
                          child: Text('Earn point',
                          style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 18),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15,),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text:'${_pointValue.toInt()} points',
                                style:const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                                ),
                                ),
                                  
                              ]
                            ),
                          )
                        ),
                        Row(
                          children:[ 
                            SizedBox(
                              height: 20,
                              width: size.width/1.5,
                           child:  SliderTheme( 
                          data:const SliderThemeData(
                            activeTickMarkColor:Colors.red,
                            thumbColor: Colors.red,
                            overlayColor: Colors.red,
                          activeTrackColor: Colors.red,
                           valueIndicatorColor: Colors.red, 
                          ),
                          child: Slider(
                            value: _pointValue,
                            min: 0.0,
                            max: 100000000.0,
                            divisions: 100,
                            label: _pointValue.round().toString(), onChanged: (double value) {  },
                          ),
                          ),
                            ),

                          ]
                        ),
                      ]
                    ),
                  ),
                ),
                 const SizedBox(height: 20,)
        
                
              ],
            ),
          ),
         const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('Offers from Otelia',
            style: TextStyle(
              fontFamily: 'Candal',
              fontSize: 20
            ),),
          ),
           Expanded(
                child: StreamBuilder(
                      stream: db.collection('Discount').snapshots(),
                     builder: (context, snapshot){  
                        if(snapshot.hasData){
                            return SingleChildScrollView( 
                              scrollDirection:Axis.vertical,   
                              child: Column(
                                children: snapshot.data!.docs.map<Widget>((documentSnapshot) {
                                  
                                  Map<String, dynamic> thisItem = documentSnapshot.data();
                                    print('data              '+thisItem['img']);
                                    return Container(
                                      
                                       margin: const EdgeInsets.only(right:30,left:30,bottom:10, top:10),
                                    decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2), 
                                        spreadRadius: 5,
                                        blurRadius: 7, 
                                        offset: const Offset(0, 3), 
                                      ),
                                    ],                                
                                  ), 
                                  child: Container(                              
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,                           
                                        children: [
                                          Container(                                      
                                              width : size.width / 2.8, 
                                            
                                              height:size.height/6,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                image: thisItem['img'] != null
                                                    ? DecorationImage(
                                                        image: NetworkImage(thisItem['img']),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : null,
                                                color: Colors.transparent,
                                              ),
                                              child: thisItem['img'] == null
                                                  ? const Icon(Icons.image,
                                                      size: 10)
                                                  : null,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:[
                                                   
                                                   const Text('Discount',
                                                  style: TextStyle(
                                                    fontFamily: 'Candal',
                                                    color: Color(0xff57A5EC),
                                                    fontSize: 25,
                                                    
                                                  ),overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,softWrap: true,
                                                  ),
                                                   const SizedBox(height: 20,),
                                                
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(text: documentSnapshot['point'].toString(),
                                                        style:const  TextStyle(color: Colors.red, fontFamily: 'Candal')),
                                                        const TextSpan(text: ' VND',style: TextStyle(color: Colors.black,
                                                        fontFamily: 'Candal')),
                                                      ]
                                                    )
                                                    ),
                                                      const SizedBox(height: 20,),

                                                    Row(
                                                      children: [
                                                        Image.asset('asset/images/icons/carbon_condition-point.png'),
                                                        Expanded(child: Text(documentSnapshot['point'].toString(),
                                                        style: const TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),)),
                                                        GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              getUserById(widget.account);
                                                            });
                                                            List<dynamic> dynamicList = user!['voucher'] ?? [];
                                                                lst=List<Map<String, dynamic>>.from(dynamicList);

                                                            Map<String, dynamic> vou ={
                                                              'id':documentSnapshot['id'],
                                                              'img':documentSnapshot['img'],
                                                              'introduc':documentSnapshot['introduc'],
                                                              'name':documentSnapshot['name'],
                                                              'point':documentSnapshot['point'],
                                                            };
                                                            lst.add(vou);
                                                            _databaseService.exchangePoint(widget.account, documentSnapshot['point'], lst, context,
                                                            (){
                                                              getUserById(widget.account);
                                                            });
                                                            getUserById(widget.account);
                                                            
                                                          },
                                                          child: Container(
                                                            decoration:const BoxDecoration(
                                                              color: Colors.grey
                                                            ),
                                                            child:const Padding(
                                                              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                                              child: Text('Exchange point',
                                                              style: TextStyle(
                                                                fontSize: 12
                                                              ),),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                   
                                                  const SizedBox(height: 5,),
                                                 
                                                
                                              
                                                ]
                                              ),
                                            )
                                                ] 
                                            ),
                                    ),
                                      
                                    
                                  ),
                                );
                                }).toList()
                                 
                              ),
                            );
                        }
                        else
                        {
                         return const Center(child: CircularProgressIndicator());
                        }
                        
                     }
                     
                     ),
              ),
        
          ]
        ),
      ):const Center(
                      child: CircularProgressIndicator(), // Hoặc bạn có thể thay thế bằng một widget khác thông báo lỗi

      )
    );
  }
}