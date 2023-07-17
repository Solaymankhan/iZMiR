import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/colors.dart';
import 'package:izmir/consts/consts.dart';
import 'package:izmir/consts/lists.dart';
import 'package:izmir/pages/hexcolorMaker_controller.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/strings.dart';
import '../controllers/drawer_controller.dart';
import '../controllers/profile_picture_sheet_controller.dart';
import '../controllers/profile_product_state_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/bar_with_back_button.dart';

import '../shapes/product_heading.dart';
import '../shapes/squer_responsive_button_with_icon.dart';
import 'profile_setting_page.dart';

class professionals_profile_page extends StatelessWidget {
  professionals_profile_page({Key? key}) : super(key: key);

  final drawer_controller drawerController = Get.find();

  @override
  Widget build(BuildContext context) {
    final profilepictureController = Get.put(profile_picture_sheet_controller(new_context: context));
    final cartController = Get.put(profile_product_state_controller());
    var wdt = (MediaQuery.of(context).size.width);
    bool is_selected = false;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            bar_with_back_button(context,profile_txt),
            Expanded(child:
            Obx(()=> SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                controller: cartController.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        color: lightGreyColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child:Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Material(
                                      borderRadius: BorderRadius.circular(100),
                                      child: InkWell(
                                        borderRadius:
                                        BorderRadius.circular(100),
                                        onTap: () {
                                          profilepictureController.profile_picture_edit_sheet(context);
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: drawerController.pref_info["profile_picture"]==''?'':
                                          drawerController.pref_info["profile_picture"],
                                          imageBuilder: (context, url)=> profile_network_image_shape(url),
                                          placeholder: (context, url)=>profile_asset_image_shape(),
                                          errorWidget: (context, url, error) => profile_asset_image_shape(),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          drawerController.pref_info["name"].length >
                                              15 ?
                                          drawerController.pref_info["name"].substring(
                                              0, 15) + "..."
                                              : drawerController.pref_info["name"],
                                          style: TextStyle(
                                              color: BlackColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )
                                            .box
                                            .margin(EdgeInsets.only(left: 10))
                                            .make(),
                                        5.heightBox,
                                        Text(
                                          "Professional",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: darkFontGreyColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ).box.rounded.color(yellowColor).margin(EdgeInsets.only(left: 10))
                                            .padding(EdgeInsets.only(left: 7,right: 7,top: 1,bottom: 1)).make(),
                                      ],)
                                  ],
                                ),
                                5.heightBox,
                                Text(
                                  "${drawerController.pref_info["phone"]}\n"
                                      "${drawerController.pref_info["email"]}\n"
                                      "${drawerController.pref_info["district"]}, "
                                      "${drawerController.pref_info["division"]}, "
                                      "Bangladesh\n"
                                      "${drawerController.pref_info["address"]}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: darkFontGreyColor, fontSize: 15),
                                ),
                                5.heightBox,
                                Text(
                                  "Level : ${drawerController.pref_info["level"]}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: darkFontGreyColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                5.heightBox,
                                Text(
                                  "Referral code : ${drawerController.pref_info["referral_code"]}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: darkFontGreyColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ],
                            ).box.padding(EdgeInsets.all(15)).make(),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Material(
                              borderRadius: BorderRadius.circular(50),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  Get.to(() => profile_setting_page());
                                },
                                child: Ink(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: lightGreyColor,),
                                    child: Icon(Icons.settings)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    5.heightBox,
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          squer_responsive_button_with_icon(4,context, wdt, 60.0,
                              CupertinoIcons.person_alt, admin_txt),
                          squer_responsive_button_with_icon(5,context, wdt, 60.0,
                              CupertinoIcons.music_house_fill,my_stores_txt),
                          squer_responsive_button_with_icon(6,context, wdt, 60.0,
                              CupertinoIcons.money_dollar_circle_fill, my_sales_txt),

                        ]),
                    5.heightBox,
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          squer_responsive_button_with_icon(0,context, wdt, 60.0,
                              CupertinoIcons.cart_fill, my_cart_txt),
                          squer_responsive_button_with_icon(1,context, wdt, 60.0,
                              CupertinoIcons.gift_alt_fill, my_orders_txt),
                          squer_responsive_button_with_icon(2,context, wdt, 60.0,
                              CupertinoIcons.arrowshape_turn_up_left_fill,myreturn_txt),
                          squer_responsive_button_with_icon(3,context, wdt, 60.0,
                              CupertinoIcons.hand_thumbsup_fill, liked_brands_shops_txt),
                        ]),
                    5.heightBox,
                    Container(
                      height: 50.0,
                      padding: EdgeInsets.only(left: 10),
                      decoration: new BoxDecoration(
                        color: lightGreyColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            points_icon,
                            width: 30,
                            color: darkFontGreyColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Obx(()=> Text(
                            "Balance : ${drawerController.account_balance_txt.value} taka",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                            TextStyle(fontSize: 15.0, color: BlackColor),
                          ),
                          )
                        ],
                      ),
                    ),
                    10.heightBox,
                    product_heading_shape(history_txt,false),
                  ],
                ).marginOnly(left: 15,right: 15),
              ),
            )
            )
          ],
        ),
      ).color(whiteColor),
    );
  }

  getImage() {
    if (drawerController.pref_info["profile_picture"].toString().length > 0)
      return NetworkImage(drawerController.pref_info["profile_picture"]);
    else
      return AssetImage(profile_avater);
  }
}
