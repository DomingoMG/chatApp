import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Future<bool> showSimpleAlert( BuildContext context, String title, String subtitle ){
  if( Platform.isAndroid ){
    return showDialog(
      context: context,
      builder: ( _ ) => AlertDialog(
        title: Text('$title'),
        content: Text('$subtitle'),
        actions: [
          MaterialButton(
            child: Text('Aceptar'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      )
    );
  } else {
    return showDialog(
      context: context,
      builder: ( _ ) => CupertinoAlertDialog(
        title: Text('$title'),
        content: Text('$subtitle'),
        actions: [
          CupertinoDialogAction(
            child: Text('Aceptar'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      )
    );
  }
}