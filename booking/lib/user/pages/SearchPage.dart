import 'package:booking/user/pages/detail_page.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> services; // Danh sách dịch vụ được truyền vào
  String account;
  SearchPage({Key? key, required this.services, required this.account}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  List<Map<String, dynamic>> filteredServices = [];

  @override
  void initState() {
    super.initState();
    // Khởi tạo với tất cả dịch vụ khi trang được mở
    filteredServices = widget.services;
  }

  void searchServices() {
    double? minPrice = double.tryParse(minPriceController.text);
    double? maxPrice = double.tryParse(maxPriceController.text);

    setState(() {
      filteredServices = widget.services.where((service) {
        double price = double.tryParse(service['price'].toString()) ?? 0;
        return (minPrice == null || price >= minPrice!) &&
               (maxPrice == null || price <= maxPrice!);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List RoomType'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: minPriceController,
                    decoration: InputDecoration(
                      labelText: 'Giá tối thiểu',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16), // Khoảng cách giữa hai trường
                Expanded(
                  child: TextField(
                    controller: maxPriceController,
                    decoration: InputDecoration(
                      labelText: 'Giá tối đa',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                
                onTap: searchServices,
                child: Padding(
                  padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                  child: Text('Tìm Kiếm', style: TextStyle(
                    color: Colors.white
                  ),)),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredServices.length,
                itemBuilder: (context, index) {
                  var service = filteredServices[index];
                  Size size =MediaQuery.sizeOf(context);
                   return Container(
                                    
                                     margin: const EdgeInsets.all(25),
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,                           
                                    children: [
                                      Container(      
                                        margin: const EdgeInsets.only(top: 10,left: 10,right: 10),                                
                                          width : size.width / 1.3, 
                                        
                                          height:size.height/6,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            image: service['img'] != null
                                                ? DecorationImage(
                                                    image: NetworkImage(service['img']),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                            color: Colors.transparent,
                                          ),
                                          child: service['img'] == null
                                              ? const Icon(Icons.image,
                                                  size: 10)
                                              : null,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:MainAxisAlignment.center,
                                            children: [
                                              Text(service['number'],
                                              maxLines: 1,
                                              textAlign: TextAlign.center ,
                                              style:const TextStyle(
                                                fontFamily: 'Candal',
                                                fontSize: 18,
                                                color: Colors.black
                                              ),),
                                            ],
                                          ),
                                        ),
                                        
                                        
                                          const SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap:  (){
                                              
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(codeRoom: service['id'],account: widget.account,),));
                                            },
                                              child: Center(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 26,
                                                  width: 127,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(25)
                                                    ),
                                                  child: Text('View More', textAlign:TextAlign.center,
                                                  style: TextStyle(fontWeight:FontWeight.bold, color: Colors.white),
                                                  ),
                                                
                                                  ),
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                        Container(
                                          height: 1,
                                          width: size.width/1.6,
                                          color: Colors.grey
                                        ),
                                         Padding(
                                          padding: const EdgeInsets.only( left: 20,right: 20),
                                           child: Row(          
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                             children: [
                                              Row(
              
                                                children:[
                                                  Text(service['price'].toString() ,              
                                                style:const TextStyle(
                                                  color: Color(0xff57A5EC),
                                                  fontSize: 20,
                                                  fontFamily: 'Cantral'
                                                ),
                                                
                                                ),
                                                const Text('/ night', style: TextStyle(color: Colors.grey,fontFamily: 'Cantral', fontSize: 20),)
              
                                                ] 
                                              ),
                                              Row( 
                                                crossAxisAlignment: CrossAxisAlignment.center   ,
                                                children: [
                                                  Image.asset('asset/images/icons/Star.png'),
                                                  const Text('  4.8')
                                                ],
                                              )
                                             ]
                                           ),
                                         ),
                                          ] 
                                        ),
                                    
                                  
                                ),
                              );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}