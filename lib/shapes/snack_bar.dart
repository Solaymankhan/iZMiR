
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/consts.dart';

show_snackbar(context,txt,txclr,bgclr){
    final snackbar=SnackBar(
        content:Text(txt,style:
        TextStyle(color: txclr),),
    backgroundColor: bgclr,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

get_show_snackbar(txt,txclr,bgclr){
    Get.snackbar(
        txt,"",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgclr,
        colorText:txclr,
        borderRadius: 0,
        maxWidth: double.infinity

    );
}
