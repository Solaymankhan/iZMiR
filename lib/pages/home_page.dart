import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:izmir/consts/consts.dart';
import 'package:izmir/consts/lists.dart';
import 'package:izmir/model/product_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/all_product_shape_controller.dart';
import '../controllers/app_setting_controller.dart';
import '../controllers/brands_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/drawer_controller.dart';
import '../controllers/hot_deals_controller.dart';
import '../controllers/special_sales_controller.dart';
import '../controllers/upcoming_events_shape_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/home_category_button_shape.dart';
import '../shapes/product_heading.dart';
import 'package:get/get.dart';

class home_page extends StatefulWidget {
  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  final brandController = Get.put(brands_controller());
  final specialSallesController = Get.put(special_sales_controller());
  final drawer_controller drawerController = Get.find();
  final category_controller categoryController = Get.find();
  final app_setting_controller appSettingController = Get.find();
  final all_products_controller = Get.put(all_product_shape_controller());
  final upcomingEventsController = Get.put(upcoming_events_shape_controller());
  final hotDealsController = Get.put(hot_deals_controller());

  String from = "view";

  @override
  initState() {
    brandController.account_id.value = drawerController.pref_userId.value;
    brandController.my_brands(drawerController.pref_userId.value);
    drawerController.save_profile_info_again();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                  flex: 2,
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 80,
                      decoration: new BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(6),
                        image: new DecorationImage(
                          image: new AssetImage(izmir_name_icon),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
              Flexible(
                flex: 5,
                child: Container(
                    color: whiteColor,
                    height: 60,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: TextField(
                      cursorColor: darkBlueColor,
                      // onChanged: (value) => _runFilter(value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: lightGreyColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15),
                        hintText: srchany,
                        suffixIcon: Icon(
                          Icons.search,
                          color: darkFontGreyColor,
                        ),
                        // prefix: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none),
                      ),
                    )),
              ),
              Flexible(
                flex: 1,
                child: Container(
                    alignment: Alignment.centerRight,
                    height: 60,
                    margin: EdgeInsets.only(right: 10),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          drawerController.openDrawer();
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Ink(
                            height: 40,
                            width: 40,
                            color: whiteColor,
                            child: Icon(CupertinoIcons.bars)),
                      ),
                    )),
              ),
            ],
          ),
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                notification.disallowIndicator();
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  drawerController.save_profile_info_again();
                  all_products_controller.reload_all_product_data();
                  appSettingController.fetch_app_setting();
                  upcomingEventsController.reload_event_data();
                },
                child: Obx(
                  () => SingleChildScrollView(
                    controller: all_products_controller.scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        VxSwiper.builder(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            itemCount: appSettingController
                                .banner_prev_img_list.length,
                            height: het >= wdt ? het * 0.2 : wdt * 0.2,
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                imageUrl: appSettingController
                                            .banner_prev_img_list.length ==
                                        0
                                    ? ""
                                    : appSettingController
                                        .banner_prev_img_list[index],
                                imageBuilder: (context, url) =>
                                    home_network_swiper_image_shape(url),
                                placeholder: (context, url) =>
                                    home_asset_swiper_image_shape(),
                                errorWidget: (context, url, error) =>
                                    home_asset_swiper_image_shape(),
                              );
                            }),
                        20.heightBox,
                        if(specialSallesController.have_special_off.value)
                          product_heading_shape(spcl_sls_txt, true),
                        if(specialSallesController.have_special_off.value)
                          specialSallesController.getview_brands_data_demo(het, wdt),
                        product_heading_shape(brands_shops_txt, true),
                        brandController.all_brands_shape_demo(het, wdt),
                        product_heading_shape(categories_txt, true),
                        home_category_button_shape(
                            categoryController.allsubCategorylist, het, wdt),
                        if(appSettingController.setting_list.length != 0)
                          product_heading_shape(
                              appSettingController.seasonal_sale_name.value,
                              true),
                        if(appSettingController.seasonal_sale_name != null)
                          appSettingController.setting_list.length != 0
                              ? appSettingController.seaconal_sales_demo(het, wdt)
                              : Container(),
                        if(!upcomingEventsController.eventlist.isEmpty)
                          product_heading_shape(upcoming_events_txt, false),
                        if(!upcomingEventsController.eventlist.isEmpty)
                        upcomingEventsController.upcoming_events_shape(
                            het, wdt),
                        if(hotDealsController.list.length != 0)
                          product_heading_shape(hot_deals_txt, true),
                        10.heightBox,
                        if(hotDealsController.list.length != 0)
                          hotDealsController.hot_deals_shape_demo(het, wdt),
                        20.heightBox,
                        product_heading_shape(all_products_txt, false),
                        10.heightBox,
                        all_products_controller.all_products_shape(het, wdt)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ).box.color(Colors.white).make();
  }
}
