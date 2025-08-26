import 'package:booking/Management/RoomType/image_picker_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class TableTypeForm extends StatefulWidget {
  final TextEditingController priceController;
  final TextEditingController tableTypeController;

  final Function(String?) onRoomTypeChanged;
  final VoidCallback onSubmit;
  String img;
   TableTypeForm({
    super.key,
    required this.priceController,
    required this.tableTypeController,
    required this.onRoomTypeChanged,
    required this.onSubmit,
    required this.img,
  });

  @override
  _TableFormState createState() => _TableFormState();
}

class _TableFormState extends State<TableTypeForm> {
  Future<void> _selectedStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 10.0,
      ),
      child: Column(
        
        mainAxisSize: MainAxisSize.min,
        
        children: [
          const Center(child: Text('Create Table', style: TextStyle(
            fontFamily: 'Candal',
            fontSize: 22,
          ),)),
          Center(
              child: GestureDetector(
                    onTap: () async {
                          String? url = await pickAndUploadImage('');
                          if (url != null) {
                            setState(() {
                              widget.img = url; 
                            });
                          }
                        },
                    child: Center(
                      child: Column(
                        
                        children:[ 
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(widget.img==''? 'Đang load hình đợi tí':'Load xog rồi'),
                          ),
                          CircleAvatar(
                          radius: 50,
                          backgroundImage: widget.img.isNotEmpty
                              ? NetworkImage(widget.img)
                              : widget.img != null
                                  ? NetworkImage(widget.img)
                                  : null,
                          child:
                              widget.img == null ? const Icon(Icons.image) : null,
                        ),
                        ]
                      ),
                    ),
                  ),
            ),
          Container(
            margin: EdgeInsets.only(top: 10,),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: widget.priceController,
                decoration: const InputDecoration(labelText: 'Enter Price',
                border: InputBorder.none),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10,),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: widget.tableTypeController,
                decoration: const InputDecoration(labelText: 'Enter Type',
                border: InputBorder.none
                ),
                keyboardType: TextInputType.number,
              
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              
              borderRadius: BorderRadius.circular(10)
            ),
            margin: EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              
              onTap: () async{
                
                   final CollectionReference _item =
      FirebaseFirestore.instance.collection('TableType');
                 final int price = int.tryParse(widget.priceController.text) ?? 0;
            final String tableType = widget.tableTypeController.text;

            await _item.add({
              "Id": randomAlphaNumeric(10),
              "price": price,
              "tabletype": tableType,
              "img": widget.img,
            });
            widget.priceController.clear();
            widget.priceController.clear();

            Navigator.of(context).pop();
            
                
                
                
              },
              child: Padding(
                padding: EdgeInsets.only(top: 10,bottom: 10,left: 7,right: 7),
                child: const Text('Submit', style:TextStyle(color: Colors.white) ,)),
            ),
          ),
        ],
      ),
    );
  }
}
