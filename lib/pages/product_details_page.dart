import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:izmir/pages/cart_page_2.dart';
import 'package:izmir/pages/view_full_image.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/images.dart';
import '../consts/strings.dart';
import '../controllers/cart_controller.dart';
import '../controllers/drawer_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/product_heading.dart';
import '../shapes/related_products_class.dart';
import '../shapes/snack_bar.dart';
import 'brand_shop_home_page.dart';
import 'buy_product_page2.dart';
import 'hexcolorMaker_controller.dart';
import 'login_page.dart';

class product_details_page extends StatefulWidget {
  product_details_page({Key? key, required this.product_id}) : super(key: key);
var product_id;

  @override
  State<product_details_page> createState() => _product_details_pageState();
}

class _product_details_pageState extends State<product_details_page> {
  final drawer_controller drawerController = Get.find();
  var related_products = new related_products_class();

  var product_doc_refrence=FirebaseFirestore.instance.collection("products");
  var firebase_instance=FirebaseFirestore.instance;

  RxInt current_txt_index = 0.obs,
      current_color_index = 0.obs,
      current_ml_index = 0.obs,
      ammount = 1.obs;

  var product_details_doc;

  RxDouble product_price = 0.0.obs;

  late BuildContext new_context;

  RxBool is_size_color_selected = false.obs,
      is_color_selected = false.obs,
      isliquid_selected = false.obs,
      isLoaded = false.obs,
      product_available = false.obs,
      isLiked=false.obs;

  RxList<String> size_name = ["XS", "S", "M", "L", "XL", "XXL", "3XL"].obs;

  var product_size_selected_list = [],
      product_color_selected_list = [].obs,
      product_quantity_selected_list = [].obs;

  RxList product_img_list = [].obs;

  var color_selected_listXS = [].obs,
      color_selected_listS = [].obs,
      color_selected_listM = [].obs,
      color_selected_listL = [].obs,
      color_selected_listXL = [].obs,
      color_selected_listXXL = [].obs,
      color_selected_list3XL = [].obs,
      color_selected_list = [].obs,
      liquid_ml_list = [].obs,
      liquid_ml_price_list = [].obs;

  var size_color_quantity_listXS = [].obs,
      size_color_quantity_listS = [].obs,
      size_color_quantity_listM = [].obs,
      size_color_quantity_listL = [].obs,
      size_color_quantity_listXL = [].obs,
      size_color_quantity_listXXL = [].obs,
      size_color_quantity_list3XL = [].obs;

  var selectednumberofsizecolorXS = "".obs,
      selectednumberofsizecolorS = "".obs,
      selectednumberofsizecolorM = "".obs,
      selectednumberofsizecolorL = "".obs,
      selectednumberofsizecolorXL = "".obs,
      selectednumberofsizecolorXXL = "".obs,
      selectednumberofsizecolor3XL = "".obs,
      selectednumberofcolor = "".obs,
      selectednumberofliquid = "".obs;

  RxString present_price = '0'.obs,
      prvious_price = '0'.obs,
      brand_id = ''.obs,
      brand_icon = ''.obs,
      brand_verified = ''.obs,
      product_buying_limit = ''.obs,
      quantity = ''.obs,
      brand_name = ''.obs,
      brand_offer = '0'.obs,
      product_offer = '0'.obs,
      product_like = ''.obs,
      product_ratting = ''.obs,
      product_given_id = ''.obs,
      product_title = ''.obs,
      product_description = ''.obs,
      liked_id = "".obs,
      product_sizechart_img = ''.obs;

