import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izmir/consts/consts.dart';
import 'package:get/get.dart';
import 'package:izmir/pages/product_details_page.dart';
import 'package:velocity_x/velocity_x.dart';
import '../controllers/cart_controller_2.dart';
import '../controllers/drawer_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/dont_have_any_data.dart';
import '../shapes/orders_shape.dart';
import 'hexcolorMaker_controller.dart';



class returns_page extends StatefulWidget {
  returns_page({Key? key}) : super(key: key);

  @override
  State<returns_page> createState() => _returns_pageState();
}

class _returns_pageState extends State<returns_page> {

  final drawer_controller drawerController = Get.find();
  var _instance = FirebaseFirestore.instance;
  RxList order_batch = [].obs, order_batch_ids = [].obs;
  RxBool is_loading_finished=false.obs;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () async {
      fetch_data();
    });
    super.initState();
  }

  fetch_data() async {
    try{
      await _instance
          .collection("orders")
         .where("customer_database_id",
          isEqualTo: drawerController.pref_userId.value)
          .where("order_activity",
          whereIn: ["Applied for return","Returned"])
          .orderBy("return_apply_time", descending: true)
          .get()
          .then((valu) async {
        for(var val in valu.docs) order_batch_ids.add(val.id);
        order_batch.addAll(valu.docs.map((e) => e.data()));
      });
    }catch(e){

    }
    is_loading_finished.value=true;
  }

  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            bar_with_back_button(context,returns_txt),
            Flexible(
              child: Obx(()=>
              is_loading_finished.value==false?
              Center(
                  child: CupertinoActivityIndicator(radius: 10)
                      .box
                      .alignCenter
                      .margin(EdgeInsets.only(bottom: 50))
                      .make()):
              (order_batch.isEmpty && is_loading_finished.value==true
                  ?dont_have_any_data(het)
                  :
              CustomScrollView(
                    cacheExtent: 5,
                    shrinkWrap: true,
                    physics:  const BouncingScrollPhysics(),
                    slivers: [
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (context,index){
                            return Material(
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
                                                  product_id:order_batch_ids[index]["product_database_id"])));
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
                                              imageUrl: order_batch[index]["product_image"],
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
                                                    order_batch[index]["product_title"]+para,
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
                                                    visible: order_batch[index]["product_size"] ==
                                                        ""
                                                        ? false
                                                        : true,
                                                    child: Text(
                                                      "Size : ${order_batch[index]["product_size"]}",
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
                                                    visible: order_batch[index]["product_color"] ==
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
                                                            color: hexColor(order_batch[index]["product_color"]),
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
                                                    visible: order_batch[index]["product_variation"] ==
                                                        ""
                                                        ? false
                                                        : true,
                                                    child: Text(
                                                      "Variation : ${order_batch[index]["product_variation"]}",
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
                                                          text: order_batch[index]["product_price"],
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
                                            70.heightBox,
                                            Text(
                                              "${order_batch[index]["order_activity"]}",
                                              style: TextStyle(
                                                  color:order_batch[index]["order_activity"]=="Delivered"?Colors.green:
                                                  darkBlueColor,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 14),
                                            ).box.margin(EdgeInsets.only(right: 5)).make(),
                                            20.heightBox,
                                            Text(
                                              "Quantity : ${order_batch[index]["product_quantity"]}",
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
                            ).marginOnly(left: 15, right: 15,bottom: 2);
                          }, childCount: order_batch.length
                      ))
                    ],
                  )
              ),
            ))
          ],
        ),
      ).color(whiteColor),
    );
  }
}
