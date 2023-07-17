import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/consts.dart';
import '../consts/lists.dart';

Widget squer_button(page_id,het,wdt,button_color,txt,txt_color,txt_size){
  return Material(
    borderRadius: BorderRadius.circular(6),
    child: InkWell(
      onTap: () {Get.to(()=>page_list[page_id]);},
      borderRadius: BorderRadius.circular(6),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: button_color,
        ),
        height: het,
        width: wdt,
        child: Text(
          txt,
          style: TextStyle(
              fontSize: txt_size,color: txt_color, fontWeight: FontWeight.w500),
        ).box.alignCenter.make(),
      ),
    ),
  );
}