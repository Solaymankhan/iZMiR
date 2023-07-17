import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/strings.dart';
import '../pages/add_products_page.dart';
import '../pages/brand_details_page.dart';
import '../pages/brand_messages_book_page.dart';
import '../pages/brand_shop_home_page.dart';
import '../pages/brand_shop_dashboard_page.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/dont_have_any_data.dart';
import '../shapes/dont_have_any_data_2.dart';
import 'drawer_controller.dart';

class brands_controller extends GetxController {
  var docreference = FirebaseFirestore.instance.collection("brands");
  var mybrandlist = [];
  RxString account_id = ''.obs;
  RxList brand_list = [].obs, brand_id_list = [].obs;
  int limit=50;
  RxBool have_special_off = false.obs;

  final ScrollController scrollController = ScrollController();
  DocumentSnapshot? lastDocument;
  bool isMoreData = true;
  RxBool visibility_of_widget = false.obs;

  @override
  void onInit() {
    super.onInit();
    PaginatedData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        PaginatedData();
      }
    });
  }

  void PaginatedData() async {
    if (isMoreData) {
      try {
        late QuerySnapshot<Map<String, dynamic>> querySnapshot;
        if (lastDocument == null) {
          querySnapshot = await docreference
              .where('brand_status', isEqualTo: activated)
              .orderBy('brand_likes', descending: false)
              .limit(limit)
              .get();
        } else {
          querySnapshot = await docreference
              .where('brand_status', isEqualTo: activated)
              .orderBy('brand_likes', descending: false)
              .limit(limit)
              .startAfterDocument(lastDocument!)
              .get();
        }
        lastDocument = querySnapshot.docs.last;

        brand_list.addAll(querySnapshot.docs.map((e) => e.data()));
        brand_id_list.addAll(querySnapshot.docs.map((e) => e.id));
        if (querySnapshot.docs.length < limit) isMoreData = false;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget all_brands_shape(het, wdt) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: ((OverscrollIndicatorNotification? notificaton) {
          notificaton!.disallowIndicator();
          return true;
        }),
        child: GridView.builder(
            controller: scrollController,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: brand_list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: het > wdt ? 4 : 7,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            Get.to(() => brands_shops_home_page(
                                brand_id: brand_id_list[index]));
                          },
                          child: CachedNetworkImage(
                            imageUrl: brand_list[index]["brand_icon"],
                            imageBuilder: (context, url) =>
                                brand_ink_network_image_shape(url),
                            placeholder: (context, url) =>
                                brand_ink_asset_image_shape(),
                            errorWidget: (context, url, error) =>
                                brand_ink_asset_image_shape(),
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            brand_list[index]['brand_verified'] == "verified"
                                ? true
                                : false,
                        child: Container(
                            height: 13,
                            width: 13,
                            decoration: BoxDecoration(
                                color: yellowColor,
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: whiteColor, width: 1)),
                            child: Icon(
                              Icons.check,
                              color: darkBlueColor,
                              size: 10,
                            )),
                      )
                    ],
                  ),
                  5.heightBox,
                  Text(
                    brand_list[index]['brand_name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ).box.padding(EdgeInsets.only(left: 10, right: 10)).make()
                ],
              );
            }));
  }

  Widget all_brands_shape_demo(het, wdt) {
    return Container(
      width: double.infinity,
      height: 160,
      margin: EdgeInsets.only(top: 5,bottom: 15),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: GridView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: brand_list.length > 50 ? 50 : brand_list.length,
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return
              Material(
                borderRadius: BorderRadius.circular(6),
                color: whiteColor,
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    Get.to(() => brands_shops_home_page(
                        brand_id: brand_id_list[index]));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          CachedNetworkImage(
                            imageUrl: brand_list[index]["brand_icon"],
                            imageBuilder: (context, url) =>
                                brand_ink_network_image_shape(url),
                            placeholder: (context, url) =>
                                brand_ink_asset_image_shape(),
                            errorWidget: (context, url, error) =>
                                brand_ink_asset_image_shape(),
                          ),
                          if(brand_list[index]['brand_verified'] == "verified")
                            Icon(
                              Icons.check,
                              color: darkBlueColor,
                              size: 10,
                            ).box.height(13).width(13).color(yellowColor).roundedFull.border(width: 1,color: lightGreyColor).make()
                        ],
                      ),
                      5.heightBox,
                      Text(
                        brand_list[index]['brand_name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14,color: darkFontGreyColor, fontWeight: FontWeight.w500),
                      ).box.padding(EdgeInsets.only(left: 5, right: 5)).make()
                    ],
                  )
                ),
              ).box.margin(EdgeInsets.only(left:
              index==0||index==1?15:0)).make();
          }),
    );
  }

  my_brands(id) async {
    if (id.length > 0) {
      await docreference
          .where('brand_status', isEqualTo: activated)
          .where('brand_editors', arrayContains: id)
          .snapshots()
          .listen((event) {
        for (var doc in event.docs) {
          mybrandlist.add({
            "brand_id": doc.id,
            "brand_name": doc.data()['brand_name'],
            'brand_name_lowercase': doc.data()['brand_name_lowercase'],
            "brand_editors": doc.data()['brand_editors'],
            "brand_adding_time": doc.data()['brand_adding_time'],
            'brand_categories': doc.data()['brand_categories'],
            'brand_likes': doc.data()['brand_likes'].toString(),
            "brand_icon": doc.data()['brand_icon'],
            'brand_offer': doc.data()['brand_offer'],
            'brand_contact_number': doc.data()['brand_contact_number'],
            'brand_division': doc.data()['brand_division'],
            'brand_district': doc.data()['brand_district'],
            'brand_full_location': doc.data()['brand_full_location'],
            "brand_status": doc.data()['brand_status'],
            'brand_admin': doc.data()['brand_admin'],
            'brand_verified': doc.data()['brand_verified'],
          });
        }
      });
    }
  }

  Widget getedit_brands_data(het, wdt) {
    return StreamBuilder<QuerySnapshot>(
      stream: docreference
          .where('brand_status', isEqualTo: activated)
          .where('brand_editors',
              arrayContains: drawerController.pref_userId.value)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return dont_have_any_data(het);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: het - 120,
              child: CupertinoActivityIndicator(radius: 15)
                  .box
                  .alignCenter
                  .make());
        }
        if (snapshot.data!.docs.length == 0) {
          return dont_have_any_data(het);
        }
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              return Material(
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => brand_shop_dashboard_page(
                                  brand_details: doc, brand_id: doc.id)));
                    },
                    child: Ink(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: lightGreyColor),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: doc["brand_icon"],
                                      imageBuilder: (context, url) =>
                                          brand_network_image_shape(url),
                                      placeholder: (context, url) =>
                                          brand_asset_image_shape(),
                                      errorWidget: (context, url, error) =>
                                          brand_asset_image_shape(),
                                    ),
                                    Visibility(
                                      visible:
                                          doc['brand_verified'] == "verified"
                                              ? true
                                              : false,
                                      child: Container(
                                          height: 13,
                                          width: 13,
                                          decoration: BoxDecoration(
                                              color: yellowColor,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: whiteColor, width: 1)),
                                          child: Icon(
                                            Icons.check,
                                            color: darkBlueColor,
                                            size: 10,
                                          )),
                                    )
                                  ],
                                ),
                                Text(
                                  doc["brand_name"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ).box.margin(EdgeInsets.only(left: 5)).make()
                              ],
                            ),
                            Text("${doc['brand_likes']} Likes")
                          ]),
                    )),
              )
                  .box
                  .margin(EdgeInsets.only(
                      left: 15, right: 15, top: 0.5, bottom: 0.5))
                  .make();
            });
      },
    );
  }
}
