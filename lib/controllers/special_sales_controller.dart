import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/strings.dart';
import '../pages/brand_details_page.dart';
import '../pages/brand_shop_home_page.dart';
import '../pages/view_category_items.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/dont_have_any_data.dart';
import '../shapes/dont_have_any_data_2.dart';
import 'drawer_controller.dart';

class special_sales_controller extends GetxController {
  var docreference = FirebaseFirestore.instance.collection("brands")
      .where('brand_offer', isGreaterThan: "14")
      .where('brand_status', isEqualTo: "activated")
      .orderBy('brand_offer', descending: true);
  var mybrandlist = [].obs, selectedbrands = [].obs;
  RxString account_id = ''.obs;
  RxList brand_list = [].obs, brand_id_list = [].obs;

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
              .limit(50)
              .get();
          if (querySnapshot.size != 0) {
            have_special_off.value = true;
            print("Solayman");
          }
        } else {
          querySnapshot = await docreference
              .limit(50)
              .startAfterDocument(lastDocument!)
              .get();
        }
        lastDocument = querySnapshot.docs.last;

        brand_list.addAll(querySnapshot.docs.map((e) => e.data()));
        brand_id_list.addAll(querySnapshot.docs.map((e) => e.id));
        if (querySnapshot.docs.length < 10) isMoreData = false;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget getview_brands_data(het, wdt) {
    return Obx(
      () => GridView.builder(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: brand_list.length,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: het > wdt ? 2 : 5, mainAxisExtent: 70),
          itemBuilder: (context, index) {
            return Material(
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  Get.to(() => brands_shops_home_page(
                      brand_id: brand_id_list[index]));
                },
                child: Ink(
                  child: Row(
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
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              brand_list[index]['brand_name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: darkFontGreyColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "${brand_list[index]['brand_offer']}% off",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: orangeColor),
                            ),
                            Text(
                              "${brand_list[index]['brand_likes']} Likes",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: darkFontGreyColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ]).box.margin(EdgeInsets.only(left: 10)).make().expand()
                    ],
                  ),
                )
                    .box
                    .padding(
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5))
                    .make(),
              ),
            ).box.margin(EdgeInsets.all(2)).make();
          }),
    );
  }

  Widget getview_brands_data_demo(het, wdt) {
    return Container(
        width: double.infinity,
        height:60,
        margin: EdgeInsets.only(top: 10,bottom: 20),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(6), color: whiteColor),
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: brand_list.length > 25 ? 25 : brand_list.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Material(
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    Get.to(() => brands_shops_home_page(
                        brand_id: brand_id_list[index]));
                  },
                  child: Ink(
                    child: Row(
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
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                brand_list[index]['brand_name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: darkFontGreyColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "${brand_list[index]['brand_offer']}% off",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: orangeColor),
                              ),
                              Text(
                                "${brand_list[index]['brand_likes']} Likes",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: darkFontGreyColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ]).box.margin(EdgeInsets.only(left: 10)).make()
                      ],
                    ),
                  )
                      .box
                      .padding(EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5))
                      .make(),
                ),
              )
                  .box
                  .margin(EdgeInsets.only(
                      left: index == 0 ? 15 : 2,
                      right: index == brand_list.length - 1 ? 10 : 2))
                  .make();
            }));
  }
}
