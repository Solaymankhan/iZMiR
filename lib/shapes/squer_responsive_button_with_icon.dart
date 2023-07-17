
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/lists.dart';
import '../controllers/cart_controller.dart';

Widget squer_responsive_button_with_icon(page_id,context,wdt, het, icon, title) {
  return Material(
    borderRadius: BorderRadius.circular(6),
    child: InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: (){
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => page_list[page_id]));
        if(page_id==0){
          Future.delayed(Duration(milliseconds: 200), () async {
            final cart_controller cartController = Get.find();
            cartController.is_all_selected.value = false;
            await cartController.get_product_data();
          });
        }
      },
      child: Ink(
        height: het,
        width: wdt*0.2,
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: lightGreyColor
        ),
        child: Column(
          children: [
            Icon(icon,color: darkFontGreyColor,),
            5.heightBox,
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    ),
  ).box.margin(EdgeInsets.only(left: 2.5,right: 2.5)).make();
}
