import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';
import '../pages/product_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/brands_controller.dart';
import '../shapes/all_product_network_image_shape.dart';

class hot_deals_controller extends GetxController {
  var docreference = FirebaseFirestore.instance
      .collection("products")
      .where("brand_and_product_offer", isGreaterThan: "30");
  final brands_controller brandController = Get.find();
  int limit=20;
  RxList list = [].obs;
  RxList product_id_list = [].obs;

  ScrollController scrollController = ScrollController();
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

  void reload_all_product_data() {
    isMoreData = true;
    list.clear();
    product_id_list.clear();
    lastDocument = null;
    PaginatedData();
  }

  void PaginatedData() async {
    if (isMoreData) {
      try {
        final collectionRef = docreference;
        late QuerySnapshot<Map<String, dynamic>> querySnapshot;
        if (lastDocument == null) {
          querySnapshot = await collectionRef.limit(limit).get();
        } else {
          querySnapshot = await collectionRef
              .limit(limit)
              .startAfterDocument(lastDocument!)
              .get();
        }
        lastDocument = querySnapshot.docs.last;
        list.addAll(querySnapshot.docs.map((e) => e.data()));
        product_id_list.addAll(querySnapshot.docs.map((e) => e.id));
        if (querySnapshot.docs.length < limit) isMoreData = false;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget hot_deals_shape(het, wdt) {
    return GridView.builder(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: het > wdt ? 2 : 5, mainAxisExtent: 290),
        itemBuilder: (context, index) {
          return Material(
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => product_details_page(
                              product_id: product_id_list[index])));
                },
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl:list[index]["product_first_img"].toString().trim(),
                  imageBuilder: (context, url) => Ink(
                    height: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: url,
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: list[index]["brand_icon"],
                                  imageBuilder: (context, url) =>
                                      brand_small_network_image_shape(url),
                                  placeholder: (context, url) =>
                                      brand_small_asset_image_shape(),
                                  errorWidget: (context, url, error) =>
                                      brand_small_asset_image_shape(),
                                ),
                                Text(
                                  list[index]["brand_name"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: whiteColor,
                                      fontWeight: FontWeight.w600),
                                ).expand(),
                              ],
                            ),
                            Text(
                              list[index]["brand_and_product_offer"] == "0"
                                  ? ""
                                  : "${list[index]["brand_and_product_offer"]}% off",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: yellowColor,
                                  fontWeight: FontWeight.w500),
                            )
                                .box
                                .color(darkBlueColor)
                                .padding(EdgeInsets.only(left: 5, right: 5))
                                .rounded
                                .make(),
                          ],
                        ).box.linearGradient([Colors.transparent, Colors.black38],
                            begin:  Alignment.bottomCenter, end: Alignment.topCenter)
                            .customRounded(BorderRadius.only(topRight: Radius.circular(6),topLeft: Radius.circular(6)))
                            .padding(EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 10)).make(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              list[index]["product_title"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icon/taka_svg.svg',
                                  width: 16,
                                  color: whiteColor,
                                ),
                                Text(
                                  list[index]["final_price"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ).expand(),
                              ],
                            ),
                          ],
                        ).box.linearGradient([Colors.transparent, Colors.black38],
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,)
                            .customRounded(BorderRadius.only(bottomRight: Radius.circular(6),bottomLeft: Radius.circular(6)))
                            .padding(EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 2)).make()
                      ],
                    ).box.height(200).make(),
                  ),
                  placeholder: (context, url) =>
                      hot_deals_asset_image_shape(),
                  errorWidget: (context, url, error) =>
                      hot_deals_asset_image_shape(),
                )),
          ).box.padding(EdgeInsets.all(2)).make();
        }).box.margin(EdgeInsets.only(left: 13, right: 13)).make();
  }

  Widget hot_deals_shape_demo(het, wdt) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length > 20 ? 20 : list.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Material(
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => product_details_page(
                                product_id: product_id_list[index])));
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl:list[index]["product_first_img"].toString().trim(),
                    imageBuilder: (context, url) => Ink(
                      height: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: url,
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: list[index]["brand_icon"],
                                    imageBuilder: (context, url) =>
                                        brand_small_network_image_shape(url),
                                    placeholder: (context, url) =>
                                        brand_small_asset_image_shape(),
                                    errorWidget: (context, url, error) =>
                                        brand_small_asset_image_shape(),
                                  ),
                                  Text(
                                    list[index]["brand_name"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w600),
                                  ).expand(),
                                ],
                              ),
                              Text(
                                  list[index]["brand_and_product_offer"] == "0"
                                      ? ""
                                      : "${list[index]["brand_and_product_offer"]}% off",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: yellowColor,
                                      fontWeight: FontWeight.w500),
                                )
                                    .box
                                    .color(darkBlueColor)
                                    .padding(EdgeInsets.only(left: 5, right: 5))
                                    .rounded
                                    .make(),
                            ],
                          ).box.linearGradient([Colors.transparent, Colors.black38],
                            begin:  Alignment.bottomCenter, end: Alignment.topCenter)
                          .customRounded(BorderRadius.only(topRight: Radius.circular(6),topLeft: Radius.circular(6)))
                              .padding(EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 10)).make(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list[index]["product_title"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icon/taka_svg.svg',
                                    width: 16,
                                    color: whiteColor,
                                  ),
                                  Text(
                                    list[index]["final_price"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ).expand(),
                                ],
                              ),
                            ],
                          ).box.linearGradient([Colors.transparent, Colors.black38],
                              begin: Alignment.topCenter, end: Alignment.bottomCenter,)
                              .customRounded(BorderRadius.only(bottomRight: Radius.circular(6),bottomLeft: Radius.circular(6)))
                              .padding(EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 2)).make()
                        ],
                      ).box.height(200).make(),
                    ),
                    placeholder: (context, url) =>
                        hot_deals_asset_image_shape(),
                    errorWidget: (context, url, error) =>
                        hot_deals_asset_image_shape(),
                  )),
            )
                .box
                .width(120)
                .margin(EdgeInsets.only(
                    left: index == 0 ? 13 : 0,
                    right: index == list.length - 1 ? 15 : 0))
                .padding(EdgeInsets.all(2))
                .make();
          }),
    );
  }
}
