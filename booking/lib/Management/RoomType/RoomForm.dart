import 'package:booking/Management/RoomType/image_picker_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:random_string/random_string.dart';

class RoomForm extends StatefulWidget {
  final TextEditingController numberController;
  final TextEditingController priceController;
  final TextEditingController introduceController;
  final List<String> selectedServices;
  final List<String> serviceOptions;
  final void Function(List<String>) onServicesChanged;
  final VoidCallback onSubmit;
  String img;
   RoomForm({
    super.key,
    required this.numberController,
    required this.priceController,
    required this.introduceController,

    required this.selectedServices,
    required this.serviceOptions,
    required this.onServicesChanged,
    required this.onSubmit,
    required this.img,
  });

  @override
  State<RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  List<String>? selected;
  void initState() {
    super.initState();
    selected = widget.selectedServices; // Khởi tạo với giá trị từ widget
  }
  void select(List<String> values){
    
            setState(() {
              selected = values;
            });
         

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Text('Create room', style: TextStyle(
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
                    child: Column(
                      children:[ 
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(widget.img==''? 'Đang load hình đợi tí':'Load xog rồi'),
                          ),
                        Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: widget.img.isNotEmpty
                              ? NetworkImage(widget.img)
                              : widget.img != null
                                  ? NetworkImage(widget.img)
                                  : null,
                          child:
                              widget.img == null ? const Icon(Icons.image) : null,
                        ),
                      ),
                      ]
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
                controller: widget.numberController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Room number',
                  hintText: 'P01',
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: widget.priceController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Price',
                  hintText: '20.000',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),

          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: widget.introduceController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Introduce',
                  hintText: 'nguyen',
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(top: 10,),
            decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
            child: MultiSelectDialogField<String>(
              
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.transparent, // Hoặc màu sắc khác để làm cho nó vô hình
                ),
                  
                    borderRadius: BorderRadius.circular(20),
                  ),
              items: widget.serviceOptions
                  .map((service) => MultiSelectItem<String>(service, service))
                  .toList(),
              title: const Text('Select Services'),
              initialValue: selected!,
              onConfirm: select
            ),
          ),
          
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () async{
                final CollectionReference _item =
      FirebaseFirestore.instance.collection('RoomType');
                 final String number = widget.numberController.text;
            final int price = int.tryParse(widget.priceController.text) ?? 0;
            final String introduce = widget.introduceController.text;
          

            await _item.add({
              "Id": randomAlphaNumeric(10),
              "number": number,
              "price": price,
              "intro": introduce,

              "img": widget.img,
              // "roomType": roomType,
              "services": selected,
            });
            widget.numberController.clear();
            widget.priceController.clear();
            widget.introduceController.clear();
            // // _floorController.clear();
            // _selectedRoomType = null;
            Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ),
        ],
      ),
    );
  }
}
