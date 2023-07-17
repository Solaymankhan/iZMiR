import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/images.dart';
import '../consts/strings.dart';
import '../controllers/delay_few_seconds.dart';
import 'loading_page.dart';

Widget dont_have_any_data_2(){
  return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset(dont_have_icon).box.width(80).make(),
      10.heightBox,
      Text(dont_have_any_data_txt,style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500
      )),
    ],
  ).box.alignCenter.make();
}