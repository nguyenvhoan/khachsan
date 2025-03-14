import 'package:flutter/material.dart';
class AlertUpdateUser{
 static Future  <bool?> showConfirmDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xffD9D9D9),
        title: const Text('`Are you sure you want to change?`'
        ,maxLines: 1,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        
        ),
        actions: <Widget>[
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color(0xff1A4368)), // Màu nền
            foregroundColor: WidgetStateProperty.all(Colors.white), 
            ),
            child:  const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Cancel')),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color(0xff1A4368)), // Màu nền
            foregroundColor: WidgetStateProperty.all(Colors.white), 
            ),
            child:  const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text('OK')),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
            ],
          )
        ],
      );
    },
  );
}
static Future  <bool?> showConfirmDialogVoucher(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xffD9D9D9),
        title: const Text('`Are you sure you want trade?`'
        ,maxLines: 1,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        
        ),
        actions: <Widget>[
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color(0xff1A4368)), // Màu nền
            foregroundColor: WidgetStateProperty.all(Colors.white), 
            ),
            child:  const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Cancel')),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color(0xff1A4368)), // Màu nền
            foregroundColor: WidgetStateProperty.all(Colors.white), 
            ),
            child:  const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text('OK')),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
            ],
          )
        ],
      );
    },
  );
}

}
