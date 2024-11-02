import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class FormcreateAccountAdmin extends StatelessWidget {
  final TextEditingController fullname;
  final TextEditingController username;
  final TextEditingController password;
  final String? selectedRole;
  final List<String> roleOption;
  final void Function(String?) onChanged;
 
 
  final VoidCallback onSubmit;

  const FormcreateAccountAdmin({
    Key? key,
    required  this.fullname,
    required this.password,
    required this.username  ,
    required this.selectedRole,
    required this.onSubmit,
    required this.onChanged,
    required this.roleOption,
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
            controller: fullname,
            decoration: const InputDecoration(
              labelText: 'FullName',
            ),
          ),
          
          const SizedBox(height: 10),
          TextField(
            controller: username,
            decoration: const InputDecoration(
              labelText: 'UserName',
              hintText: '2',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: username,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: '2',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedRole,
            hint: const Text('Select Room Type'),
            onChanged: onChanged,
            items:
                roleOption.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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
