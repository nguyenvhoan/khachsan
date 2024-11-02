import 'package:flutter/material.dart';

class Roomform extends StatelessWidget {
  final TextEditingController numberController;

  final TextEditingController floorController;
  final String? selectedRoomType;
  final List<String> roomTypeOptions;

  final void Function(String?) onRoomTypeChanged;

  final VoidCallback onPickImage;
  final VoidCallback onSubmit;
  const Roomform({
    super.key,
    required this.numberController,
    required this.floorController,
    required this.selectedRoomType,
    required this.roomTypeOptions,
    required this.onRoomTypeChanged,
    required this.onPickImage,
    required this.onSubmit,
  });

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
          const Center(child: Text('Create room')),
          TextField(
            controller: numberController,
            decoration: const InputDecoration(
              labelText: 'Room number',
              hintText: 'P01',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: floorController,
            decoration: const InputDecoration(
              labelText: 'Floor',
              hintText: '2',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedRoomType,
            hint: const Text('Select Room Type'),
            onChanged: onRoomTypeChanged,
            items:
                roomTypeOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Center(
            child: IconButton(
              onPressed: onPickImage,
              icon: const Icon(Icons.camera_alt),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: onSubmit,
              child: const Text('Create'),
            ),
          ),
        ],
      ),
    );
  }
}
