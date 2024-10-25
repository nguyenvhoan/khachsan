  import 'package:another_carousel_pro/another_carousel_pro.dart';
  import 'package:booking/user/pages/room_page.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/foundation.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_image_slider/carousel.dart';

  class HomePage extends StatelessWidget {
    HomePage({super.key, required this.account, required this.goToRoomTab});
    var account;
    final Function goToRoomTab;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery.sizeOf(context);
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Chữ "Otelia" nằm ở góc trái
              const Text(
                'Otelia',
                style: TextStyle(
                  fontFamily: 'Candal',
                  color: Color(0xff3CA0B6),
                  fontSize: 35,
                ),
              ),
              // Biểu tượng nằm ở góc phải
              GestureDetector(
                child: Container(
                  color: Colors.white,
                  child: Image.asset(
                    'asset/images/icons/tb.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: EdgeInsets.all(20 ),
                height: size.height * 0.2,
                width: size.width,
                child: AnotherCarousel(
                images: const [
                  AssetImage("asset/images/icons/background.png"),
                  NetworkImage(
                      "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_640.jpg"),
                  AssetImage("asset/images/icons/background.png"),
                  NetworkImage(
                      "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_640.jpg")
                ],
                dotSize: 6,
                indicatorBgPadding: 0.0,
                showIndicator: false,
                borderRadius: true,
              ),
                ),
            Container(
              margin: EdgeInsets.all(15),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Popular ',
                          style: TextStyle(
                            fontFamily: 'Candal',
                            fontSize: 20,
                            color: Color(0xff57A5EC),
                          ),
                        ),
                        Text(
                          'Room',
                          style: TextStyle(
                            fontFamily: 'Candal',
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'See All',
                      style: TextStyle(color: Color(0xff57A5EC), fontSize: 15),
                    )
                  ]),
            ),
            StreamBuilder(
                stream: db.collection('RoomType').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        child: Row(
                            children:
                                snapshot.data!.docs.map<Widget>((documentSnapshot) {
                          Map<String, dynamic> thisItem =
                              documentSnapshot.data() as Map<String, dynamic>;
          
                          return Container(
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            width: size.width / 2.3,
                            height: size.height / 3.5,
                            child: Container(
                              margin: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: size.width / 3,
                                    height: size.height / 9,
                                    decoration: BoxDecoration(
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
                                            size:
                                                50) // Thay đổi kích thước icon nếu cần
                                        : null,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            documentSnapshot['number'],
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontFamily: 'Candal',
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                                'asset/images/icons/Star.png'),
                                            Text('  4.8')
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Text(
                                    documentSnapshot['price'].toString() +
                                        "/ night",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Color(0xff57A5EC),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      goToRoomTab();
                                    },
                                    child: Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'View More',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        height: 26,
                                        width: 127,
                                        decoration: BoxDecoration(
                                            color: Color(0xff1A4368),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList()),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
                Container(
                  margin: EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
                  child: Row(
                    children: [
                  Container(
                        margin:const EdgeInsets.all(10),
                        child: Image.asset('asset/images/icons/hinhtumlum.png')),
                    const Expanded(
                      child: Column(
                      children: [
                        Text(
                        '‘Welcome to Otelia’',
                      style: TextStyle(
                        fontFamily:   'Candal',
                        color: Color(0xff3CA0B6),
                        fontSize: 16,
                      ),
                      ),
                      Text(
                        'Where high food meets cozy atmosphere!',
                        maxLines: 2,
                        textAlign:  TextAlign.center,
                      style: TextStyle(
                        fontFamily:   'Candal',
                        color: Color(0xff1A4368),
                        fontSize: 16,
                        
                        
                      ),
                      ),
                      Text("At Otelia, indulge in exquisite dishes made from the freshest, locally sourced ingredients. Our talented chefs combine traditional techniques with modern flair, creating a menu that delights the senses. Experience exceptional dining in a luxurious and cozy setting, perfect for any occasion. Let us make your meal unforgettable.",
                            maxLines: 6,
                            textAlign: TextAlign.center,
                            style:  TextStyle(fontSize: 13),
                            ),
                      ],
                      )
                    )
                    
                    ],
                  ),
                ),
          ],
          
          ),
        ),
      );
    }
  }
