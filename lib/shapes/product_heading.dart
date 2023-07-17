import 'package:get/get.dart';
import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/app_setting_controller.dart';
import '../controllers/home_controller.dart';
import '../pages/brands_and_shops_page.dart';
import '../pages/hot_deals_page.dart';
import '../pages/seasonal_sales_page.dart';
import '../pages/special_sales_page.dart';

final HomeController controller = Get.find();
final app_setting_controller appSettingController = Get.find();

Widget product_heading_shape(category_name,tf) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Container(
            height: 18,
            width: 5,
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(2),bottomLeft: Radius.circular(2)),
              color: yellowColor,
            ),
          ),
          Container(
            height: 18,
            width: 5,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(2),bottomRight: Radius.circular(2)),
              color: darkBlueColor,
            ),
          ),
          Container(
            height: 16,
            width: 10,
          ),
          Text(category_name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
        ],
      ),
      Visibility(
        visible: tf,
        child: Material(
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: (){

              if(category_name==appSettingController.seasonal_sale_name.value)Get.to(()=>seasonal_sales_page());
              else if(category_name==spcl_sls_txt)Get.to(()=>special_sales_page());
              else if(category_name==brands_shops_txt)Get.to(()=>brands_and_shops_page());
              else if(category_name==categories_txt)controller.current_nav_indx.value=1;
              else if(category_name==hot_deals_txt)Get.to(()=>hot_deals_page());


            },
            child: Ink(
              padding: EdgeInsets.all(2),
              child: Text("View All...",style: TextStyle(fontWeight: FontWeight.w400),),
            ),
          ),
        ),
      )
    ],
  ).box.margin(EdgeInsets.only(left: 15,right: 15)).make();
}
