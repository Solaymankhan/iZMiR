import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/images.dart';
import '../consts/strings.dart';
import '../controllers/delay_few_seconds.dart';
import 'loading_page.dart';

final  delayController =Get.put(delay_few_seconds());

Widget no_internet(){

  return delayController.is_loading.value==true? loading_page() :Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(no_signal_icon).box.width(100).make(),
      10.heightBox,
      Text(no_intrnt,style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
      )),
      Text(chk_intrnt ,
        style: TextStyle(
        fontSize: 14,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.systemGrey
      ),),
    ],
  ).box.alignCenter.make()
  );
}