  @override
  void initState() {
    load_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    new_context = context;
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: Obx(
        () => CustomScrollView(
          controller: related_products.scrollController,
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
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
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => cart_page_2());
                        Future.delayed(Duration(milliseconds: 200), () async {
                          final cart_controller cartController = Get.find();
                          cartController.is_all_selected.value = false;
                          await cartController.get_product_data();
                        });
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Ink(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: whiteColor,
                          ),
                          child: Center(
                            child: Badge(
                              backgroundColor: orangeColor,
                              label: Text(
                                  "${drawerController.total_items_in_cart.value}"),
                              child: Icon(
                                CupertinoIcons.cart_fill,
                                color: Colors.black,
                              ),
                              isLabelVisible:
                                  drawerController.total_items_in_cart.value ==
                                          0
                                      ? false
                                      : true,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              backgroundColor: whiteColor,
              pinned: true,
              shadowColor: Colors.transparent,
              expandedHeight: het * 0.35,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: het * 0.35,
                  width: double.infinity,
                  child: Swiper(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => view_full_image(),
                              arguments: product_img_list[index]);
                        },
                        child: CachedNetworkImage(
                          imageUrl: product_img_list.length > 0
                              ? product_img_list[index]
                              : '',
                          imageBuilder: (context, url) =>
                              all_product_network_swiper_image_shape(url),
                          placeholder: (context, url) =>
                              all_product_asset_swiper_image_shape(),
                          errorWidget: (context, url, error) =>
                              all_product_asset_swiper_image_shape(),
                        ),
                      );
                    },
                    itemCount: product_img_list.length > 0
                        ? product_img_list.length
                        : 1,
                    pagination: SwiperPagination(
                      alignment: Alignment.bottomLeft,
                      builder: DotSwiperPaginationBuilder(
                          color: lightGreyColor,
                          activeColor: darkBlueColor,
                          size: 6,
                          activeSize: 8),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () {
                      Get.to(() =>
                          brands_shops_home_page(brand_id: brand_id.value));
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: brand_icon.value,
                                      imageBuilder: (context, url) =>
                                          brand_ink_network_image_shape(url),
                                      placeholder: (context, url) =>
                                          brand_ink_asset_image_shape(),
                                      errorWidget: (context, url, error) =>
                                          brand_ink_asset_image_shape(),
                                    ),
                                    Visibility(
                                      visible:
                                          brand_verified.value == "verified"
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
                                Expanded(
                                  child: Text(
                                    brand_name.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ).marginOnly(left: 5),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                brand_offer.value == '0'
                                    ? ''
                                    : '${brand_offer.value}% Extra off',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: orangeColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(top: 5, bottom: 5, left: 2, right: 5),
                    ),
                  ),
                )
                    .box
                    .margin(EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10))
                    .make(),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icon/taka_svg.svg',
                                width: 18,
                              ),
                              Text(
                                present_price_calculation(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: (brand_offer.value != ''
                                            ? double.parse(brand_offer.value)
                                            : 0.0) +
                                        (product_offer.value != ''
                                            ? double.parse(product_offer.value)
                                            : 0.0) ==
                                    0
                                ? false
                                : true,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icon/taka_svg.svg',
                                  width: 15,
                                  color: FontGreyColor,
                                ),
                                Obx(
                                  () => Text(
                                    prvious_price_calculation(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w500,
                                        color: FontGreyColor),
                                  ),
                                ),
                                Text(
                                  "${product_offer.value}% off",
                                  style: TextStyle(
                                    color: orangeColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                )
                                    .box
                                    .color(lightGreyColor)
                                    .rounded
                                    .padding(EdgeInsets.only(
                                        left: 8, right: 8, top: 3, bottom: 3))
                                    .margin(EdgeInsets.only(left: 20))
                                    .make(),
                              ],
                            ).box.margin(EdgeInsets.only(left: 2)).make(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          circuler_small_button(
                              25.0,
                              25.0,
                              darkFontGreyColor,
                              whiteColor,
                              CupertinoIcons.minus,
                              13.0,
                              "decrease"),
                          Obx(
                            () => Text(
                              "${ammount.value}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: chose_button_color(darkFontGreyColor),
                                  fontWeight: FontWeight.w400),
                            )
                                .box
                                .margin(EdgeInsets.only(left: 5, right: 5))
                                .make(),
                          ),
                          circuler_small_button(
                              25.0,
                              25.0,
                              darkFontGreyColor,
                              whiteColor,
                              CupertinoIcons.plus,
                              13.0,
                              "increase"),
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                likes_icon,
                                width: 20,
                                color: isLiked.value?yellowColor:Colors.grey,
                              ).marginOnly(top: 10, bottom: 10, right: 10)
                                  .onTap(() {
                                if (drawerController.pref_userId.value.length > 0) {
                                  isLiked.value=!isLiked.value;
                                  like_dislike();
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => login_page()));
                                }

                              }),
                              Text(
                                product_like.value,
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
                          Text.rich(
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              children: [
                                WidgetSpan(
                                    child: Icon(
                                  CupertinoIcons.star_fill,
                                  size: 18,
                                  color: yellowColor,
                                )),
                                TextSpan(
                                  text: "  ${product_ratting.value}/5",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: darkFontGreyColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Product ID : ${product_given_id.value}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            color: darkFontGreyColor,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  20.heightBox,
                ]).box.padding(EdgeInsets.only(left: 15, right: 15)).make(),
                Visibility(
                  visible: is_size_color_selected.value &&
                          product_quantity_selected_list.length > 0
                      ? true
                      : false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Size ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ).marginOnly(left: 15),
                      square_small_button_with_txt(product_size_selected_list),
                    ],
                  ),
                ),
                Visibility(
                  visible: is_size_color_selected.value &&
                          product_quantity_selected_list.length > 0
                      ? true
                      : false,
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Colors ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ).marginOnly(left: 15),
                        circuler_small_color_button_view(
                            product_color_selected_list[
                                current_txt_index.value]),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: is_color_selected.value &&
                          product_quantity_selected_list.length > 0
                      ? true
                      : false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Colors ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ).marginOnly(left: 15),
                      circuler_small_color_button_view(color_selected_list),
                    ],
                  ),
                ),
                Visibility(
                  visible: isliquid_selected.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Variation ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ).marginOnly(left: 15),
                      square_ml_button_with_txt(liquid_ml_list),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${product_title.value}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: darkFontGreyColor)),
                    20.heightBox,
                    Text(description,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    5.heightBox,
                    Text("${product_description.value}",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15))
                        .box
                        .padding(EdgeInsets.only(left: 5, right: 5))
                        .make(),
                    Visibility(
                      visible: product_sizechart_img.value.toString().length > 1
                          ? true
                          : false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          20.heightBox,
                          Text(size,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          5.heightBox,
                          CachedNetworkImage(
                            imageUrl: product_sizechart_img.value,
                            imageBuilder: (context, url) =>
                                product_size_chart_network_image_shape(url),
                            placeholder: (context, url) =>
                                product_size_chart_asset_image_shape(),
                            errorWidget: (context, url, error) =>
                                product_size_chart_asset_image_shape(),
                          )
                        ],
                      ),
                    ),
                  ],
                )
                    .box
                    .padding(EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 30))
                    .make(),
                Visibility(
                    visible: related_products.list.length != 0,
                    child: product_heading_shape(related_product_txt, false)),
                related_products.related_producs_shape(het, wdt),
                50.heightBox,
              ],
            ))
          ],
        ).box.color(whiteColor).make(),
      ),
      bottomNavigationBar: Obx(
            () => Visibility(
          visible: isLoaded.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  onTap: () async {
                    make_cart(context,"add_cart");
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: yellowColor,
                    ),
                    height: 40.0,
                    width: wdt * 0.35,
                    child: Text(
                      add_cart,
                      style: TextStyle(
                          fontSize: 15.0,
                          color: darkBlueColor,
                          fontWeight: FontWeight.w500),
                    ).box.alignCenter.make(),
                  ),
                ),
              ).box.margin(EdgeInsets.all(3)).make(),
              Material(
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  onTap: () {
                    make_cart(context,"buy_now");
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: darkBlueColor,
                    ),
                    height: 40.0,
                    width: wdt * 0.35,
                    child: Text(
                      buy,
                      style: TextStyle(
                          fontSize: 15.0,
                          color: yellowColor,
                          fontWeight: FontWeight.w500),
                    ).box.alignCenter.make(),
                  ),
                ),
              ).box.margin(EdgeInsets.all(3)).make(),
            ],
          )
              .box
              .height(50)
              .padding(EdgeInsets.only(right: 20))
              .color(whiteColor)
              .border(color: lightGreyColor)
              .make(),
        ),
      ),
    );
  }

  make_cart(context,clicked) {
    if (drawerController.pref_userId.value.length > 0) {
      Map<String, String> new_product = {};
      if (product_available.value == true) {
        new_product = {
          "selected_size": is_size_color_selected.value
              ? product_size_selected_list[current_txt_index.value].toString()
              : "",
          "selected_size_color": is_size_color_selected.value
              ? product_color_selected_list[current_txt_index.value]
                      [current_color_index.value]
                  .toString()
              : "",
          "selected_color": is_color_selected.value
              ? color_selected_list[current_color_index.value].toString()
              : "",
          "selected_variation": isliquid_selected.value
              ? liquid_ml_list[current_ml_index.value].toString()
              : "",
          "product_database_id": widget.product_id.toString(),
          "product_given_id": product_given_id.toString(),
          "product_quantity": ammount.value.toString(),
        };
        if (drawerController.is_limited_and_bought()) {
          show_snackbar(context, product_in_cart_txt, whiteColor, Colors.red);
        } else {
          if(clicked=="add_cart"){
            drawerController.save_cart(brand_name.value.toString(), new_product);
            show_snackbar(
                context, sccs_add_to_cart_txt, yellowColor, darkBlueColor);
          }else if(clicked=="buy_now"){
            Navigator.push(
                context,
                CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) =>buy_product_page2(product_selected_map:new_product)));
          }
        }
      } else {
        show_snackbar(
            new_context, "Product is not available", whiteColor, orangeColor);
      }
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => login_page()));
    }
  }

  present_price_calculation() {
    return present_price.value =
        "${product_offer.value == "0" ? (((isliquid_selected.value ? double.parse(liquid_ml_price_list[current_ml_index.value]) : product_price.value) * ammount.value).toStringAsFixed(0)) : (((isliquid_selected.value ? double.parse(liquid_ml_price_list[current_ml_index.value]) : product_price.value) - ((double.parse(product_offer.value) + double.parse(brand_offer.value)) * (isliquid_selected.value ? double.parse(liquid_ml_price_list[current_ml_index.value]) : product_price.value)) / 100) * ammount.value).toStringAsFixed(0)}";
  }

  prvious_price_calculation() {
    return prvious_price.value =
        "${isliquid_selected.value ? double.parse(liquid_ml_price_list[current_ml_index.value]) * ammount.value : (product_price * ammount.value).toStringAsFixed(0)}";
  }

  load_data() async {
    await product_doc_refrence
        .doc(widget.product_id)
        .snapshots()
        .listen((event) async{
      product_details_doc = event.data();
      brand_id.value = product_details_doc["brand_id"];
      brand_icon.value = product_details_doc["brand_icon"];
      brand_verified.value = product_details_doc["brand_verified"];
      brand_name.value = product_details_doc["brand_name"];
      brand_offer.value = product_details_doc["brand_offer"];
      product_offer.value = product_details_doc["off_percent"];
      product_like.value = product_details_doc["product_likes"].toString();
      product_ratting.value = product_details_doc["product_rating"].toString();
      product_given_id.value = product_details_doc["product_given_id"];
      product_title.value = product_details_doc["product_title"];
      product_description.value = product_details_doc["product_description"];
      product_sizechart_img.value = product_details_doc["size_chart_img"];
      product_buying_limit.value = product_details_doc["product_buying_limit"];
      quantity.value = product_details_doc["quantity"];

      product_img_list.value =
          product_details_doc["product_img"].toString().trim().split("  ");
      product_price.value = double.parse(product_details_doc["initial_price"]);
      current_txt_index.value = 0;
      current_color_index.value = 0;
      current_ml_index.value = 0;

      is_size_color_selected.value =
          product_details_doc["is_size_color_selected"] == "true"
              ? true
              : false;
      is_color_selected.value =
          product_details_doc["is_color_selected"] == "true" ? true : false;
      isliquid_selected.value =
          product_details_doc["is_liquid_selected"] == "true" ? true : false;

      if (is_size_color_selected.value) {
        color_selected_listXS.value =
            product_details_doc["color_selected_listXS"];
        color_selected_listS.value =
            product_details_doc["color_selected_listS"];
        color_selected_listM.value =
            product_details_doc["color_selected_listM"];
        color_selected_listL.value =
            product_details_doc["color_selected_listL"];
        color_selected_listXL.value =
            product_details_doc["color_selected_listXL"];
        color_selected_listXXL.value =
            product_details_doc["color_selected_listXXL"];
        color_selected_list3XL.value =
            product_details_doc["color_selected_list3XL"];

        size_color_quantity_listXS.value =
            product_details_doc["size_color_quantity_listXS"];
        size_color_quantity_listS.value =
            product_details_doc["size_color_quantity_listS"];
        size_color_quantity_listM.value =
            product_details_doc["size_color_quantity_listM"];
        size_color_quantity_listL.value =
            product_details_doc["size_color_quantity_listL"];
        size_color_quantity_listXL.value =
            product_details_doc["size_color_quantity_listXL"];
        size_color_quantity_listXXL.value =
            product_details_doc["size_color_quantity_listXXL"];
        size_color_quantity_list3XL.value =
            product_details_doc["size_color_quantity_list3XL"];

        product_size_selected_list.clear();
        product_color_selected_list.clear();
        product_quantity_selected_list.clear();

        if (color_selected_listXS.length > 1 ||
            color_selected_listXS[0] != white_color_hex ||
            size_color_quantity_listXS[0] != "0") {
          product_size_selected_list.add(size_name[0]);
          product_color_selected_list.add(color_selected_listXS);
          product_quantity_selected_list.add(size_color_quantity_listXS);
        }
        if (color_selected_listS.length > 1 ||
            color_selected_listS[0] != white_color_hex ||
            size_color_quantity_listS[0] != "0") {
          product_size_selected_list.add(size_name[1]);
          product_color_selected_list.add(color_selected_listS);
          product_quantity_selected_list.add(size_color_quantity_listS);
        }
        if (color_selected_listM.length > 1 ||
            color_selected_listM[0] != white_color_hex ||
            size_color_quantity_listM[0] != "0") {
          product_size_selected_list.add(size_name[2]);
          product_color_selected_list.add(color_selected_listM);
          product_quantity_selected_list.add(size_color_quantity_listM);
        }
        if (color_selected_listL.length > 1 ||
            color_selected_listL[0] != white_color_hex ||
            size_color_quantity_listL[0] != "0") {
          product_size_selected_list.add(size_name[3]);
          product_color_selected_list.add(color_selected_listL);
          product_quantity_selected_list.add(size_color_quantity_listL);
        }
        if (color_selected_listXL.length > 1 ||
            color_selected_listXL[0] != white_color_hex ||
            size_color_quantity_listXL[0] != "0") {
          product_size_selected_list.add(size_name[4]);
          product_color_selected_list.add(color_selected_listXL);
          product_quantity_selected_list.add(size_color_quantity_listXL);
        }
        if (color_selected_listXXL.length > 1 ||
            color_selected_listXXL[0] != white_color_hex ||
            size_color_quantity_listXXL[0] != "0") {
          product_size_selected_list.add(size_name[5]);
          product_color_selected_list.add(color_selected_listXXL);
          product_quantity_selected_list.add(size_color_quantity_listXXL);
        }
        if (color_selected_list3XL.length > 1 ||
            color_selected_list3XL[0] != white_color_hex ||
            size_color_quantity_list3XL[0] != "0") {
          product_size_selected_list.add(size_name[6]);
          product_color_selected_list.add(color_selected_list3XL);
          product_quantity_selected_list.add(size_color_quantity_list3XL);
        }
      } else if (is_color_selected.value) {
        color_selected_list.value = product_details_doc["color_selected_list"];
        product_quantity_selected_list
            .add(product_details_doc["color_quantity_list"]);
      } else if (isliquid_selected.value) {
        liquid_ml_list.value = product_details_doc["liquid_ml_list"];
        product_quantity_selected_list
            .add(product_details_doc["liquid_quantity_list"]);
        liquid_ml_price_list.value =
            product_details_doc["liquid_ml_price_list"];
      }
      isLoaded.value=true;
      if (product_quantity_selected_list[0][0] == '0') ammount.value = 0;
      final collectionRef = await FirebaseFirestore.instance
          .collection("products")
          .where("category_name",
              isEqualTo: product_details_doc["category_name"]);
      related_products.change_data(collectionRef);
    });
    try{
      product_doc_refrence
          .doc(widget.product_id)
          .collection("likes").where("user_id",isEqualTo: drawerController.pref_userId.value)
          .snapshots().listen((value){
        if(value.docs.length>0){
          isLiked.value=true;
          liked_id.value=value.docs.first.id;
        }
      });
    }catch(e){

    }
  }

  like_dislike()async{
    final batch = firebase_instance.batch();
    var likeRef =  await product_doc_refrence
        .doc(widget.product_id)
        .collection("likes");
    if(isLiked.value){
      batch.set(likeRef.doc(),{
        "user_id":drawerController.pref_userId.value,
        "time":new DateTime.now().microsecondsSinceEpoch.toString()
      });
    }else{
      batch.delete(likeRef.doc(liked_id.value));
    }
    var productRef = await product_doc_refrence.doc(widget.product_id);
    batch.update(productRef,{"product_likes": isLiked.value?FieldValue.increment(1):FieldValue.increment(-1)});
    batch.commit();
  }

  Widget circuler_small_button(
      het, wdt, button_color, icon_color, icn, icn_size, indicator) {
    return Material(
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: () {
          if (indicator == "increase" && ammount.value < 1000) {
            if (is_size_color_selected.value ||
                is_color_selected.value ||
                isliquid_selected.value) {
              if (int.parse(product_buying_limit.value) > 0 &&
                  (int.parse(product_quantity_selected_list[
                                  current_txt_index.value][
                              isliquid_selected.value
                                  ? current_ml_index.value
                                  : current_color_index.value]) <=
                          ammount.value ||
                      int.parse(product_buying_limit.value) <= ammount.value)) {
                if (product_available.value == true) {
                  show_snackbar(
                      new_context,
                      cants_buy_more_txt + "${ammount.value} items",
                      whiteColor,
                      orangeColor);
                } else {
                  show_snackbar(new_context, "Product is not available",
                      whiteColor, orangeColor);
                }
              } else
                ammount.value++;
            } else {
              if (int.parse(product_buying_limit.value) > 0 &&
                  int.parse(product_buying_limit.value) <=
                      ammount.value) if (product_available.value == true) {
                show_snackbar(
                    new_context,
                    cants_buy_more_txt + "${ammount.value} items",
                    whiteColor,
                    orangeColor);
              } else {
                show_snackbar(new_context, "Product is not available",
                    whiteColor, orangeColor);
              }
              else
                ammount.value++;
            }
          } else if (indicator == "decrease" && ammount.value > 1) {
            ammount.value--;
          }
        },
        borderRadius: BorderRadius.circular(6),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(width: 1, color: lightGreyColor),
            color: chose_button_color(button_color),
          ),
          height: het,
          width: wdt,
          child: Icon(icn, color: icon_color, size: icn_size),
        ),
      ),
    );
  }

  chose_button_color(button_color) {
    if (is_size_color_selected.value ||
        is_color_selected.value ||
        isliquid_selected.value) {
      if (product_quantity_selected_list[current_txt_index.value][
              isliquid_selected.value
                  ? current_ml_index.value
                  : current_color_index.value] ==
          '0') {
        product_available.value = false;
        return lightGreyColor;
      } else {
        product_available.value = true;
        return button_color;
      }
    } else {
      if (quantity.value == '0') {
        product_available.value = false;
        return lightGreyColor;
      } else {
        product_available.value = true;
        return button_color;
      }
    }
  }

  Widget square_small_button_with_txt(size_variation_list) {
    return Container(
      height: 55,
      width: double.infinity,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: size_variation_list.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                current_color_index.value = 0;
                current_txt_index.value = index;
                product_quantity_selected_list[current_txt_index.value]
                            [current_color_index.value] ==
                        "0"
                    ? ammount.value = 0
                    : ammount.value = 1;
              },
              child: Obx(
                () => Container(
                  margin: EdgeInsets.only(
                      left: index == 0 ? 15 : 10,
                      top: 15,
                      bottom: 15,
                      right: index == size_variation_list.length - 1 ? 15 : 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: lightGreyColor,
                      border: Border.all(
                        color: current_txt_index.value == index
                            ? yellowColor
                            : textFieldGreyColor,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: current_txt_index.value == index
                              ? CupertinoColors.systemGrey3
                              : whiteColor,
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ]),
                  width: 50,
                  child: Text("${size_variation_list[index]}"),
                ),
              ),
            );
          }),
    );
  }

  Widget circuler_small_color_button_view(variations) {
    return Container(
      height: 55,
      width: double.infinity,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: variations.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                current_color_index.value = index;
                variations[current_color_index.value] == "0"
                    ? ammount.value = 0
                    : ammount.value = 1;
              },
              child: Obx(
                () => Container(
                  margin: EdgeInsets.only(
                      left: index == 0 ? 15 : 10,
                      top: 15,
                      bottom: 15,
                      right: index == variations.length - 1 ? 15 : 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: hexColor(variations[index]),
                      border: Border.all(
                        color: current_color_index.value == index
                            ? yellowColor
                            : textFieldGreyColor,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: current_color_index.value == index
                              ? CupertinoColors.systemGrey3
                              : whiteColor,
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ]),
                  height: 25,
                  width: 25,
                ),
              ),
            );
          }),
    );
  }

  Widget square_ml_button_with_txt(ml_variation_list) {
    return Container(
      height: 55,
      width: double.infinity,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: ml_variation_list.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                current_ml_index.value = index;
                product_quantity_selected_list[0][current_ml_index.value] == "0"
                    ? ammount.value = 0
                    : ammount.value = 1;
              },
              child: Obx(
                () => Container(
                  margin: EdgeInsets.only(
                      left: index == 0 ? 15 : 10,
                      top: 15,
                      bottom: 15,
                      right: index == ml_variation_list.length - 1 ? 15 : 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: lightGreyColor,
                      border: Border.all(
                        color: current_ml_index.value == index
                            ? yellowColor
                            : textFieldGreyColor,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: current_ml_index.value == index
                              ? CupertinoColors.systemGrey3
                              : whiteColor,
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ]),
                  child: Text("${ml_variation_list[index]}")
                      .paddingOnly(left: 5, right: 5),
                ),
              ),
            );
          }),
    );
  }
}
