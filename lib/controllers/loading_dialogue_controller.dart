import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class loading_dialogue_controller extends GetxController{
  show_dialogue(context){
    showDialog(context: context,barrierDismissible: false,
        builder: (context)=>CupertinoActivityIndicator(radius: 10));
  }
  close_dialogue(context){
    Navigator.of(context).pop();
  }
}