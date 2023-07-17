import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izmir/consts/consts.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/lists.dart';
import '../controllers/app_setting_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/create_account_form_validation_controller.dart';
import '../controllers/drawer_controller.dart';
import '../controllers/loading_dialogue_controller.dart';
import '../controllers/phone_auth_controller.dart';
import '../controllers/upcoming_events_shape_controller.dart';
import '../controllers/upcoming_events_shape_controller2.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/circuler_small_color_button.dart';
import '../shapes/loading_page.dart';
import '../shapes/product_heading.dart';
import '../shapes/snack_bar.dart';
import 'add_product_sheet.dart';
import 'hexcolorMaker_controller.dart';
import 'varify_otp_page.dart';

class app_settings_page extends StatefulWidget {
  app_settings_page({Key? key}) : super(key: key);

  @override
  State<app_settings_page> createState() => _app_settings_pageState();
}

class _app_settings_pageState extends State<app_settings_page> {
  final app_setting_controller appSettingController = Get.find();
  final drawer_controller drawerController = Get.find();
  final category_controller categoryController = Get.find();
  final upcomingEventsController = Get.put(upcoming_events_shape_controller2());

  var img_docreference = FirebaseStorage.instance;
  var settings_docreference =
      FirebaseFirestore.instance.collection("app_settings").doc("setting");
  var banner_events_img_docreference = FirebaseStorage.instance;

  RxList banner_img_list = [].obs,
      event_img = [].obs,
      banner_img_uint_list = [].obs;

  RxString banner = "Banner".obs,
      seller_off_percent = "0".obs,
      seasonal_sale_name = "".obs,
      customer_off_percent = "0".obs,
      app_offer = "0".obs,
      color_hex_str = white_color_hex.obs,
      inside_dhaka_delivery_charge = "0".obs,
      outside_dhaka_delivery_charge = "0".obs,
      inside_district_sadar_delivery_charge = "0".obs,
      outside_district_sadar_delivery_charge = "0".obs,
      event_date_picked_show = "".obs,
      event_date_picked_compare = "".obs;

  var dat,new_list=[].obs,category_selection_list = [].obs;

  final _formKey = GlobalKey<FormState>();
  final season_key = GlobalKey<FormState>();

  var wdt,het,from="setting";

