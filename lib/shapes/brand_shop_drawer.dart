import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/colors.dart';
import 'package:izmir/consts/consts.dart';
import 'package:izmir/pages/login_page.dart';
import 'package:izmir/shapes/snack_bar.dart';
import 'package:velocity_x/velocity_x.dart';
import '../controllers/brand_shop_drawer_controller.dart';
import '../controllers/drawer_controller.dart';
import '../pages/add_products_page.dart';
import '../pages/brand_details_page.dart';
import '../pages/brand_messages_book_page.dart';
import '../pages/professionals_profile_page.dart';
import '../pages/about_us_page.dart';
import '../pages/cart_page_2.dart';
import '../pages/complain_box_page.dart';
import '../pages/message_book_page.dart';
import '../pages/my_orders_page.dart';
import '../pages/profile_page.dart';
import '../pages/returns_page.dart';
import '../pages/rules_and_guide_page.dart';
import '../pages/statistics_page.dart';
import 'all_product_network_image_shape.dart';

class brand_shop_drawer extends StatelessWidget {
  brand_shop_drawer({Key? key}) : super(key: key);
  final brand_shop_drawer_controller brandShopDrawerController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: ((OverscrollIndicatorNotification? notificaton) {
          notificaton!.disallowIndicator();
          return true;
        }),
        child: SafeArea(
            child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
                leading: Icon(
                  CupertinoIcons.chat_bubble_2_fill,
                  color: darkFontGreyColor,
                ),
                title: Text(messages_txt),
                onTap: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(
                          builder: (_) => brand_messages_book_page
                            (brand_details:brandShopDrawerController.brand_info,
                              brand_id:brandShopDrawerController.brand_id.value)));
                }),
            ListTile(
                leading: Icon(
                  CupertinoIcons.gift_fill,
                  color: darkFontGreyColor,
                ),
                title: Text(products_txt),
                onTap: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(
                          builder: (_) =>add_products_page
                            (brand_id:brandShopDrawerController.brand_id.value)));
                }),
            ListTile(
                leading: Icon(
                  CupertinoIcons.chart_pie_fill,
                  color: darkFontGreyColor,
                ),
                title: Text(statistics_txt),
                onTap: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(
                          builder: (_) => statistics_page
                            (brand_details:brandShopDrawerController.brand_info,
                              brand_id:brandShopDrawerController.brand_id.value)));
                }),
            ListTile(
                leading: Icon(
                  CupertinoIcons.pencil,
                  color: darkFontGreyColor,
                ),
                title: Text(edt_brand_txt),
                onTap: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(
                          builder: (_) => brand_details_page
                            (brand_id:brandShopDrawerController.brand_id.value)));
                }),
          ],
        )),
      ),
    );
  }

}
