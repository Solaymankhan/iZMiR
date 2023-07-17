import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:izmir/consts/consts.dart';
import 'package:get/get.dart';
import 'package:izmir/pages/add_product_sheet.dart';
import 'package:izmir/pages/product_edit_details_page.dart';
import 'package:velocity_x/velocity_x.dart';
import '../controllers/app_setting_controller.dart';
import '../controllers/brands_controller.dart';
import '../controllers/cart_controller_2.dart';
import '../controllers/products_previous_details_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/dont_have_any_data.dart';
import 'app_settings_page.dart';

class add_products_page extends StatefulWidget {
  add_products_page(
      {Key? key, required this.brand_id})
      : super(key: key);
  var  brand_id;

  @override
  State<add_products_page> createState() => _add_products_pageState();
}

class _add_products_pageState extends State<add_products_page> {
  final brands_controller brandController = Get.find();
  var docreference = FirebaseFirestore.instance.collection("products");
  var docbrandreference = FirebaseFirestore.instance.collection("brands");
  bool is_selected = false;
  RxInt current_index = 0.obs;
  RxMap brand_details=new RxMap();
  RxString current_brand = "".obs, brand_banners = "".obs;
  var from = "add_product", date;
  RxList banner_img_list = [].obs, banner_img_uint_list = [].obs;
  RxList category_list = [].obs, brand_banner_img_list = [].obs;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 400), () async{
      fetch_data();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);

    return Scaffold(
      body: Obx(
        () =>
        brand_details.isEmpty?
        CupertinoActivityIndicator(radius: 10)
            .box
            .alignCenter
            .make()
            :
            CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.centerRight,
                      height: 50,
                      margin: EdgeInsets.only(right: 10),
                      child: Material(
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: Ink(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: whiteColor,
                              ),
                              child: Icon(
                                CupertinoIcons.back,
                                color: Colors.black,
                              )),
                        ),
                      )),
                  Material(
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => add_product_sheet(
                                    brand:brand_details,
                                    brand_id: widget.brand_id)));
                      },
                      child: Ink(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: lightGreyColor),
                          child: Icon(Icons.add, color: Colors.black)),
                    ),
                  )
                ],
              ).box.padding(EdgeInsets.only(top: 5)).make(),
              backgroundColor: whiteColor,
              pinned: true,
              shadowColor: Colors.transparent,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: het * 0.35,
                  width: double.infinity,
                  child: Swiper(
                    physics: ScrollPhysics(),
                    autoplay: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          ImagePicker imagePicker = ImagePicker();
                          banner_img_list.clear();
                          banner_img_uint_list.clear();
                          List<XFile> img_list =
                              await imagePicker.pickMultiImage();
                          banner_img_list.value = img_list.length > 10
                              ? img_list.sublist(0, 10)
                              : img_list;
                          if (banner_img_list != null) {
                            for (XFile oneimg in banner_img_list) {
                              Uint8List? compressed_img =
                                  await FlutterImageCompress.compressWithFile(
                                      oneimg!.path,
                                      quality: 40)!;
                              banner_img_uint_list.add(compressed_img!);
                            }
                          }

                          if (banner_img_uint_list != null) {
                            update_brand_banner();
                          }
                        },
                        child:brand_details["brand_banner_img"] == '' &&
                                banner_img_uint_list.length == 0
                            ? all_product_asset_image_shape()
                            : show_banner_image(index),
                      );
                    },
                    itemCount: calculate_item_count(),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.heightBox,
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: brand_details["brand_icon"],
                              imageBuilder: (context, url) =>
                                  brand_network_image_shape(url),
                              placeholder: (context, url) =>
                                  brand_asset_image_shape(),
                              errorWidget: (context, url, error) =>
                                  brand_asset_image_shape(),
                            ),
                          ),
                          Visibility(
                            visible: brand_details['brand_verified'] ==
                                    "verified"
                                ? true
                                : false,
                            child: Container(
                                height: 13,
                                width: 13,
                                decoration: BoxDecoration(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: whiteColor, width: 1)),
                                child: Icon(
                                  Icons.check,
                                  color: darkBlueColor,
                                  size: 10,
                                )),
                          )
                        ],
                      ).marginOnly(right: 5),
                      Flexible(
                        child: Text(
                         brand_details["brand_name"],
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                  10.heightBox,
             if(brand_details["brand_offer"] != '0')
              Text(
            '${brand_details["brand_offer"]}% Extra off',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14,
                  color: yellowColor,
                  fontWeight: FontWeight.w400),
            )
                .box
                .padding(EdgeInsets.only(
                left: 5, right: 5, top: 2, bottom: 2))
                .color(darkBlueColor)
                .rounded
                .margin(EdgeInsets.only(bottom: 10))
                .make(),
                  Row(
                    children: [
                      SvgPicture.asset(
                        likes_icon,
                        width: 20,
                        color: Colors.grey,
                      ).marginOnly(right: 10),
                      Text(brand_details["brand_likes"].toString(),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " Likes",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(brand_details["brand_full_location"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      )),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Since, $date',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      )),
                    ],
                  ),
                  10.heightBox,
                ],
              ).box.margin(EdgeInsets.only(left: 15, right: 15)).make(),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: Delegate(current_index, category_list),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder<QuerySnapshot>(
                stream: category_list.length==0?docreference
                    .orderBy("product_adding_time", descending: true)
                    .where('brand_name',
                    isEqualTo: brand_details["brand_name"])
                    .snapshots():(category_list[current_index.value] == "All"
                    ? docreference
                        .orderBy("product_adding_time", descending: true)
                        .where('brand_name',
                            isEqualTo:brand_details["brand_name"])
                        .snapshots()
                    : docreference
                        .orderBy("product_adding_time", descending: true)
                        .where('brand_name',
                            isEqualTo: brand_details["brand_name"])
                        .where('category_name',
                            isEqualTo: category_list[current_index.value])
                        .snapshots()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return dont_have_any_data(het);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        height: het - 120,
                        child: CupertinoActivityIndicator(radius: 10)
                            .box
                            .alignCenter
                            .make());
                  }
                  if (snapshot.data!.docs.length == 0) {
                    return dont_have_any_data(het);
                  }
                  return GridView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: het > wdt ? 2 : 5,
                          mainAxisExtent: 290),
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        List product_img_list =
                            doc["product_img"].toString().trim().split("  ");

                        return Material(
                          child: InkWell(
                            onTap: () {

                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          product_edit_details_page(
                                              product_details_doc: doc,
                                              poduct_id: doc.id)));
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: lightGreyColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: product_img_list[0],
                                    imageBuilder: (context, url) =>
                                        all_product_network_image_shape(url),
                                    placeholder: (context, url) =>
                                        all_product_asset_image_shape(),
                                    errorWidget: (context, url, error) =>
                                        all_product_asset_image_shape(),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: doc["brand_icon"],
                                            imageBuilder: (context, url) =>
                                                brand_small_network_image_shape(
                                                    url),
                                            placeholder: (context, url) =>
                                                brand_small_asset_image_shape(),
                                            errorWidget: (context, url,
                                                    error) =>
                                                brand_small_asset_image_shape(),
                                          ),
                                          Visibility(
                                            visible: doc["brand_verified"] ==
                                                    "verified"
                                                ? true
                                                : false,
                                            child: Container(
                                                height: 12,
                                                width: 12,
                                                decoration: BoxDecoration(
                                                    color: yellowColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    border: Border.all(
                                                        color: whiteColor,
                                                        width: 1)),
                                                child: Icon(
                                                  Icons.check,
                                                  color: darkBlueColor,
                                                  size: 10,
                                                )),
                                          )
                                        ],
                                      ).marginOnly(right: 2),
                                      Expanded(
                                        child: Text(
                                          doc["brand_name"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    doc["product_title"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  )
                                      .box
                                      .padding(EdgeInsets.only(
                                          top: 3, bottom: 3, left: 7, right: 7))
                                      .make(),
                                  2.heightBox,
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.star_fill,
                                              size: 15,
                                              color: yellowColor,
                                            ),
                                            Text(
                                              "${doc["product_rating"]}/5",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: darkFontGreyColor,
                                                  fontWeight: FontWeight.w400),
                                            ).marginOnly(left: 5),
                                          ],
                                        ),
                                        Visibility(
                                          visible: doc["off_percent"] == "0"
                                              ? false
                                              : true,
                                          child: Text(
                                            "${doc["off_percent"]}% off",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: orangeColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ]).marginOnly(left: 5, right: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icon/taka_svg.svg',
                                              width: 16,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${doc["off_percent"] == "0" ?
                                                (double.parse(doc["liquid_ml_price_list"][0])
                                                    + double.parse(doc["initial_price"])) :
                                                ((double.parse(doc["liquid_ml_price_list"][0]) +
                                                    double.parse(doc["initial_price"])) -
                                                    ((double.parse(doc["off_percent"]) *
                                                        (double.parse(doc["liquid_ml_price_list"][0])
                                                            + double.parse(doc["initial_price"]))) / 100))
                                                    .toStringAsFixed(0)}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Visibility(
                                          visible: doc["off_percent"] == '0'
                                              ? false
                                              : true,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text.rich(
                                              overflow: TextOverflow.ellipsis,
                                              TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                      child: SvgPicture.asset(
                                                    'assets/icon/taka_svg.svg',
                                                    width: 14,
                                                    color: FontGreyColor,
                                                  )),
                                                  TextSpan(
                                                    text: doc["is_liquid_selected"] ==
                                                            "true"
                                                        ? doc["liquid_ml_price_list"]
                                                            [0]
                                                        : doc["initial_price"],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: FontGreyColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                            .box
                                            .padding(EdgeInsets.only(right: 3))
                                            .make(),
                                      )
                                    ],
                                  ).box.padding(EdgeInsets.all(3)).make(),
                                ],
                              ),
                            ),
                          ),
                        ).box.padding(EdgeInsets.all(2)).make();
                      });
                },
              ).box.margin(EdgeInsets.only(left: 10, right: 10)).make(),
            )
          ],
        ).box.color(whiteColor).make(),
      ),
    );
  }

  fetch_data()async{
    docbrandreference.doc(widget.brand_id).get().then((value)async{
      brand_details.value={
        'brand_icon': value['brand_icon'],
        'brand_name': value['brand_name'],
        'brand_name_lowercase': value['brand_name_lowercase'],
        'brand_offer':value['brand_offer'],
        'brand_division': value['brand_division'],
        'brand_district': value['brand_district'],
        'brand_full_location':value['brand_full_location'],
        'brand_status':value['brand_status'],
        'brand_likes': value['brand_likes'],
        'brand_verified': value['brand_verified'],
        "brand_banner_img": value["brand_banner_img"],
        'brand_categories': value['brand_categories'],
        'brand_adding_time':value[ 'brand_adding_time'],
      };
      DateTime dateTime = await DateTime.fromMillisecondsSinceEpoch
        ((int.parse(brand_details["brand_adding_time"])/1000)
          .toInt()).toLocal();
      date = await DateFormat('dd-MM-yyyy').format(dateTime);
      brand_banner_img_list.value= brand_details["brand_banner_img"].toString().trim().split("  ");
      category_list.clear();
      category_list.add("All");
      for(var val in brand_details["brand_categories"])category_list.add(val);
    });
  }

  int calculate_item_count() {
    if (brand_details["brand_banner_img"] == '' &&
        banner_img_uint_list.length == 0) {
      return 1;
    } else if (banner_img_uint_list.length > 0) {
      return banner_img_uint_list.length;
    } else
      return brand_banner_img_list.length>0?brand_banner_img_list.length:1;
  }

  Widget show_banner_image(index) {
    if (brand_details["brand_banner_img"].toString().length > 1 &&
        banner_img_uint_list.length == 0) {
      return CachedNetworkImage(
        imageUrl: brand_banner_img_list.length>0?brand_banner_img_list[index]:"",
        imageBuilder: (context, url) =>
            all_product_network_swiper_image_shape(url),
        placeholder: (context, url) => all_product_asset_swiper_image_shape(),
        errorWidget: (context, url, error) =>
            all_product_asset_swiper_image_shape(),
      );
    } else {
      return  all_product_file_swiper_image_shape(banner_img_uint_list[index]);
    }
  }

  update_brand_banner() async {
    var storage_reference = FirebaseStorage.instance;

    for (int i = 0; i < banner_img_uint_list.length; i++) {
      Reference banner_storage_reference = storage_reference
          .ref()
          .child("brand_icon")
          .child(brand_details["brand_name"])
          .child(new DateTime.now().microsecondsSinceEpoch.toString());
      await banner_storage_reference
          .putData(banner_img_uint_list[i])
          .whenComplete(() async {
        await banner_storage_reference.getDownloadURL().then((value) => {
              brand_banners.value = "${brand_banners.value + "  " + value}",
            });
      });
    }
    await docbrandreference.doc(widget.brand_id).update({"brand_banner_img": brand_banners.value});
    for (var val in brand_banner_img_list)await storage_reference.refFromURL(val).delete();
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  Delegate(this.current_index, this.category_list);

  RxInt current_index = 0.obs;
  RxList category_list = [].obs;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Obx(
      () => Container(
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: category_list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  current_index.value = index;
                },
                child: Row(
                  children: [
                    Text(
                      category_list[index],
                      style: TextStyle(
                        color: current_index.value == index
                            ? darkBlueColor
                            : Colors.black,
                        fontSize: current_index.value == index ? 16 : 14,
                        fontWeight: current_index.value == index
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    )
                  ],
                )
                    .box
                    .rounded
                    .padding(EdgeInsets.only(left: 10, right: 10))
                    .margin(EdgeInsets.only(
                        left: index == 0 ? 10 : 5,
                        right: index == category_list.length - 1 ? 10 : 0))
                    .color(
                        current_index.value == index ? yellowColor : whiteColor)
                    .make(),
              );
            }),
      )
          .box
          .color(whiteColor)
          .padding(EdgeInsets.only(top: 5, bottom: 5))
          .make(),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
