import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class RoomForm extends StatelessWidget {
  final TextEditingController numberController;
  final TextEditingController priceController;
  final TextEditingController introduceController;
  // final TextEditingController floorController;
  // final String? selectedRoomType;
  // final List<String> roomTypeOptions;
  final List<String> selectedServices;
  final List<String> serviceOptions;
  // final void Function(String?) onRoomTypeChanged;
  final void Function(List<String>) onServicesChanged;
  final VoidCallback onPickImage;
  final VoidCallback onSubmit;

  const RoomForm({
    super.key,
    required this.numberController,
    required this.priceController,
    required this.introduceController,
    // required this.floorController,
    // required this.selectedRoomType,
    // required this.roomTypeOptions,
    required this.selectedServices,
    required this.serviceOptions,
    // required this.onRoomTypeChanged,
    required this.onServicesChanged,
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
            controller: priceController,
            decoration: const InputDecoration(
              labelText: 'Price',
              hintText: '20.000',
            ),
            keyboardType: TextInputType.number,
          ),
          // const SizedBox(height: 10),
          // TextField(
          //   controller: floorController,
          //   decoration: const InputDecoration(
          //     labelText: 'Floor',
          //     hintText: '2',
          //   ),
          //   keyboardType: TextInputType.number,
          // ),
          const SizedBox(height: 10),
          TextField(
            controller: introduceController,
            decoration: const InputDecoration(
              labelText: 'Introduce',
              hintText: 'nguyen',
            ),
          ),
          // const SizedBox(height: 10),
          // DropdownButtonFormField<String>(
          //   value: selectedRoomType,
          //   hint: const Text('Select Room Type'),
          //   onChanged: onRoomTypeChanged,
          //   items:
          //       roomTypeOptions.map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          // ),
          const SizedBox(height: 10),
          MultiSelectDialogField<String>(
            items: serviceOptions
                .map((service) => MultiSelectItem<String>(service, service))
                .toList(),
            title: const Text('Select Services'),
            initialValue: selectedServices,
            onConfirm: onServicesChanged,
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
