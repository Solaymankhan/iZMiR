import 'package:flutter/cupertino.dart';

import '../consts/colors.dart';


Widget circuler_small_color_button(het,wdt,button_color){
  return Container(
    margin: EdgeInsets.only(left: 10),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: button_color,
        border: Border.all(
          color: textFieldGreyColor,
          width: 1,
        )
    ),
    height: het,
    width: wdt,
  );





    /*GestureDetector(
    onTap: (){},
    child: Container(
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: button_color,
          border: Border.all(
            color: textFieldGreyColor,
            width: 1,
          )
      ),
      height: het,
      width: wdt,
    ),
  );*/
}