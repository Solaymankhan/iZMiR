import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import '../controllers/brand_shop_drawer_controller.dart';
import '../controllers/brands_controller.dart';
import '../controllers/cart_controller_2.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/brand_shop_drawer.dart';
import 'brand_shop_home_page.dart';
import 'hexcolorMaker_controller.dart';

class brand_shop_dashboard_page extends StatefulWidget {
  brand_shop_dashboard_page(
      {Key? key, required this.brand_details, required this.brand_id})
      : super(key: key);
  var brand_details, brand_id;

  @override
  State<brand_shop_dashboard_page> createState() =>
      order_overview_brand_shopState();
}

class order_overview_brand_shopState extends State<brand_shop_dashboard_page> {
  final brands_controller brandController = Get.find();
  final brandShopDrawerController = Get.put(brand_shop_drawer_controller());

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 400), () async{
     fetch_everything();
    });
    super.initState();
  }

  @override
  void dispose() {
    brandShopDrawerController.current_index.value = 0;
    super.dispose();
  }


  fetch_everything(){
    brandShopDrawerController.brand_id.value = widget.brand_id;
    brandShopDrawerController.fetch_dash_board(widget.brand_details);
    brandShopDrawerController.call_for_fetch_data("In shop");
  }

  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: brandShopDrawerController.scaffold_key,
      drawer: GetBuilder<brand_shop_drawer_controller>(builder: (controller) {
        return brand_shop_drawer();
      }),
      body: SafeArea(
        child: Obx(
          () => CustomScrollView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        height: 50,
                        margin: EdgeInsets.only(right: 10),
                        child: Material(
                          child: InkWell(
                            onTap: () async {
                              Get.back();
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Ink(
                                height: 40,
                                width: 40,
                                color: whiteColor,
                                child: Icon(CupertinoIcons.back,
                                    color: darkFontGreyColor)),
                          ),
                        )),
                    CachedNetworkImage(
                      imageUrl: widget.brand_details["brand_icon"],
                      imageBuilder: (context, url) =>
                          brand_ink_network_image_shape(url),
                      placeholder: (context, url) =>
                          brand_ink_asset_image_shape(),
                      errorWidget: (context, url, error) =>
                          brand_ink_asset_image_shape(),
                    ).marginOnly(right: 5),
                    Expanded(
                      child: Text(
                        widget.brand_details["brand_name"],
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            color: darkFontGreyColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        height: 50,
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              brandShopDrawerController.openDrawer();
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Ink(
                                height: 40,
                                width: 40,
                                color: whiteColor,
                                child: Icon(
                                  CupertinoIcons.bars,
                                  color: darkFontGreyColor,
                                )),
                          ),
                        ))
                  ],
                ).box.padding(EdgeInsets.only(top: 5)).make(),
                backgroundColor: whiteColor,
                pinned: true,
                shadowColor: Colors.transparent,
                expandedHeight: 50,
              ),
              SliverToBoxAdapter(
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          brandShopDrawerController.dash_board_list.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 600 > wdt ? 2 : 5,
                          mainAxisExtent: 90),
                      itemBuilder: (context, index) {
                        return [
                          "${brandShopDrawerController.dash_board_list[index]["title"]}"
                              .text
                              .size(16)
                              .fontWeight(FontWeight.bold)
                              .color(whiteColor)
                              .make(),
                          [
                            if (brandShopDrawerController.dash_board_list[index]
                                    ["type"] ==
                                "taka")
                              SvgPicture.asset(
                                'assets/icon/taka_svg.svg',
                                width: 24,
                                color: whiteColor,
                              ),
                            "${brandShopDrawerController.dash_board_list[index]["value"]}"
                                .text
                                .size(24)
                                .fontWeight(FontWeight.bold)
                                .color(whiteColor)
                                .make()
                          ].row(),
                        ]
                            .column(crossAlignment: CrossAxisAlignment.start)
                            .box
                            .linearGradient([
                              brandShopDrawerController.dash_board_list[index]
                                  ["starting_color"],
                              brandShopDrawerController.dash_board_list[index]
                                  ["ending_color"]
                            ])
                            .customRounded(BorderRadius.circular(6))
                            .margin(EdgeInsets.all(2))
                            .padding(EdgeInsets.all(15))
                            .make();
                      }).marginOnly(left: 13, right: 13)),
              SliverPersistentHeader(
                pinned: true,
                delegate: Delegate(),
              ),
              SliverToBoxAdapter(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:brandShopDrawerController.orders.length,
                      itemBuilder: (context, index2) {
                        return  [
                          CachedNetworkImage(
                            imageUrl: brandShopDrawerController.orders[index2]
                            ["product_image"],
                            imageBuilder: (context, url) =>
                                cart_network_image_shape(url),
                            placeholder: (context, url) => cart_asset_image_shape(),
                            errorWidget: (context, url, error) =>
                                cart_asset_image_shape(),
                          ),
                          [
                            "${brandShopDrawerController.orders[index2]["product_title"]}"
                                .text
                                .size(16)
                                .fontWeight(FontWeight.w500)
                                .maxLines(2)
                                .overflow(TextOverflow.ellipsis)
                                .color(darkFontGreyColor)
                                .make(),
                            2.heightBox,
                            "Product ID : ${brandShopDrawerController.orders[index2]["product_given_id"]}"
                                .text
                                .size(13)
                                .maxLines(1)
                                .overflow(TextOverflow.ellipsis)
                                .color(darkFontGreyColor)
                                .textStyle(TextStyle(fontWeight: FontWeight.w500))
                                .make(),
                            2.heightBox,
                            "Customer Email : ${brandShopDrawerController.orders[index2]["customer_email"]}"
                                .text
                                .size(13)
                                .maxLines(1)
                                .overflow(TextOverflow.ellipsis)
                                .color(darkFontGreyColor)
                                .textStyle(TextStyle(fontWeight: FontWeight.w500))
                                .make(),
                            2.heightBox,
                            "Order time : ${DateFormat('h:mm a , MMM d, yyyy').format(DateTime.fromMillisecondsSinceEpoch((int.parse(brandShopDrawerController.orders[index2]["order_time"]) / 1000).toInt()).toLocal())}"
                                .text
                                .size(13)
                                .maxLines(1)
                                .overflow(TextOverflow.ellipsis)
                                .color(darkFontGreyColor)
                                .textStyle(TextStyle(fontWeight: FontWeight.w500))
                                .make(),
                            7.heightBox,
                            if (brandShopDrawerController.orders[index2]
                            ["product_size"] !=
                                "")
                              "Size : ${brandShopDrawerController.orders[index2]["product_size"]}"
                                  .text
                                  .color(darkFontGreyColor)
                                  .textStyle(TextStyle(fontWeight: FontWeight.w500))
                                  .make(),
                            2.heightBox,
                            [
                              brandShopDrawerController.orders[index2]
                              ["product_color"] ==
                                  ""
                                  ? ((brandShopDrawerController.orders[index2]
                              ["product_variation"] ==
                                  "")
                                  ? Container()
                                  : "Variation : ${brandShopDrawerController.orders[index2]["product_variation"]}"
                                  .text
                                  .textStyle(
                                  TextStyle(fontWeight: FontWeight.w500))
                                  .color(darkFontGreyColor)
                                  .make())
                                  : [
                                "Color : "
                                    .text
                                    .color(darkFontGreyColor)
                                    .textStyle(
                                    TextStyle(fontWeight: FontWeight.w500))
                                    .make(),
                                Container()
                                    .box
                                    .color(hexColor(brandShopDrawerController
                                    .orders[index2]["product_color"]))
                                    .border(color: darkFontGreyColor)
                                    .rounded
                                    .margin(EdgeInsets.only(left: 5, right: 5))
                                    .height(15)
                                    .width(30)
                                    .make()
                              ].row(),
                              "Quantity : ${brandShopDrawerController.orders[index2]["product_quantity"]}"
                                  .text
                                  .textStyle(TextStyle(fontWeight: FontWeight.w500))
                                  .color(darkFontGreyColor)
                                  .make()
                            ]
                                .row(alignment: MainAxisAlignment.spaceBetween)
                                .box
                                .width(double.infinity)
                                .make(),
                            2.heightBox,
                            if (brandShopDrawerController.orders[index2]
                            ["product_variation"] !=
                                "")
                              "Variation : ${brandShopDrawerController.orders[index2]["product_variation"]}"
                                  .text
                                  .textStyle(TextStyle(fontWeight: FontWeight.w500))
                                  .color(darkFontGreyColor)
                                  .make(),
                            2.heightBox,
                            [
                              [
                                SvgPicture.asset(
                                  'assets/icon/taka_svg.svg',
                                  width: 16,
                                  color: darkFontGreyColor,
                                ),
                                "${brandShopDrawerController.orders[index2]["product_price"]}"
                                    .text
                                    .bold
                                    .color(darkFontGreyColor)
                                    .size(16)
                                    .make()
                              ].row(),
                              "${brandShopDrawerController.orders[index2]["order_activity"]}"
                                  .text
                                  .bold
                                  .color(lightGreyColor)
                                  .make()
                                  .box
                                  .color(Colors.green)
                                  .customRounded(BorderRadius.circular(6))
                                  .padding(EdgeInsets.only(
                                  left: 5, right: 5, top: 1, bottom: 1))
                                  .make()
                            ]
                                .row(alignment: MainAxisAlignment.spaceBetween)
                                .box
                                .width(double.infinity)
                                .make(),
                          ].column(crossAlignment: CrossAxisAlignment.start).expand(),
                        ]
                            .row()
                            .box
                            .customRounded(BorderRadius.circular(6))
                            .padding(
                            EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2))
                            .color(lightGreyColor)
                            .make()
                            .marginOnly(left: 15, right: 15, top: 2, bottom: 2);
                      })),
            ],
          ),
        ),
      ).color(whiteColor),
    );
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  final brand_shop_drawer_controller brandShopDrawerController = Get.find();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: brandShopDrawerController.order_activity_list.length,
          itemBuilder: (context, index) {
            return "${brandShopDrawerController.order_activity_list[index]}"
                .text
                .fontWeight(
                    brandShopDrawerController.current_index.value == index
                        ? FontWeight.bold
                        : FontWeight.w500)
                .color(brandShopDrawerController.current_index.value == index
                    ? darkBlueColor
                    : darkFontGreyColor)
                .size(brandShopDrawerController.current_index.value == index
                    ? 16
                    : 14)
                .make()
                .box
                .customRounded(BorderRadius.circular(6))
                .alignCenter
                .padding(EdgeInsets.only(left: 10, right: 10))
                .margin(EdgeInsets.only(
                    left: index == 0 ? 15 : 5,
                    right: index ==
                            brandShopDrawerController.order_activity_list.length -
                                1
                        ? 15
                        : 0))
                .color(brandShopDrawerController.current_index.value == index
                    ? yellowColor
                    : whiteColor)
                .make()
                .onInkTap(() {
              brandShopDrawerController.current_index.value = index;
              brandShopDrawerController.call_for_fetch_data(index==0?"In shop":brandShopDrawerController.order_activity_list[index]);
            });
          }),
    ).box.color(whiteColor).padding(EdgeInsets.only(top: 5, bottom: 5)).make();
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
