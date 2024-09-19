import 'package:flutter/material.dart';

class TableForm extends StatefulWidget {
  final TextEditingController priceController;
  final TextEditingController dayController;
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
    required this.dayController,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _TableFormState createState() => _TableFormState();
}

class _TableFormState extends State<TableForm> {
  Future<void> _selectedStartDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (_picked != null) {
      setState(() {
        widget.dayController.text = _picked.toString().split(" ")[0];
      });
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
          DropdownButtonFormField<String>(
            value: widget.selectedTableType,
            decoration: const InputDecoration(labelText: 'Select Table Type'),
            onChanged: widget.onRoomTypeChanged,
            items: widget.roomTypeOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            child: TextFormField(
              onTap: () {
                _selectedStartDate();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bắt buộc nhập';
                }
              },
              readOnly: true,
              controller: widget.dayController,
              decoration: const InputDecoration(
                label: Text(
                  'Day *',
                  style: TextStyle(color: Color(0xffBEBCBC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
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
