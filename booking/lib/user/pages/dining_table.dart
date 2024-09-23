import 'package:flutter/material.dart';

class DiningTable extends StatefulWidget {
   DiningTable({super.key, required this.table});
  Map<String,dynamic> table;
  @override
  State<DiningTable> createState() => _DiningTableState();
}

class _DiningTableState extends State<DiningTable> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:(){ 
        Navigator.pop(context);}, icon: Image.asset('asset/images/icons/icon_back.png')),
        centerTitle: true,
        title:const Text('Dining table reservation form', textAlign: TextAlign.center,) ,
        
      ),
      body: Container(
        child: Column(
          children: [
            Container(
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
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width: size.width/3,
                    height: size.height/6.5 ,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image:  widget.table['img']!=null
                      ?DecorationImage(
                        image: NetworkImage(widget.table['img']),
                        fit: BoxFit.cover
                        
                        )
                        :null,
                        color: Colors.transparent,
                    ),
                    child: widget.table['img']==null
                    ?const Icon(Icons.image, size: 50,)
                    :null,
                  ),
                  Padding(
                    padding:EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                           Text('Table type : ', style:TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                        ]),
                         Text(widget.table['tabletype'], style:  TextStyle(fontSize: 19, color: Color(0xff1A4368)),),
                       Row(children:[
                           const Text('Giá: ', style:TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xff57A5EC)),
                          ),
                         SizedBox(height: 50,),
                          Text(widget.table['price'].toString(),style: TextStyle(fontSize: 19),)
                          ] 
                          ),
                      ],
                    ), 
                    )
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),
               decoration:BoxDecoration(
                 color: Colors.white,
                   boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: Offset(0, 2), 
                      ),
                    ],
                   ),
                  height: 50,
                  child: TextFormField(
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Bắt buộc nhập';
                      }
                    },
                                  
                  // controller: cardNumberController,
                  decoration: const InputDecoration(
                  label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder:const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}