  @override
  void initState() {
    new_list.value=categoryController.allCategorylist;
    seller_off_percent.value = appSettingController.setting_list["off_seller"];
    customer_off_percent.value =
    appSettingController.setting_list["off_customer"];
    app_offer.value = appSettingController.setting_list["app_offer"];
    color_hex_str.value = appSettingController.setting_list["theme_bg_color"];
    inside_dhaka_delivery_charge.value =
    appSettingController.setting_list["delivery_charge_indhaka"];
    outside_dhaka_delivery_charge.value =
    appSettingController.setting_list["delivery_charge_outdhaka"];
    inside_district_sadar_delivery_charge.value =
    appSettingController.setting_list["delivery_charge_insadar"];
    outside_district_sadar_delivery_charge.value =
    appSettingController.setting_list["delivery_charge_outsadar"];
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < new_list.length; i++)
    new_list[i]["category_selected"] = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    wdt = (MediaQuery.of(context).size.width);
    het = (MediaQuery.of(context).size.height);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              bar_with_back_button(context,app_settings),
              Flexible(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Obx(
                      () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            15.heightBox,
                            product_heading_shape(banner.value, false),
                            15.heightBox,
                            Container(
                              height: het >= wdt ? het * 0.2 : wdt * 0.2,
                              child: VxSwiper.builder(
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  itemCount: calculate_item_count(),
                                  height: het >= wdt ? het * 0.2 : wdt * 0.2,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        ImagePicker imagePicker = ImagePicker();
                                        banner_img_list.clear();
                                        banner_img_uint_list.clear();
                                        List<XFile> img_list =
                                            await imagePicker.pickMultiImage();
                                        banner_img_list.value =
                                            img_list.length > 10
                                                ? img_list.sublist(0, 10)
                                                : img_list;
                                        if (banner_img_list != null) {
                                          for (XFile oneimg
                                              in banner_img_list) {
                                            Uint8List? compressed_img =
                                                await FlutterImageCompress
                                                    .compressWithFile(
                                                        oneimg!.path,
                                                        quality: 40)!;
                                            banner_img_uint_list
                                                .add(compressed_img!);
                                          }
                                        }
                                      },
                                      child: banner_img_uint_list.length == 0 &&
                                              appSettingController
                                                      .banner_prev_img_list
                                                      .length ==
                                                  0
                                          ? home_asset_swiper_image_shape()
                                          : show_banner_image(index),
                                    );
                                  }),
                            ),
                            15.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: 5,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(2),
                                            bottomLeft: Radius.circular(2)),
                                        color: yellowColor,
                                      ),
                                    ),
                                    Container(
                                      height: 18,
                                      width: 5,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(2),
                                            bottomRight: Radius.circular(2)),
                                        color: darkBlueColor,
                                      ),
                                    ),
                                    Container(
                                      height: 16,
                                      width: 10,
                                    ),
                                    Text("Seasonal Sales",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18)),
                                  ],
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(50),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () {
                                      add_seasonal_sales_sheet(context);
                                    },
                                    child: Ink(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            color: lightGreyColor),
                                        child: Icon(Icons.add)),
                                  ),
                                )
                              ],
                            )
                                .box
                                .margin(EdgeInsets.only(left: 15, right: 15))
                                .make(),
                            15.heightBox,
                            appSettingController.seaconal_sales(het, wdt,from),
                            15.heightBox,
                            product_heading_shape("Baground Color", false),
                            15.heightBox,
                            TextFormField(
                              initialValue: color_hex_str.value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: "Color Hex code",
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(),
                                prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: circuler_small_color_button(25.0,
                                        25.0, hexColor(color_hex_str.value))),
                              ),
                              maxLength: 7,
                              onChanged: (val) {
                                color_hex_str.value =
                                    val.length == 7 && val[0] == '#'
                                        ? val
                                        : white_color_hex;
                              },
                            )
                                .box
                                .margin(EdgeInsets.only(left: 15, right: 15))
                                .make(),
                            product_heading_shape("App offer", false),
                            15.heightBox,
                            TextFormField(
                                    initialValue: app_offer.value,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      labelText: "App offer",
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(CupertinoIcons.percent),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    maxLength: 2,
                                    onChanged: (val) {
                                      app_offer.value = val.length == 0
                                          ? "0"
                                          : val.toString();
                                    })
                                .box
                                .padding(EdgeInsets.only(right: 15, left: 15))
                                .make(),
                            5.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: 5,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(2),
                                            bottomLeft: Radius.circular(2)),
                                        color: yellowColor,
                                      ),
                                    ),
                                    Container(
                                      height: 18,
                                      width: 5,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(2),
                                            bottomRight: Radius.circular(2)),
                                        color: darkBlueColor,
                                      ),
                                    ),
                                    Container(
                                      height: 16,
                                      width: 10,
                                    ),
                                    Text("Upcomming Events",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18)),
                                  ],
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(50),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () {
                                      add_event_sheet(context);
                                      event_img.clear();
                                      event_date_picked_compare.value = "";
                                      event_date_picked_show.value = "";
                                    },
                                    child: Ink(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: lightGreyColor),
                                        child: Icon(Icons.add)),
                                  ),
                                )
                              ],
                            )
                                .box
                                .margin(EdgeInsets.only(left: 15, right: 15))
                                .make(),
                            15.heightBox,
                            upcomingEventsController.upcoming_events_shape(
                                het, wdt),
                            15.heightBox,
                            product_heading_shape("0ffer On Refer", false),
                            15.heightBox,
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                          initialValue: seller_off_percent.value,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: InputDecoration(
                                            labelText: "Seller Off",
                                            contentPadding: EdgeInsets.all(8),
                                            border: OutlineInputBorder(),
                                            prefixIcon:
                                                Icon(CupertinoIcons.percent),
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          maxLength: 2,
                                          onChanged: (val) {
                                            seller_off_percent.value =
                                                val.length == 0
                                                    ? "0"
                                                    : val.toString();
                                          })
                                      .box
                                      .margin(EdgeInsets.only(right: 5))
                                      .make(),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                          initialValue: customer_off_percent.value,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: InputDecoration(
                                            labelText: "Customer Off",
                                            contentPadding: EdgeInsets.all(8),
                                            border: OutlineInputBorder(),
                                            prefixIcon:
                                                Icon(CupertinoIcons.percent),
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          maxLength: 2,
                                          onChanged: (val) {
                                            customer_off_percent.value =
                                                val.length == 0
                                                    ? "0"
                                                    : val.toString();
                                          })
                                      .box
                                      .margin(EdgeInsets.only(left: 5))
                                      .make(),
                                )
                              ],
                            )
                                .box
                                .padding(EdgeInsets.only(right: 15, left: 15))
                                .make(),
                            product_heading_shape("Delivery charge", false),
                            15.heightBox,
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue:
                                        inside_dhaka_delivery_charge.value,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      labelText: "Inside Dhaka",
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                      prefixIcon:
                                          Icon(CupertinoIcons.money_dollar),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    maxLength: 9,
                                    onChanged: (val) {
                                      inside_dhaka_delivery_charge.value =
                                          val.length == 0
                                              ? "0"
                                              : val.toString();
                                    },
                                    validator: (value) {
                                      if (value.toString().length == 0) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                  )
                                      .box
                                      .margin(EdgeInsets.only(right: 5))
                                      .make(),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue:
                                        outside_dhaka_delivery_charge.value,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      labelText: "Outside Dhaka",
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                      prefixIcon:
                                          Icon(CupertinoIcons.money_dollar),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    maxLength: 9,
                                    onChanged: (val) {
                                      outside_dhaka_delivery_charge.value =
                                          val.length == 0
                                              ? "0"
                                              : val.toString();
                                    },
                                    validator: (value) {
                                      if (value.toString().length == 0) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                  ).box.margin(EdgeInsets.only(left: 5)).make(),
                                )
                              ],
                            )
                                .box
                                .padding(EdgeInsets.only(right: 15, left: 15))
                                .make(),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue:
                                        appSettingController.setting_list[
                                            "delivery_charge_insadar"],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      labelText: "Inside sadar",
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                      prefixIcon:
                                          Icon(CupertinoIcons.money_dollar),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    maxLength: 9,
                                    onChanged: (val) {
                                      inside_district_sadar_delivery_charge
                                              .value =
                                          val.length == 0
                                              ? "0"
                                              : val.toString();
                                    },
                                    validator: (value) {
                                      if (value.toString().length == 0) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                  )
                                      .box
                                      .margin(EdgeInsets.only(right: 5))
                                      .make(),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue:
                                        appSettingController.setting_list[
                                            "delivery_charge_outsadar"],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      labelText: "Outside sadar",
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                      prefixIcon:
                                          Icon(CupertinoIcons.money_dollar),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    maxLength: 9,
                                    onChanged: (val) {
                                      outside_district_sadar_delivery_charge
                                              .value =
                                          val.length == 0
                                              ? "0"
                                              : val.toString();
                                    },
                                    validator: (value) {
                                      if (value.toString().length == 0) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                  ).box.margin(EdgeInsets.only(left: 5)).make(),
                                )
                              ],
                            )
                                .box
                                .padding(EdgeInsets.only(right: 15, left: 15))
                                .make(),
                            30.heightBox,
                            Center(
                              child: Material(
                                borderRadius: BorderRadius.circular(6),
                                child: InkWell(
                                  onTap: () => save_is_database(),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: darkBlueColor,
                                    ),
                                    height: 40.0,
                                    width: 200.0,
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: yellowColor,
                                          fontWeight: FontWeight.w500),
                                    ).box.alignCenter.make(),
                                  ),
                                ),
                              ),
                            ),
                            30.heightBox,
                          ]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ).box.color(whiteColor).make(),
      ),
    );
  }

  int calculate_item_count() {
    if (banner_img_uint_list.length == 0 &&
        appSettingController.banner_prev_img_list.length == 0) {
      return 1;
    } else if (banner_img_uint_list.length > 0) {
      return banner_img_uint_list.length;
    } else
      return appSettingController.banner_prev_img_list.length;
  }

  Widget show_banner_image(index) {
    if (banner_img_uint_list.length != 0 &&
        appSettingController.banner_prev_img_list.length == 0) {
      return home_file_swiper_image_shape(banner_img_uint_list[index]);
    } else
      return CachedNetworkImage(
        imageUrl: appSettingController.banner_prev_img_list[index],
        imageBuilder: (context, url) => home_network_swiper_image_shape(url),
        placeholder: (context, url) => home_asset_swiper_image_shape(),
        errorWidget: (context, url, error) => home_asset_swiper_image_shape(),
      );
  }

  save_is_database() async {
    String banner_img_urls = "";
    if (banner_img_uint_list.length > 0) {
      for (int i = 0; i < banner_img_uint_list.length; i++) {
        Reference reference = FirebaseStorage.instance
            .ref()
            .child("banners_picture")
            .child(new DateTime.now().microsecondsSinceEpoch.toString());
        await reference.putData(banner_img_uint_list[i]).whenComplete(() async {
          await reference.getDownloadURL().then((value) => {
                banner_img_urls = "${banner_img_urls + "  " + value}",
              });
        });
      }
      for (var val in appSettingController.banner_prev_img_list) {
        await img_docreference.refFromURL(val).delete();
      }
    } else {
      banner_img_urls = appSettingController.setting_list["banner_img"];
    }
    settings_docreference.update({
      "banner_img": banner_img_urls,
      "theme_bg_color": color_hex_str.value,
      "app_offer": app_offer.value,
      "off_seller": seller_off_percent.value,
      "off_customer": customer_off_percent.value,
      "delivery_charge_indhaka": inside_dhaka_delivery_charge.value,
      "delivery_charge_outdhaka": outside_dhaka_delivery_charge.value,
      "delivery_charge_insadar": inside_district_sadar_delivery_charge.value,
      "delivery_charge_outsadar": outside_district_sadar_delivery_charge.value,
      "updated_time": new DateTime.now().microsecondsSinceEpoch.toString(),
    });
  }

  Future add_seasonal_sales_sheet(context) => showSlidingBottomSheet(context,
      builder: (context) => SlidingSheetDialog(
          duration: const Duration(milliseconds: 150),
          snapSpec: SnapSpec(initialSnap: 0.9, snappings: [0.9]),
          cornerRadius: 15,
          scrollSpec: ScrollSpec(physics: BouncingScrollPhysics()),
          builder: buildSheet1));

  Widget buildSheet1(context, state) =>
      Material(child:StatefulBuilder(builder: (context, setState) {
  return  Column(
              children: [
                Row(children: [
                  Flexible(
                      flex: 1,
                      child: Container()),
                  Flexible(
                      flex: 2,
                      child:  Center(
                        child: Text(
                          add_category_for_ssnl_txt,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          borderRadius: BorderRadius.circular(6),
                          child: InkWell(
                            onTap: () => add_seasonal_sale_in_database(),
                            borderRadius: BorderRadius.circular(6),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: lightGreyColor,
                              ),
                              height: 30,
                              width: 70.0,
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: darkFontGreyColor,
                                    fontWeight: FontWeight.w500),
                              ).box.alignCenter.make(),
                            ),
                          ),
                        ),
                      )),
                ],),
                10.heightBox,
                TextFormField(
                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    labelText: "Season name",
                    counter: Offstage(),
                  ),
                  maxLength: 20,
                  onChanged: (value){
                    seasonal_sale_name.value=value;
                  },
                ).box
            .height(50)
            .width(
        wdt < 800 ? double.infinity : wdt * 0.5).make(),
                10.heightBox,
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: "Search category",
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {update_cat_list(value);});
                  },
                )
                    .box
                    .height(40)
                    .width(
                  wdt < 800 ? double.infinity : wdt * 0.5,
                )
                    .make(),
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: new_list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: het > wdt ? 4 : 7,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(100),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl:new_list[index]["category_icon"],
                                imageBuilder: (context, url) => brand_ink_network_image_shape(url),
                                placeholder: (context, url) => brand_ink_asset_image_shape(),
                                errorWidget: (context, url, error) => brand_ink_asset_image_shape(),
                              ),
                            ),
                          ),
                          5.heightBox,
                          Text(
                            new_list[index]["category_name"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      )
                          .box
                          .rounded
                          .color(new_list[index]["category_selected"]
                          ? yellowColor
                          : whiteColor)
                          .make()
                          .onTap(() {
                        setState(() {});
                          new_list[index]["category_selected"] =
                          !new_list[index]["category_selected"];
                        if (new_list[index]["category_selected"]) {
                          category_selection_list
                              .add(new_list[index]);
                        } else {
                          category_selection_list
                              .remove(new_list[index]);
                        }
                      }
                      );
                    }),
              ],
            ).box.color(whiteColor).padding(EdgeInsets.all(10)).make();}
      )
      );

  void update_cat_list(value) {
    if (value.toString().length == 0) {
      new_list.value = categoryController.allCategorylist;
    } else {
      RxList l = [].obs;
      for (int i = 0; i < categoryController.allCategorylist.length; i++) {
        if (categoryController.allCategorylist[i]["category_name"]
            .toLowerCase()
            .contains(value.toLowerCase())) {
          l.add(categoryController.allCategorylist[i]);
        }
      }
      new_list.value = l;
    }
  }

  add_seasonal_sale_in_database(){

      Get.back();
      settings_docreference.update({
        "season_sale_name":seasonal_sale_name.value,
        "season_sale_categories":category_selection_list,
      });

  }

  Future add_event_sheet(context) => showSlidingBottomSheet(context,
      builder: (context) => SlidingSheetDialog(
          duration: const Duration(milliseconds: 150),
          snapSpec: SnapSpec(initialSnap: 0.9, snappings: [0.9]),
          cornerRadius: 15,
          scrollSpec: ScrollSpec(physics: BouncingScrollPhysics()),
          builder: buildSheet2));

  Widget buildSheet2(context, state) => Material(
          child: Column(
        children: [
          Material(
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? img =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                Uint8List image = (await FlutterImageCompress.compressWithFile(
                  img!.path,
                  quality: 40,
                  format: CompressFormat.jpeg,
                ))!;
                event_img.clear();
                event_img.add(image);
              },
              child: Obx(
                () => Ink(
                  height: 200,
                  width: double.infinity,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: new DecorationImage(
                      image: event_img.length > 0
                          ? MemoryImage(event_img[0])
                          : AssetImage(add_icon) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          10.heightBox,
          Material(
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () async {
                DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    firstDate: DateTime.now().add(Duration(days: 1)),
                    lastDate: DateTime.now().add(Duration(days: 365)));
                if (date != null) {
                  dat = DateTime.parse(date.toString());
                  event_date_picked_show.value =
                      "${dat.day} ${month_names[dat.month - 1]}";
                  event_date_picked_compare.value = dat.year.toString() +
                      dat.month.toString() +
                      dat.day.toString();
                }
              },
              child: Ink(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: lightGreyColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        event_date_picked_show.value != ""
                            ? event_date_picked_show.value
                            : "Date",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            color: darkFontGreyColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          10.heightBox,
          Material(
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () async {
                if (event_img.length! > 0 &&
                    event_date_picked_compare.value != "") {
                  Navigator.of(context).pop();
                  Reference reference = banner_events_img_docreference
                      .ref()
                      .child("banners_picture")
                      .child(
                          new DateTime.now().microsecondsSinceEpoch.toString());
                  try {
                    await reference.putData(event_img[0]);
                    String img_url = await reference.getDownloadURL();
                    settings_docreference.collection("upcomming_events").add({
                      'event_img': img_url.toString(),
                      'event_date_compare': event_date_picked_compare.value,
                      'event_day': dat.day.toString(),
                      'event_month': dat.month.toString(),
                      'event_brand_name': "",
                      'event_organizer_id': drawerController.pref_userId.value,
                      'event_adding_time':
                          new DateTime.now().microsecondsSinceEpoch.toString(),
                    });
                    upcomingEventsController.reload_event_data();
                    show_snackbar(
                        context, sccs_cat_add_txt, yellowColor, darkBlueColor);
                  } catch (e) {
                    show_snackbar(
                        context, e.toString(), whiteColor, Colors.red);
                  }
                }
              },
              child: Ink(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: darkBlueColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Save",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          color: yellowColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
          30.heightBox,
        ],
      ).box.padding(EdgeInsets.all(10)).make());
}
