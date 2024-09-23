import 'package:flutter/material.dart';

class TableTypeForm extends StatefulWidget {
  final TextEditingController priceController;
  final TextEditingController tableTypeController;

  final Function(String?) onRoomTypeChanged;
  final VoidCallback onPickImage;
  final VoidCallback onSubmit;

  const TableTypeForm({
    Key? key,
    required this.priceController,
    required this.tableTypeController,
    required this.onRoomTypeChanged,
    required this.onPickImage,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _TableFormState createState() => _TableFormState();
}

class _TableFormState extends State<TableTypeForm> {
  Future<void> _selectedStartDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (_picked != null) {
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
          TextField(
            controller: widget.priceController,
            decoration: const InputDecoration(labelText: 'Enter Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: widget.tableTypeController,
            decoration: const InputDecoration(labelText: 'Enter Type'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: widget.onPickImage,
            child: const Text('Pick Image'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: widget.onSubmit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
