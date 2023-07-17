import 'package:get/get.dart';
import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/lists.dart';

Widget squer_responsive_button_with_row_ico(page_id,het,wdt,button_color,icon,txt,txt_color,txt_size){
  return Material(
    borderRadius: BorderRadius.circular(6),
    child: InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {Get.to(()=>page_list[page_id]);},
      child: Ink(
        height: het,
        width: wdt,
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), color: button_color),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 10,
            ),
            Text(
              txt,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: txt_size,
                color: txt_color
              ),
            )
          ],
        ),
      ),
    ),
  );
}
