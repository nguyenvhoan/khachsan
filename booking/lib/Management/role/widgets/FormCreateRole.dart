import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Formcreaterole extends StatelessWidget {
  final TextEditingController nameRole;
  
  
 
 
  final VoidCallback onSubmit;

  const Formcreaterole({
    Key? key,
    required this.nameRole,
    required this.onSubmit,
  }) : super(key: key);

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
            controller: nameRole,
            decoration: const InputDecoration(
              labelText: 'Nhập vai trò',
              hintText: 'P01',
            ),
          ),
          
          const SizedBox(height: 10),
          
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
