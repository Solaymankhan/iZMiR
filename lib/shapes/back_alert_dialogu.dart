import 'package:flutter/cupertino.dart';

import '../consts/consts.dart';


/*
Future<bool?> show_dialog(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: new Text(
          'Are you sure?',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.red),
        ),
        content: new Text(
          'Do you really want to exit ?',
          style: TextStyle(color: darkBlueColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: new Text('Yes'),
          ),
        ],
      ),
    );

 */


Future<bool?> showAlertDialog(BuildContext context) async => showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: new Text(
        'Are you sure?',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
      ),
      content: new Text(
        'Do you really want to exit ?',
        style: TextStyle(fontSize: 14, color: darkBlueColor),
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context,false),
          child: new Text('No'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => {
            Navigator.pop(context,true)
          },
          child: new Text('Yes'),
        ),
      ],
    ),
);
