import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:izmir/consts/consts.dart';
import 'package:izmir/pages/hexcolorMaker_controller.dart';
import 'package:izmir/pages/product_details_page.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/cart_controller_2.dart';
import '../controllers/drawer_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/orders_shape.dart';
import 'brand_shop_home_page.dart';

class my_orders_page extends StatefulWidget {
  my_orders_page({Key? key}) : super(key: key);

  @override
  State<my_orders_page> createState() => _my_orders_pageState();
}

class _my_orders_pageState extends State<my_orders_page> {
  final drawer_controller drawerController = Get.find();
  var _instance = FirebaseFirestore.instance;
  var _orders_refrence = FirebaseFirestore.instance.collection("orders");
  RxList order_batch = [].obs, order_batch_ids = [].obs;
  RxMap<String, List<dynamic>> products_map = RxMap();
  RxMap<String, List<dynamic>> products_id_map = RxMap();


  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () async {
      fetch_data();
    });
    super.initState();
  }

  fetch_data() async {
    await _instance
        .collection("order_info")
        .where("customer_database_id",
            isEqualTo: drawerController.pref_userId.value)
        .orderBy("total_order_time", descending: true)
        .get()
        .then((valu) async {

      await Future.forEach(valu.docs, (element) async {
        order_batch_ids.add(element.id);
        List order_ids = [];
        await _orders_refrence
            .where("order_id", isEqualTo: element.id)
            .orderBy("shop_database_id", descending: false)
            .get()
            .then((val) {
          List orders = [];
          orders.addAll(val.docs.map((e) => e.data()));
          products_map[element.id] = orders;
          for(var v in  val.docs)order_ids.add(v.id);
        });
        products_id_map[element.id]=order_ids;
      });
      order_batch.addAll(valu.docs.map((e) => e.data()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            bar_with_back_button(context,my_orders_txt),
           Expanded(
              child: Obx(
                () => order_batch.isEmpty
                    ? Center(
                        child: CupertinoActivityIndicator(radius: 10)
                            .box
                            .alignCenter
                            .margin(EdgeInsets.only(bottom: 50))
                            .make())
                    : CustomScrollView(
                  cacheExtent: 5,
                  physics:  const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  slivers: [
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                        (context,index1){
                          List l = products_map[order_batch_ids[index1]]!;
                          return CustomScrollView(
                                cacheExtent: 5,
                                shrinkWrap: true,
                                physics:  const NeverScrollableScrollPhysics(),
                                slivers: [
                                  SliverToBoxAdapter(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Order Id : ${order_batch_ids[index1]}\n"
                                              "Order by : ${order_batch[index1]["customer_name"]}\n"
                                              "Phone : ${order_batch[index1]["customer_phone"]}\n"
                                              "Emain : ${order_batch[index1]["customer_email"]}\n"
                                              "Referral code used : ${order_batch[index1]["referral_code"] == '' ? "-" : order_batch[index1]["referral_code"]}\n"
                                              "Total product price : ${order_batch[index1]["total_product_price"]}\n"
                                              "Account Balance Used : - ${order_batch[index1]["account_balance_used"]}\n"
                                              "Offer on Refer : - ${order_batch[index1]["off_on_refer"]}\n"
                                              "Delivery fee : ${order_batch[index1]["delivery_fee"]}\n"
                                              "Total payment : ${order_batch[index1]["total_payment"]}\n"
                                              "${order_batch[index1]["customer_district"]}, "
                                              "${order_batch[index1]["customer_division"]}\n"
                                              "${order_batch[index1]["customer_full_address"]}\n"
                                              "Order time : ${DateFormat('h:mm a , MMM d, yyyy')
                                              .format(DateTime.fromMillisecondsSinceEpoch((int.parse(order_batch[index1]["total_order_time"])
                                              / 1000).toInt()).toLocal())}",
                                          style: TextStyle(
                                              color: darkFontGreyColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          "${order_batch[index1]["paid"] == "true" ? "Paid" : "Not paid"}",
                                          style: TextStyle(
                                              color: order_batch[index1]["paid"] ==
                                                  "true"
                                                  ? yellowColor
                                                  : darkBlueColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        )
                                            .box
                                            .color(
                                            order_batch[index1]["paid"] == "true"
                                                ? darkBlueColor
                                                : yellowColor)
                                            .rounded
                                            .padding(EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 0.5,
                                            bottom: 1))
                                            .make(),
                                      ],
                                    )
                                        .box
                                        .width(double.infinity)
                                        .customRounded(
                                        BorderRadius.all(Radius.circular(6.0)))
                                        .padding(EdgeInsets.all(10))
                                        .color(lightGreyColor)
                                        .make(),
                                  ),
                                  SliverList(delegate: SliverChildBuilderDelegate(
                                  (context,index2){
                                    return Column(children: [
                                      Visibility(
                                        visible: 0 == index2
                                            ? true
                                            : (l.length - 1 == index2
                                            ? false
                                            : l[index2]["order_id"] ==
                                            l[index2 + 1]["order_id"]),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(6),
                                          child: InkWell(
                                            borderRadius:
                                            BorderRadius.circular(6),
                                            onTap: () {
                                              Get.to(() => brands_shops_home_page(
                                                  brand_id: l[index2]
                                                  ["shop_database_id"]));
                                            },
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(6),
                                                  color: lightGreyColor),
                                              child: Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: l[index2]
                                                    ["shop_icon"],
                                                    imageBuilder: (context,
                                                        url) =>
                                                        brand_ink_network_image_shape(
                                                            url),
                                                    placeholder: (context, url) =>
                                                        brand_ink_asset_image_shape(),
                                                    errorWidget: (context, url,
                                                        error) =>
                                                        brand_ink_asset_image_shape(),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        l[index2]["shop_name"],
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                            darkFontGreyColor,
                                                            fontWeight:
                                                            FontWeight.w400),
                                                      ),
                                                      Text(
                                                        "${l[index2]["shop_district"]}, ${l[index2]["shop_division"]}, "
                                                            "( ${l[index2]["shop_full_address"]} )",
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                            darkFontGreyColor,
                                                            fontWeight:
                                                            FontWeight.w400),
                                                      )
                                                    ],
                                                  ).marginOnly(left: 5)
                                                ],
                                              ).paddingOnly(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 5,
                                                  right: 10),
                                            ),
                                          ),
                                        ).marginOnly(top: 2.5, bottom: 2.5),
                                      ),
                                      Material(
                                        borderRadius: BorderRadius.circular(6),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(6),
                                          onTap: () {

                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) =>
                                                        product_details_page(
                                                            product_id: l[index2]["product_database_id"])));
                                          },
                                          child: Ink(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(6),
                                                color: lightGreyColor),
                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl: l[index2]["product_image"],
                                                        imageBuilder: (context,
                                                            url) =>
                                                            cart_network_image_shape(
                                                                url),
                                                        placeholder: (context,
                                                            url) =>
                                                            cart_asset_image_shape(),
                                                        errorWidget: (context,
                                                            url, error) =>
                                                            cart_asset_image_shape(),
                                                      ).marginOnly(left: 5),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                              l[index2]["product_title"]+para,
                                                              maxLines: 2,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color:
                                                                  darkFontGreyColor,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ),
                                                            7.heightBox,
                                                            Visibility(
                                                              visible: l[index2]["product_size"] ==
                                                                  ""
                                                                  ? false
                                                                  : true,
                                                              child: Text(
                                                                "Size : ${l[index2]["product_size"]}",
                                                                style: TextStyle(
                                                                    color:
                                                                    darkFontGreyColor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                    fontSize: 14),
                                                              ),
                                                            ),
                                                            2.heightBox,
                                                            Visibility(
                                                              visible: l[index2]["product_color"] ==
                                                                  ""
                                                                  ? false
                                                                  : true,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Color : ",style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                      color: darkFontGreyColor
                                                                  ),),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                        left:
                                                                        5,
                                                                        right:
                                                                        5),
                                                                    alignment:
                                                                    Alignment
                                                                        .center,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(6),
                                                                      color: hexColor(l[index2]["product_color"]),
                                                                      border:
                                                                      Border
                                                                          .all(
                                                                        color:
                                                                        textFieldGreyColor,

                                                                        width: 1,
                                                                      ),
                                                                    ),
                                                                    height: 15,
                                                                    width: 30,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            2.heightBox,
                                                            Visibility(
                                                              visible: l[index2]["product_variation"] ==
                                                                  ""
                                                                  ? false
                                                                  : true,
                                                              child: Text(
                                                                "Variation : ${l[index2]["product_variation"]}",
                                                                style: TextStyle(
                                                                    color:
                                                                    darkFontGreyColor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                    fontSize: 14),
                                                              ),
                                                            ),
                                                            2.heightBox,
                                                            Text.rich(
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              TextSpan(
                                                                children: [
                                                                  WidgetSpan(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/icon/taka_svg.svg',
                                                                        width: 16,
                                                                        color:
                                                                        darkFontGreyColor,
                                                                      )),
                                                                  TextSpan(
                                                                    text: l[index2]["product_price"],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        16,
                                                                        color:
                                                                        darkFontGreyColor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ).marginOnly(right: 100),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      4.heightBox,
                                                      if(l[index2]["order_activity"]=="In shop" ||l[index2]["order_activity"]=="Out from shop" ||
                                                          l[index2]["order_activity"]=="Delivered")
                                                        Material(
                                                          borderRadius: BorderRadius.circular(6),
                                                          child: InkWell(
                                                            onTap: () {
                                                              if(l[index2]["order_activity"]=="In shop"||l[index2]["order_activity"]=="Out from shop"){
                                                                showAlertDialog(context,products_id_map[order_batch_ids[index1]]![index2],"cancel_order");
                                                              }
                                                              if(l[index2]["order_activity"]=="Delivered"){
                                                                showAlertDialog(context,products_id_map[order_batch_ids[index1]]![index2],"return");
                                                              }
                                                            },
                                                            borderRadius: BorderRadius.circular(6),
                                                            child: Ink(
                                                              padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(6),
                                                                  color: l[index2]["order_activity"]=="In shop"
                                                                      ||l[index2]["order_activity"]=="Out from shop"
                                                                      || l[index2]["order_activity"]=="Delivered"
                                                                      ?Colors.green:orangeColor
                                                              ),
                                                              child: Text(
                                                                (l[index2]["order_activity"]=="Delivered"?"Return":
                                                                (l[index2]["order_activity"]=="In shop"
                                                                    ||l[index2]["order_activity"]=="Out from shop"
                                                                    ?"Cancel order":"Canceled")),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: lightGreyColor,
                                                                    fontWeight:
                                                                    FontWeight.w500),),
                                                            ),
                                                          ),
                                                        ).box.margin(EdgeInsets.only(right: 5)).make(),
                                                      l[index2]["order_activity"]=="In shop"
                                                          ||l[index2]["order_activity"]=="Out from shop"
                                                          || l[index2]["order_activity"]=="Delivered"?
                                                      20.heightBox:45.heightBox,
                                                      Text(
                                                        "${l[index2]["order_activity"]}",
                                                        style: TextStyle(
                                                            color:l[index2]["order_activity"]=="Delivered"?Colors.green:
                                                            darkBlueColor,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 14),
                                                      ).box.margin(EdgeInsets.only(right: 5)).make(),
                                                      20.heightBox,
                                                      Text(
                                                        "Quantity : ${l[index2]["product_quantity"]}",
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: darkFontGreyColor,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                      ).box.margin(EdgeInsets.only(right: 5)).make(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).box.margin(EdgeInsets.only(top: 2, bottom: l.length -1 ==index2? 10: 5)).make()
                                    ]);
                                   }, childCount: l.length
                                  ))
                                ],
                              ).marginOnly(left: 15, right: 15,bottom: 10);
                        },childCount: order_batch.length,
                    ))
                  ],
                )
              ),
            )
          ],
        ),
      ).box.color(whiteColor).make(),
    );
  }


  showAlertDialog(BuildContext context,product_ordered_id,alert_for) async =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: new Text(
            'Are you sure?',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
          ),
          content: new Text(
            alert_for=="cancel_order"?"Do you really want to Cancel this Order ?":
            "Do you really want to return this product ?",
            style: TextStyle(fontSize: 14, color: darkBlueColor),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(),
              child: new Text('No'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => {
                _orders_refrence.doc(product_ordered_id)
                    .update({
                  "order_activity":alert_for=="cancel_order"?"Canceled":"Applied for return",
                "return_apply_time":alert_for=="cancel_order"?"":new DateTime.now().microsecondsSinceEpoch.toString()
                }),
                Navigator.of(context).pop()
              },
              child: new Text('Yes'),
            ),
          ],
        ),
      );

}
