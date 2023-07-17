import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/brands_controller.dart';
import '../pages/product_details_page.dart';
import '../shapes/all_product_network_image_shape.dart';

class all_product_shape_controller extends GetxController {
  var docreference = FirebaseFirestore.instance.collection("products");
  final brands_controller brandController = Get.find();

  RxList list = [].obs;
  RxList product_id_list = [].obs;
  int limit=20;
  ScrollController scrollController = ScrollController();
  DocumentSnapshot? lastDocument;
  bool isMoreData = true;

  @override
  void onInit() async {
    super.onInit();
    await PaginatedData();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        await PaginatedData();
      }
      /*if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if(visibility_of_widget.value!=false){
          visibility_of_widget.value=false;
          print(visibility_of_widget.value.toString());
        }
      }
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {

        if(visibility_of_widget.value!=true){
          visibility_of_widget.value=true;
          print(visibility_of_widget.value.toString());
        }
      }*/
    });
  }

  void reload_all_product_data() async {
    isMoreData = true;
    list.clear();
    product_id_list.clear();
    lastDocument = null;
    await PaginatedData();
  }

  Future<void> PaginatedData() async {
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
        lastDocument = await querySnapshot.docs.last;
        list.addAll(querySnapshot.docs.map((e) => e.data()));
        product_id_list.addAll(querySnapshot.docs.map((e) => e.id));
        if (querySnapshot.docs.length < limit) isMoreData = false;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget all_products_shape(het, wdt) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: het > wdt ? 2 : 5, mainAxisExtent: 310),
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
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: lightGreyColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          list[index]["product_first_img"].toString().trim(),
                      imageBuilder: (context, url) =>
                          all_product_network_image_shape(url),
                      placeholder: (context, url) =>
                          all_product_asset_image_shape(),
                      errorWidget: (context, url, error) =>
                          all_product_asset_image_shape(),
                    ),
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
                              color: darkFontGreyColor,
                              fontWeight: FontWeight.w500),
                        ).expand(),
                      ],
                    ),
                    Text(
                      list[index]["product_title"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          color: darkFontGreyColor,
                          fontWeight: FontWeight.w500),
                    )
                        .box
                        .padding(EdgeInsets.only(
                            top: 3, bottom: 3, left: 7, right: 7))
                        .make(),
                    2.heightBox,
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.star_fill,
                                size: 15,
                                color: yellowColor,
                              ),
                              Text(
                                "${list[index]["product_rating"]}/5",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: darkFontGreyColor,
                                    fontWeight: FontWeight.w500),
                              ).marginOnly(left: 5),
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
                              .rounded
                              .padding(EdgeInsets.only(left: 5, right: 5))
                              .make()
                        ]).marginOnly(left: 5, right: 5),
                    Row(
                      children: [
                        [
                          SvgPicture.asset(
                            'assets/icon/taka_svg.svg',
                            color: darkFontGreyColor,
                            width: 16,
                          ),
                          Text(
                            list[index]["final_price"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: darkFontGreyColor,
                                fontWeight: FontWeight.bold),
                          ).expand(),
                        ].row().expand(),
                        if (list[index]["brand_and_product_offer"] != '0')
                          Align(
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
                                    text: list[index]["initial_price"],
                                    style: TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.bold,
                                      color: FontGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              .expand()
                              .box
                              .padding(EdgeInsets.only(right: 3))
                              .make(),
                      ],
                    ).box.padding(EdgeInsets.all(3)).make(),
                  ],
                ),
              ),
            ),
          ).box.padding(EdgeInsets.all(2)).make();
        }).box.margin(EdgeInsets.only(left: 13, right: 13)).make();
  }
}
