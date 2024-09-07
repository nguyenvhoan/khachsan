import 'package:flutter/material.dart';

class TableForm extends StatelessWidget {
  final TextEditingController priceController;
  final String? selectedTableType;
  final List<String> roomTypeOptions;
  final Function(String?) onRoomTypeChanged;
  final VoidCallback onPickImage;
  final VoidCallback onSubmit;

  const TableForm({
    Key? key,
    required this.priceController,
    required this.selectedTableType,
    required this.roomTypeOptions,
    required this.onRoomTypeChanged,
    required this.onPickImage,
    required this.onSubmit,
  }) : super(key: key);

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
          TextField(
            controller: priceController,
            decoration: InputDecoration(labelText: 'Enter Price'),
            keyboardType: TextInputType.number,
          ),
          DropdownButtonFormField<String>(
            value: selectedTableType,
            decoration: InputDecoration(labelText: 'Select Table Type'),
            onChanged: onRoomTypeChanged,
            items: roomTypeOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: onPickImage,
            child: Text('Pick Image'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: onSubmit,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
