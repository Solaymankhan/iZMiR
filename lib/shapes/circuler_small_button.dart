import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/consts.dart';

Widget circuler_small_button(het,wdt,button_color,icon_color,icn,icn_size){
  return Material(
    borderRadius: BorderRadius.circular(50),
    child: InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: button_color,
        ),
        height: het,
        width: wdt,
        child: Icon(icn,color: icon_color,size: icn_size),
      ),
    ),
  );
}