import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izmir/controllers/brands_controller.dart';
import 'package:izmir/pages/hexcolorMaker_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/colors.dart';
import '../consts/images.dart';
import '../consts/lists.dart';
import '../consts/strings.dart';
import '../controllers/category_controller.dart';
import '../controllers/loading_dialogue_controller.dart';
import '../controllers/products_previous_details_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/circuler_small_color_button.dart';
import '../shapes/snack_bar.dart';

class product_edit_details_page extends StatefulWidget {
  product_edit_details_page(
      {Key? key, required this.product_details_doc, required this.poduct_id})
      : super(key: key);
  var product_details_doc, poduct_id;

  @override
  State<product_edit_details_page> createState() =>
      _product_edit_details_pageState();
}

class _product_edit_details_pageState extends State<product_edit_details_page> {
  final category_controller categoryController = Get.find();

  final brands_controller brandController = Get.find();

  final loading_dialogue_controller loadingController = Get.find();

  var products_docreference = FirebaseFirestore.instance.collection("products");

  var products_img_docreference = FirebaseStorage.instance;

  RxList compressed_size_sheet_img = [].obs, product_img_uint_list = [].obs;

  final _formKey = GlobalKey<FormState>();

  RxList<String> size_name = ["XS", "S", "M", "L", "XL", "XXL", "3XL"].obs;

  RxList color_selected_list = [white_color_hex].obs,
      color_selected_listXS = [white_color_hex].obs,
      color_selected_listS = [white_color_hex].obs,
      color_selected_listM = [white_color_hex].obs,
      color_selected_listL = [white_color_hex].obs,
      color_selected_listXL = [white_color_hex].obs,
      color_selected_listXXL = [white_color_hex].obs,
      color_selected_list3XL = [white_color_hex].obs;

  RxList<bool> product_size_selected =
      [false, false, false, false, false, false, false].obs;

  RxList product_img_list = [].obs,
      product_prev_img_list = [].obs,
      cat_list = [].obs;

  String product_img_urls = "",
      size_chart_img_urls = "",
      prev_size_sheet_image = "",
      product_first_img_urls = "";

  RxInt variation_value = 0.obs,
      off_percent = 0.obs,
      initial_price = 0.obs,
      color_count = 1.obs;

  RxList liquid_quantity_list = ["0"].obs,
      liquid_weight_list = ["0"].obs,
      liquid_ml_price_list = ["0"].obs,
      liquid_ml_list = ["0"].obs,
      color_quantity_list = ["0"].obs,
      size_color_quantity_listXS = ["0"].obs,
      size_color_quantity_listS = ["0"].obs,
      size_color_quantity_listM = ["0"].obs,
      size_color_quantity_listL = ["0"].obs,
      size_color_quantity_listXL = ["0"].obs,
      size_color_quantity_listXXL = ["0"].obs,
      size_color_quantity_list3XL = ["0"].obs;

  RxString title = "".obs,
      description = "".obs,
      search_tags = "".obs,
      quantity = "0".obs,
      buying_limit = "0".obs,
      weight_per_kg = "0".obs,
      sell_will_start_from = "0".obs,
      product_id = "".obs,
      final_price = "0".obs;

  RxBool is_size_color_selected = false.obs,
      is_color_selected = false.obs,
      is_liquid_selected = false.obs;

  RxString selectednumberofsizecolorXS = color_list[0].toString().obs,
      selectednumberofsizecolorS = color_list[0].toString().obs,
      selectednumberofsizecolorM = color_list[0].toString().obs,
      selectednumberofsizecolorL = color_list[0].toString().obs,
      selectednumberofsizecolorXL = color_list[0].toString().obs,
      selectednumberofsizecolorXXL = color_list[0].toString().obs,
      selectednumberofsizecolor3XL = color_list[0].toString().obs,
      selectednumberofcolor = color_list[0].toString().obs,
      selectednumberofliquid = color_list[0].toString().obs;

  var selectedcategory,selectedSeason;

  var my_category_list = [].obs;
  late BuildContext new_context;

  var initial_price_controller=TextEditingController();
  var off_controller=TextEditingController();
  var quantity_controller=TextEditingController();
  var product_id_controller=TextEditingController();
  var weight_per_piece_controller=TextEditingController();
  var title_controller=TextEditingController();
  var buying_limit_controller=TextEditingController();
  var description_controller=TextEditingController();
  var search_tags_controller=TextEditingController();

  @override
  void initState(){
    load_previous_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    new_context = context;
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Container(
          color: whiteColor,
          child: SafeArea(
              child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15),
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            height: 50,
                            margin: EdgeInsets.only(right: 10),
                            child: Material(
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                borderRadius: BorderRadius.circular(50),
                                child: Ink(
                                    height: 40,
                                    width: 40,
                                    color: whiteColor,
                                    child: Icon(CupertinoIcons.back)),
                              ),
                            )),
                        Text(
                          edit_product_txt,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ).box.margin(EdgeInsets.only(bottom: 3)).make(),
                      ],
                    ).box.padding(EdgeInsets.only(top: 5)).make(),
                    Material(
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          showAlertDialog(context);
                        },
                        child: Ink(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: lightGreyColor),
                            child: Icon(CupertinoIcons.delete)),
                      ),
                    ).box.margin(EdgeInsets.only(right: 15)).make(),
                  ],
                ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Obx(
                        ()=> Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: het * 0.4,
                                width: double.infinity,
                                child: Swiper(
                                  viewportFraction: 1,
                                  scale: 1,
                                  physics: ScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        ImagePicker imagePicker = ImagePicker();
                                        product_img_list.clear();
                                        product_img_uint_list.clear();
                                        List<XFile> img_list =
                                            await imagePicker.pickMultiImage();
                                        product_img_list.value =
                                            img_list.length > 10
                                                ? img_list.sublist(0, 10)
                                                : img_list;
                                        if (product_img_list != null) {
                                          for (XFile oneimg in product_img_list) {
                                            Uint8List? compressed_img =
                                                await FlutterImageCompress
                                                    .compressWithFile(oneimg!.path,
                                                        quality: 40)!;
                                            product_img_uint_list
                                                .add(compressed_img!);
                                          }
                                        }
                                      },
                                      child: product_img_uint_list.length == 0
                                          ? CachedNetworkImage(
                                              imageUrl:
                                              product_prev_img_list.length==0?"":product_prev_img_list[index],
                                              imageBuilder: (context, url) =>
                                                  all_product_network_swiper_image_shape(
                                                      url),
                                              placeholder: (context, url) =>
                                                  all_product_asset_swiper_image_shape(),
                                              errorWidget: (context, url, error) =>
                                                  all_product_asset_swiper_image_shape(),
                                            )
                                          : all_product_file_swiper_image_shape(
                                              product_img_uint_list[index]),
                                    );
                                  },
                                  itemCount: product_img_uint_list.length == 0
                                      ? (product_prev_img_list.length==0?1:product_prev_img_list.length)
                                      : product_img_uint_list.length,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                20.heightBox,
                                Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Material(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              imageUrl: widget.product_details_doc[
                                                  "brand_icon"],
                                              imageBuilder: (context, url) =>
                                                  brand_network_image_shape(url),
                                              placeholder: (context, url) =>
                                                  brand_asset_image_shape(),
                                              errorWidget: (context, url, error) =>
                                                  brand_asset_image_shape(),
                                            ),
                                          ),
                                          Visibility(
                                            visible: widget.product_details_doc[
                                                        'brand_verified'] ==
                                                    "verified"
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
                                                        color: whiteColor,
                                                        width: 1)),
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
                                          widget.product_details_doc["brand_name"],
                                          maxLines: 1,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
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
                                            "${final_price.value}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icon/taka_svg.svg',
                                            width: 14,
                                            color: FontGreyColor,
                                          ),
                                          Text(
                                            "${off_percent.value == 0 ? 0 : initial_price.value}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontWeight: FontWeight.w500,
                                                color: FontGreyColor),
                                          ),
                                          Obx(
                                            ()=> Text(
                                              "${off_percent.value}% off",
                                              style: TextStyle(color: orangeColor),
                                            )
                                                .box
                                                .color(lightGreyColor)
                                                .rounded
                                                .padding(EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    top: 3,
                                                    bottom: 3))
                                                .margin(EdgeInsets.only(left: 20))
                                                .make(),
                                          ),
                                        ],
                                      ).box.margin(EdgeInsets.only(left: 2)).make(),
                                    ],
                                  )
                                      .box
                                      .padding(EdgeInsets.only(top: 10, bottom: 10))
                                      .make(),
                                10.heightBox,
                                Row(
                                  children: [
                                    Visibility(
                                      visible: !is_liquid_selected.value,
                                      child: Flexible(
                                        flex: 1,
                                        child: TextFormField(
                                              controller: initial_price_controller,
                                            autovalidateMode:
                                                AutovalidateMode.onUserInteraction,
                                            decoration: InputDecoration(
                                              labelText: "Pnitial Price",
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
                                              initial_price.value = val.length == 0
                                                  ? 0
                                                  : int.parse(val);
                                              final_price_calculation();
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
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: TextFormField(
                                          controller: off_controller,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              decoration: InputDecoration(
                                                labelText: "Off",
                                                contentPadding: EdgeInsets.all(8),
                                                border: OutlineInputBorder(),
                                                prefixIcon:Icon(CupertinoIcons.percent),
                                              ),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              maxLength: 2,
                                              onChanged: (val) {
                                                off_percent.value =
                                                    val.length == 0
                                                        ? 0
                                                        : int.parse(val);
                                                final_price_calculation();
                                              })
                                          .box
                                          .margin(EdgeInsets.only(
                                              left: is_liquid_selected.value ==
                                                      false
                                                  ? 5
                                                  : 0))
                                          .make(),
                                    )
                                  ],
                                ),
                                10.heightBox,
                                TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      labelText: "Product ID",
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: null,
                                    maxLength: 20,
                                    controller: product_id_controller,
                                    onChanged: (val) {
                                      product_id.value = val.length == 0 ? "" : val;
                                    },
                                    validator: (value) {
                                      if (value.toString().length == 0) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                  ),
                                10.heightBox,
                                DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: "Category",
                                      contentPadding:
                                          EdgeInsets.only(left: 15, right: 5),
                                      border: OutlineInputBorder(),
                                    ),
                                    value: selectedcategory,
                                    items: my_category_list
                                        .map((e) => DropdownMenuItem(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 25,
                                                    height: 25,
                                                    decoration: new BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      image: new DecorationImage(
                                                        image: e['sub_category_icon']
                                                                    .toString()
                                                                    .length ==
                                                                0
                                                            ? AssetImage(add_icon)
                                                            : NetworkImage(e['sub_category_icon'])
                                                                as ImageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                      .box
                                                      .margin(EdgeInsets.only(
                                                          right: 10))
                                                      .make(),
                                                  Text(e['sub_category_name'])
                                                ],
                                              ),
                                              value: e,
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      selectedcategory = val;
                                    }),
                                30.heightBox,
                                DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      contentPadding: EdgeInsets.all(8),
                                      labelText:"Season",
                                    ),
                                    value: selectedSeason,
                                    items: seasons_list
                                        .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                        .toList(),
                                    onChanged: (val) {
                                      selectedSeason = val.toString();
                                    }),
                                15.heightBox,
                                SizedBox(
                                  height: 20,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Text(
                                        "Size & Color ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          is_size_color_selected.value =
                                              !is_size_color_selected.value;
                                          is_color_selected.value = false;
                                          is_liquid_selected.value = false;
                                          clear_variation_value();
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              color: is_size_color_selected.value
                                                  ? darkBlueColor
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: is_size_color_selected.value
                                                  ? null
                                                  : Border.all(
                                                      color: textFieldGreyColor,
                                                      width: 2)),
                                          child: is_size_color_selected.value
                                              ? Icon(
                                                  Icons.check,
                                                  color: whiteColor,
                                                  size: 13,
                                                )
                                              : null,
                                        ),
                                      )
                                          .box
                                          .margin(
                                              EdgeInsets.only(left: 3, right: 10))
                                          .make(),
                                      Text(
                                        "Color ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          is_color_selected.value =
                                              !is_color_selected.value;
                                          is_liquid_selected.value = false;
                                          is_size_color_selected.value = false;
                                          clear_variation_value();
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              color: is_color_selected.value
                                                  ? darkBlueColor
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: is_color_selected.value
                                                  ? null
                                                  : Border.all(
                                                      color: textFieldGreyColor,
                                                      width: 2)),
                                          child: is_color_selected.value
                                              ? Icon(
                                                  Icons.check,
                                                  color: whiteColor,
                                                  size: 13,
                                                )
                                              : null,
                                        ),
                                      )
                                          .box
                                          .margin(
                                              EdgeInsets.only(left: 3, right: 10))
                                          .make(),
                                      Text(
                                        "Size/Liquid ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          is_liquid_selected.value =
                                              !is_liquid_selected.value;
                                          is_color_selected.value = false;
                                          is_size_color_selected.value = false;
                                          clear_variation_value();
                                          final_price.value = "0";
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              color: is_liquid_selected.value
                                                  ? darkBlueColor
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: is_liquid_selected.value
                                                  ? null
                                                  : Border.all(
                                                      color: textFieldGreyColor,
                                                      width: 2)),
                                          child: is_liquid_selected.value
                                              ? Icon(
                                                  Icons.check,
                                                  color: whiteColor,
                                                  size: 13,
                                                )
                                              : null,
                                        ),
                                      )
                                          .box
                                          .margin(
                                              EdgeInsets.only(left: 3, right: 10))
                                          .make(),
                                    ],
                                  ),
                                ),
                                15.heightBox,
                                show_size_and_color(),
                                show_color(),
                                show_liquid_ml(),
                                Visibility(
                                  visible: is_size_color_selected.value ||
                                          is_liquid_selected.value ||
                                          is_color_selected.value
                                      ? true
                                      : false,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Size/Color/Ammount Chart",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Material(
                                        borderRadius: BorderRadius.circular(6),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(6),
                                          onTap: () async {
                                            ImagePicker imagePicker =
                                                ImagePicker();
                                            XFile? img =
                                                await imagePicker.pickImage(
                                                    source: ImageSource.gallery);
                                            compressed_size_sheet_img.clear();
                                            if (img != null)
                                              compressed_size_sheet_img.add(
                                                  (await FlutterImageCompress
                                                      .compressWithFile(img!.path,
                                                          quality: 25))!);
                                          },
                                          child: Ink(
                                            height:
                                                het > wdt ? het * 0.2 : wdt * 0.2,
                                            width: double.infinity,
                                            decoration: new BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  width: 1,
                                                  color: lightGreyColor),
                                              image: new DecorationImage(
                                                image: show_size_chart_image(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      10.heightBox
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: is_size_color_selected.value ||
                                            is_liquid_selected.value ||
                                            is_color_selected.value
                                        ? false
                                        : true,
                                    child: TextFormField(
                                      controller: quantity_controller,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        labelText: "Quantity",
                                        contentPadding: EdgeInsets.all(8),
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      maxLength: 9,
                                      onChanged: (val) {
                                        quantity.value =
                                            val.length == 0 ? "0" : val;
                                      },
                                      validator: (value) {
                                        if (value.toString().length == 0) {
                                          return "Field can't be empty";
                                        } else if (int.parse(value.toString()) ==
                                            0) {
                                          return "Field value can't be 0";
                                        }
                                        return null;
                                      },
                                    )),
                                10.heightBox,
                                Visibility(
                                  visible: !is_liquid_selected.value,
                                  child: TextFormField(
                                    controller: weight_per_piece_controller,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      labelText: "Weight per Piece (kg)",
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d*')),
                                    ],
                                    maxLength: 5,
                                    onChanged: (val) {
                                      weight_per_kg.value =
                                          val.length == 0 ? "0" : val;
                                    },
                                    validator: (value) {
                                      if (value.toString().length == 0) {
                                        return "Field can't be empty";
                                      } else if (double.parse(value.toString()) ==
                                          0) {
                                        return "Field value can't be 0";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                10.heightBox,
                                SizedBox(
                                  child: TextFormField(
                                    controller:title_controller,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      labelText: "Title",
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: null,
                                    maxLength: 150,
                                    onChanged: (val) {
                                      title.value =
                                          val.length == 0 ? "" : val.toString();
                                    },
                                    validator: (value) {
                                      if (value.toString().length == 0) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                10.heightBox,
                                SizedBox(
                                  child: TextFormField(
                                    controller:description_controller,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      labelText: "Description",
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: null,
                                    maxLength: 1000,
                                    onChanged: (val) {
                                      description.value =
                                          val.length == 0 ? "" : val.toString();
                                    },
                                    validator: (value) {
                                      if (value.toString().length == 0) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                10.heightBox,
                                SizedBox(
                                  child: TextFormField(
                                    controller:search_tags_controller,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      labelText: "#Search Tags",
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLength: 50,
                                    maxLines: null,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9a-zA-Z#]')),
                                    ],
                                    onChanged: (val) {
                                      search_tags.value =
                                          val.length == 0 ? "" : val.toString();
                                    },
                                    validator: (value) {
                                      if (value.toString().length == 0) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                10.heightBox,
                                TextFormField(
                                  controller:buying_limit_controller,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "Buying limit (pieces)",
                                    contentPadding: EdgeInsets.all(8),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  maxLength: 2,
                                  onChanged: (val) {
                                    buying_limit.value =
                                        val.length == 0 ? "0" : val;
                                  },
                                ),
                                10.heightBox,
                                Center(
                                  child: Material(
                                    borderRadius: BorderRadius.circular(6),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(6),
                                      onTap: () {
                                        if (validate_everything(context)) {
                                          add_in_database(context);
                                        }
                                      },
                                      child: Ink(
                                        height: 40,
                                        width: 200,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: darkBlueColor),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                ),
                                30.heightBox
                              ],
                            ).marginOnly(left: 15, right: 15)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }

  final_price_calculation() {
    if (is_liquid_selected.value) {
      if(is_liquid_selected.value && off_percent.value == 0){
        final_price.value=liquid_ml_price_list[0].toString();
        initial_price.value=0;
      }else{
        final_price.value=(int.parse(liquid_ml_price_list[0]) - ((off_percent.value
            * int.parse(liquid_ml_price_list[0])) / 100)).toStringAsFixed(0);
        initial_price.value=int.parse(liquid_ml_price_list[0]);
      }
    } else {
      final_price.value = off_percent.value == 0
          ? initial_price.value.toStringAsFixed(0)
          : (initial_price.value -
                  ((off_percent.value * initial_price.value) / 100))
              .toStringAsFixed(0);
    }
  }

  load_previous_data() {
    Future.delayed(Duration(milliseconds: 400), () async {
      product_prev_img_list.value = widget.product_details_doc["product_img"]
          .toString()
          .trim()
          .split("  ");
      product_first_img_urls = product_prev_img_list[0];
      prev_size_sheet_image = widget.product_details_doc["size_chart_img"];
      initial_category_list(widget.product_details_doc["brand_name"]);
      initial_price.value = int.parse(
          widget.product_details_doc["initial_price"].toString().trim());
      initial_price_controller.text=widget.product_details_doc["initial_price"];
      final_price.value = widget.product_details_doc["final_price"];
      off_percent.value = int.parse(
          widget.product_details_doc["off_percent"].toString().trim());
      off_controller.text= widget.product_details_doc["off_percent"];
      product_id.value = widget.product_details_doc["product_given_id"];
      product_id_controller.text= widget.product_details_doc["product_given_id"];
      quantity.value = widget.product_details_doc["quantity"];
      quantity_controller.text= widget.product_details_doc["quantity"];
      weight_per_kg.value = widget.product_details_doc["weight_per_kg"];
      weight_per_piece_controller.text = widget.product_details_doc["weight_per_kg"];
      title.value = widget.product_details_doc["product_title"];
      title_controller.text = widget.product_details_doc["product_title"];
      description.value = widget.product_details_doc["product_description"];
      description_controller.text = widget.product_details_doc["product_description"];
      sell_will_start_from.value = widget.product_details_doc["sell_will_start_from"];
      buying_limit.value = widget.product_details_doc["product_buying_limit"];
      buying_limit_controller.text = widget.product_details_doc["product_buying_limit"];
      selectedSeason=widget.product_details_doc["product_season"];
      for (var val in widget.product_details_doc["search_tags"]) {
        search_tags.value = search_tags.value + "#" + val.toString();
      }
      search_tags_controller.text=search_tags.value;
      is_size_color_selected.value =
      widget.product_details_doc["is_size_color_selected"] == "true"
          ? true
          : false;
      is_color_selected.value =
      widget.product_details_doc["is_color_selected"] == "true"
          ? true
          : false;
      is_liquid_selected.value =
      widget.product_details_doc["is_liquid_selected"] == "true"
          ? true
          : false;

      if (is_size_color_selected.value) {
        color_selected_listXS.clear();
        color_selected_listS.clear();
        color_selected_listM.clear();
        color_selected_listL.clear();
        color_selected_listXL.clear();
        color_selected_listXXL.clear();
        color_selected_list3XL.clear();
        size_color_quantity_listXS.clear();
        size_color_quantity_listS.clear();
        size_color_quantity_listM.clear();
        size_color_quantity_listL.clear();
        size_color_quantity_listXL.clear();
        size_color_quantity_listXXL.clear();
        size_color_quantity_list3XL.clear();
        for (var val in widget.product_details_doc["color_selected_listXS"])
          color_selected_listXS.add(val);
        for (var val in widget.product_details_doc["color_selected_listS"])
          color_selected_listS.add(val);
        for (var val in widget.product_details_doc["color_selected_listM"])
          color_selected_listM.add(val);
        for (var val in widget.product_details_doc["color_selected_listL"])
          color_selected_listL.add(val);
        for (var val in widget.product_details_doc["color_selected_listXL"])
          color_selected_listXL.add(val);
        for (var val in widget.product_details_doc["color_selected_listXXL"])
          color_selected_listXXL.add(val);
        for (var val in widget.product_details_doc["color_selected_list3XL"])
          color_selected_list3XL.add(val);

        for (var val in widget.product_details_doc["size_color_quantity_listXS"])
          size_color_quantity_listXS.add(val);
        for (var val in widget.product_details_doc["size_color_quantity_listS"])
          size_color_quantity_listS.add(val);
        for (var val in widget.product_details_doc["size_color_quantity_listM"])
          size_color_quantity_listM.add(val);
        for (var val in widget.product_details_doc["size_color_quantity_listL"])
          size_color_quantity_listL.add(val);
        for (var val in widget.product_details_doc["size_color_quantity_listXL"])
          size_color_quantity_listXL.add(val);
        for (var val in widget.product_details_doc["size_color_quantity_listXXL"])
          size_color_quantity_listXXL.add(val);
        for (var val in widget.product_details_doc["size_color_quantity_list3XL"])
          size_color_quantity_list3XL.add(val);

        if (color_selected_listXS.length > 1 ||
            color_selected_listXS[0] != white_color_hex ||
            size_color_quantity_listXS[0] != "0") {
          product_size_selected.value[0] = true;
          selectednumberofsizecolorXS.value =
              color_selected_listXS.length.toString();
        }
        if (color_selected_listS.length > 1 ||
            color_selected_listS[0] != white_color_hex ||
            size_color_quantity_listS[0] != "0") {
          product_size_selected.value[1] = true;
          selectednumberofsizecolorS.value =
              color_selected_listS.length.toString();
        }
        if (color_selected_listM.length > 1 ||
            color_selected_listM[0] != white_color_hex ||
            size_color_quantity_listM[0] != "0") {
          product_size_selected.value[2] = true;
          selectednumberofsizecolorM.value =
              color_selected_listM.length.toString();
        }
        if (color_selected_listL.length > 1 ||
            color_selected_listL[0] != white_color_hex ||
            size_color_quantity_listL[0] != "0") {
          product_size_selected.value[3] = true;
          selectednumberofsizecolorL.value =
              color_selected_listL.length.toString();
        }
        if (color_selected_listXL.length > 1 ||
            color_selected_listXL[0] != white_color_hex ||
            size_color_quantity_listXL[0] != "0") {
          product_size_selected.value[4] = true;
          selectednumberofsizecolorXL.value =
              color_selected_listXL.length.toString();
        }
        if (color_selected_listXXL.length > 1 ||
            color_selected_listXXL[0] != white_color_hex ||
            size_color_quantity_listXXL[0] != "0") {
          product_size_selected.value[5] = true;
          selectednumberofsizecolorXXL.value =
              color_selected_listXXL.length.toString();
        }
        if (color_selected_list3XL.length > 1 ||
            color_selected_list3XL[0] != white_color_hex ||
            size_color_quantity_list3XL[0] != "0") {
          product_size_selected.value[6] = true;
          selectednumberofsizecolor3XL.value =
              color_selected_list3XL.length.toString();
        }
      } else if (is_color_selected.value) {
        color_selected_list.clear();
        color_quantity_list.clear();
        for (var val in widget.product_details_doc["color_selected_list"]) {
          color_selected_list.add(val);
        }
        for (var val in widget.product_details_doc["color_quantity_list"]) {
          color_quantity_list.add(val);
        }
        selectednumberofcolor.value = color_selected_list.length.toString();
      } else if (is_liquid_selected.value) {
        liquid_ml_list.clear();
        liquid_weight_list.clear();
        liquid_ml_price_list.clear();
        liquid_quantity_list.clear();

        for (var val in widget.product_details_doc["liquid_ml_list"]) {
          liquid_ml_list.add(val);
        }
        for (var val in widget.product_details_doc["liquid_weight_list"]) {
          liquid_weight_list.add(val);
        }
        for (var val in widget.product_details_doc["liquid_ml_price_list"]) {
          liquid_ml_price_list.add(val);
        }
        for (var val in widget.product_details_doc["liquid_quantity_list"]) {
          liquid_quantity_list.add(val);
        }
        selectednumberofliquid.value = liquid_quantity_list.length.toString();
      }
    });
  }

  show_size_chart_image() {
    if (prev_size_sheet_image.length > 1 &&
        compressed_size_sheet_img.length == 0) {
      return NetworkImage(prev_size_sheet_image);
    } else if (prev_size_sheet_image.length < 2 &&
        compressed_size_sheet_img.length == 0) {
      return AssetImage(product_image_icon);
    } else {
      return MemoryImage(compressed_size_sheet_img[0]);
    }
  }

  initial_category_list(String selected_brand) {
    my_category_list.clear();
    for (int i = 0; i < brandController.mybrandlist.length; i++) {
      if (brandController.mybrandlist[i]["brand_name"] == selected_brand) {
        cat_list.value = brandController.mybrandlist[i]['brand_categories'];
      }
    }
    for (var val in categoryController.allsubCategorylist) {
      if (cat_list.contains(val['sub_category_name'])) {
        my_category_list.add(val);
      }
    }
    for (var val in my_category_list) {
      if (val['sub_category_name'] == widget.product_details_doc["category_name"]) {
        selectedcategory = val;
        break;
      }
    }
  }

  category_list(String selected_brand) {
    my_category_list.clear();
    for (int i = 0; i < brandController.mybrandlist.length; i++) {
      if (brandController.mybrandlist[i]["brand_name"] == selected_brand) {
        cat_list.value = brandController.mybrandlist[i]['brand_categories'];
      }
    }
    for (var val in categoryController.allsubCategorylist) {
      if (cat_list.contains(val['sub_category_name'])) {
        my_category_list.add(val);
      }
    }
    selectedcategory = my_category_list[0];
  }

  Widget radio_selector(index) => Row(
        children: [
          Text(
            "${size_name[index]} ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              product_size_selected[index] = !product_size_selected[index];
              if (index == 0) {
                color_selected_listXS.clear();
                color_selected_listXS.add(white_color_hex);
                selectednumberofsizecolorXS.value = color_list[0].toString();
                size_color_quantity_listXS.clear();
                size_color_quantity_listXS.add("0");
              } else if (index == 1) {
                color_selected_listS.clear();
                color_selected_listS.add(white_color_hex);
                selectednumberofsizecolorS.value = color_list[0].toString();
                size_color_quantity_listS.clear();
                size_color_quantity_listS.add("0");
              } else if (index == 2) {
                color_selected_listM.clear();
                color_selected_listM.add(white_color_hex);
                selectednumberofsizecolorM.value = color_list[0].toString();
                size_color_quantity_listM.clear();
                size_color_quantity_listM.add("0");
              } else if (index == 3) {
                color_selected_listL.clear();
                color_selected_listL.add(white_color_hex);
                selectednumberofsizecolorL.value = color_list[0].toString();
                size_color_quantity_listL.clear();
                size_color_quantity_listL.add("0");
              } else if (index == 4) {
                color_selected_listXL.clear();
                color_selected_listXL.add(white_color_hex);
                selectednumberofsizecolorXL.value = color_list[0].toString();
                size_color_quantity_listXL.clear();
                size_color_quantity_listXL.add("0");
              } else if (index == 5) {
                color_selected_listXXL.clear();
                color_selected_listXXL.add(white_color_hex);
                selectednumberofsizecolorXXL.value = color_list[0].toString();
                size_color_quantity_listXXL.clear();
                size_color_quantity_listXXL.add("0");
              } else if (index == 6) {
                color_selected_list3XL.clear();
                color_selected_list3XL.add(white_color_hex);
                selectednumberofsizecolor3XL.value = color_list[0].toString();
                size_color_quantity_list3XL.clear();
                size_color_quantity_list3XL.add("0");
              }
            },
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  color: product_size_selected[index]
                      ? darkBlueColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: product_size_selected[index]
                      ? null
                      : Border.all(color: textFieldGreyColor, width: 2)),
              child: product_size_selected[index]
                  ? Icon(
                      Icons.check,
                      color: whiteColor,
                      size: 13,
                    )
                  : null,
            ),
          ).box.margin(EdgeInsets.only(left: 10)).make(),
        ],
      );

  Widget show_size_and_color() {
    return Visibility(
      visible: is_size_color_selected.value,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          radio_selector(0),
          Visibility(
              visible: product_size_selected[0],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "Number of colors",
                            contentPadding: EdgeInsets.only(left: 15),
                            border: OutlineInputBorder(),
                          ),
                          value: selectednumberofsizecolorXS.value,
                          items: color_list
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) {
                            selectednumberofsizecolorXS.value = val.toString();
                            color_selected_listXS.clear();
                            size_color_quantity_listXS.clear();
                            for (int j = 0;
                                j <
                                    int.parse(
                                        selectednumberofsizecolorXS.value);
                                j++) {
                              color_selected_listXS.add(white_color_hex);
                              size_color_quantity_listXS.add("0");
                            }
                          })
                      .box
                      .width(120)
                      .margin(EdgeInsets.only(top: 10, bottom: 10))
                      .make(),
                  for (int i = 1;
                      i <= int.parse(selectednumberofsizecolorXS.value);
                      i++)
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: color_selected_listXS[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Color Hex code",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                              prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: circuler_small_color_button(25.0, 25.0,
                                      hexColor(color_selected_listXS[i - 1]))),
                            ),
                            maxLength: 7,
                            onChanged: (val) {
                              color_selected_listXS[i - 1] =
                                  val.length == 7 && val[0] == '#'
                                      ? val
                                      : white_color_hex;
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(right: 5))
                              .make(),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                                  initialValue: size_color_quantity_listXS[i - 1],
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "Quantity",
                                    contentPadding: EdgeInsets.all(8),
                                    border: OutlineInputBorder(),
                                    counter: Offstage(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  maxLength: 6,
                                  onChanged: (val) {
                                    size_color_quantity_listXS[i - 1] =
                                        val.length > 0 ? val.toString() : "0";
                                  })
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(left: 5))
                              .make(),
                        )
                      ],
                    ).box.margin(EdgeInsets.only(bottom: 10)).make()
                ],
              )),
          10.heightBox,
          radio_selector(1),
          Visibility(
              visible: product_size_selected[1],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "Number of colors",
                            contentPadding: EdgeInsets.only(left: 15),
                            border: OutlineInputBorder(),
                          ),
                          value: selectednumberofsizecolorS.value,
                          items: color_list
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) {
                            selectednumberofsizecolorS.value = val.toString();
                            size_color_quantity_listS.clear();
                            color_selected_listS.clear();
                            for (int j = 0;
                                j < int.parse(selectednumberofsizecolorS.value);
                                j++) {
                              color_selected_listS.add(white_color_hex);
                              size_color_quantity_listS.add("0");
                            }
                          })
                      .box
                      .width(120)
                      .margin(EdgeInsets.only(top: 10, bottom: 10))
                      .make(),
                  for (int i = 1;
                      i <= int.parse(selectednumberofsizecolorS.value);
                      i++)
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: color_selected_listS[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Color Hex code",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                              prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: circuler_small_color_button(25.0, 25.0,
                                      hexColor(color_selected_listS[i - 1]))),
                            ),
                            maxLength: 7,
                            onChanged: (val) {
                              color_selected_listS[i - 1] =
                                  val.length == 7 && val[0] == '#'
                                      ? val
                                      : white_color_hex;
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(right: 5))
                              .make(),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: size_color_quantity_listS[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Quantity",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 6,
                            onChanged: (val) {
                              size_color_quantity_listS[i - 1] =
                                  val.length > 0 ? val.toString() : "0";
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(left: 5))
                              .make(),
                        )
                      ],
                    ).box.margin(EdgeInsets.only(bottom: 10)).make()
                ],
              )),
          10.heightBox,
          radio_selector(2),
          Visibility(
              visible: product_size_selected[2],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "Number of colors",
                            contentPadding: EdgeInsets.only(left: 15),
                            border: OutlineInputBorder(),
                          ),
                          value: selectednumberofsizecolorM.value,
                          items: color_list
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) {
                            selectednumberofsizecolorM.value = val.toString();
                            color_selected_listM.clear();
                            size_color_quantity_listM.clear();
                            for (int j = 0;
                                j < int.parse(selectednumberofsizecolorM.value);
                                j++) {
                              color_selected_listM.add(white_color_hex);
                              size_color_quantity_listM.add("0");
                            }
                          })
                      .box
                      .width(120)
                      .margin(EdgeInsets.only(top: 10, bottom: 10))
                      .make(),
                  for (int i = 1;
                      i <= int.parse(selectednumberofsizecolorM.value);
                      i++)
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: color_selected_listM[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Color Hex code",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                              prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: circuler_small_color_button(25.0, 25.0,
                                      hexColor(color_selected_listM[i - 1]))),
                            ),
                            maxLength: 7,
                            onChanged: (val) {
                              color_selected_listM[i - 1] =
                                  val.length == 7 && val[0] == '#'
                                      ? val
                                      : white_color_hex;
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(right: 5))
                              .make(),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: size_color_quantity_listM[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Quantity",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 6,
                            onChanged: (val) {
                              size_color_quantity_listM[i - 1] =
                                  val.length > 0 ? val.toString() : "0";
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(left: 5))
                              .make(),
                        )
                      ],
                    ).box.margin(EdgeInsets.only(bottom: 10)).make()
                ],
              )),
          10.heightBox,
          radio_selector(3),
          Visibility(
              visible: product_size_selected[3],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "Number of colors",
                            contentPadding: EdgeInsets.only(left: 15),
                            border: OutlineInputBorder(),
                          ),
                          value: selectednumberofsizecolorL.value,
                          items: color_list
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) {
                            selectednumberofsizecolorL.value = val.toString();
                            color_selected_listL.clear();
                            size_color_quantity_listL.clear();
                            for (int j = 0;
                                j < int.parse(selectednumberofsizecolorL.value);
                                j++) {
                              color_selected_listL.add(white_color_hex);
                              size_color_quantity_listL.add("0");
                            }
                          })
                      .box
                      .width(120)
                      .margin(EdgeInsets.only(top: 10, bottom: 10))
                      .make(),
                  for (int i = 1;
                      i <= int.parse(selectednumberofsizecolorL.value);
                      i++)
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: color_selected_listL[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Color Hex code",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                              prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: circuler_small_color_button(25.0, 25.0,
                                      hexColor(color_selected_listL[i - 1]))),
                            ),
                            maxLength: 7,
                            onChanged: (val) {
                              color_selected_listL[i - 1] =
                                  val.length == 7 && val[0] == '#'
                                      ? val
                                      : white_color_hex;
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(right: 5))
                              .make(),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: size_color_quantity_listL[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Quantity",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 6,
                            onChanged: (val) {
                              size_color_quantity_listL[i - 1] =
                                  val.length > 0 ? val.toString() : "0";
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(left: 5))
                              .make(),
                        )
                      ],
                    ).box.margin(EdgeInsets.only(bottom: 10)).make()
                ],
              )),
          10.heightBox,
          radio_selector(4),
          Visibility(
              visible: product_size_selected[4],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "Number of colors",
                            contentPadding: EdgeInsets.only(left: 15),
                            border: OutlineInputBorder(),
                          ),
                          value: selectednumberofsizecolorXL.value,
                          items: color_list
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) {
                            selectednumberofsizecolorXL.value = val.toString();
                            color_selected_listXL.clear();
                            size_color_quantity_listXL.clear();
                            for (int j = 0;
                                j <
                                    int.parse(
                                        selectednumberofsizecolorXL.value);
                                j++) {
                              color_selected_listXL.add(white_color_hex);
                              size_color_quantity_listXL.add("0");
                            }
                          })
                      .box
                      .width(120)
                      .margin(EdgeInsets.only(top: 10, bottom: 10))
                      .make(),
                  for (int i = 1;
                      i <= int.parse(selectednumberofsizecolorXL.value);
                      i++)
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: color_selected_listXL[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Color Hex code",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                              prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: circuler_small_color_button(25.0, 25.0,
                                      hexColor(color_selected_listXL[i - 1]))),
                            ),
                            maxLength: 7,
                            onChanged: (val) {
                              color_selected_listXL[i - 1] =
                                  val.length == 7 && val[0] == '#'
                                      ? val
                                      : white_color_hex;
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(right: 5))
                              .make(),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: size_color_quantity_listXL[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Quantity",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 6,
                            onChanged: (val) {
                              size_color_quantity_listXL[i - 1] =
                                  val.length > 0 ? val.toString() : "0";
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(left: 5))
                              .make(),
                        )
                      ],
                    ).box.margin(EdgeInsets.only(bottom: 10)).make()
                ],
              )),
          10.heightBox,
          radio_selector(5),
          Visibility(
              visible: product_size_selected[5],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "Number of colors",
                            contentPadding: EdgeInsets.only(left: 15),
                            border: OutlineInputBorder(),
                          ),
                          value: selectednumberofsizecolorXXL.value,
                          items: color_list
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) {
                            selectednumberofsizecolorXXL.value = val.toString();
                            color_selected_listXXL.clear();
                            size_color_quantity_listXXL.clear();
                            for (int j = 0;
                                j <
                                    int.parse(
                                        selectednumberofsizecolorXXL.value);
                                j++) {
                              color_selected_listXXL.add(white_color_hex);
                              size_color_quantity_listXXL.add("0");
                            }
                          })
                      .box
                      .width(120)
                      .margin(EdgeInsets.only(top: 10, bottom: 10))
                      .make(),
                  for (int i = 1;
                      i <= int.parse(selectednumberofsizecolorXXL.value);
                      i++)
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: color_selected_listXXL[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                labelText: "Color Hex code",
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(),
                                counter: Offstage(),
                                prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: circuler_small_color_button(
                                        25.0,
                                        25.0,
                                        hexColor(
                                            color_selected_listXXL[i - 1])))),
                            maxLength: 7,
                            onChanged: (val) {
                              color_selected_listXXL[i - 1] =
                                  val.length == 7 && val[0] == '#'
                                      ? val
                                      : white_color_hex;
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(right: 5))
                              .make(),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: size_color_quantity_listXXL[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Quantity",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 6,
                            onChanged: (val) {
                              size_color_quantity_listXXL[i - 1] =
                                  val.length > 0 ? val.toString() : "0";
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(left: 5))
                              .make(),
                        )
                      ],
                    ).box.margin(EdgeInsets.only(bottom: 10)).make()
                ],
              )),
          10.heightBox,
          radio_selector(6),
          Visibility(
              visible: product_size_selected[6],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "Number of colors",
                            contentPadding: EdgeInsets.only(left: 15),
                            border: OutlineInputBorder(),
                          ),
                          value: selectednumberofsizecolor3XL.value,
                          items: color_list
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) {
                            selectednumberofsizecolor3XL.value = val.toString();
                            size_color_quantity_list3XL.clear();
                            color_selected_list3XL.clear();
                            for (int j = 0;
                                j <
                                    int.parse(
                                        selectednumberofsizecolor3XL.value);
                                j++) {
                              color_selected_list3XL.add(white_color_hex);
                              size_color_quantity_list3XL.add("0");
                            }
                          })
                      .box
                      .width(120)
                      .margin(EdgeInsets.only(top: 10, bottom: 10))
                      .make(),
                  for (int i = 1;
                      i <= int.parse(selectednumberofsizecolor3XL.value);
                      i++)
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: color_selected_list3XL[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Color Hex code",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                              prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: circuler_small_color_button(25.0, 25.0,
                                      hexColor(color_selected_list3XL[i - 1]))),
                            ),
                            maxLength: 7,
                            onChanged: (val) {
                              color_selected_list3XL[i - 1] =
                                  val.length == 7 && val[0] == '#'
                                      ? val
                                      : white_color_hex;
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(right: 5))
                              .make(),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            initialValue: size_color_quantity_list3XL[i - 1],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Quantity",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 6,
                            onChanged: (val) {
                              size_color_quantity_list3XL[i - 1] =
                                  val.length > 0 ? val.toString() : "0";
                            },
                          )
                              .box
                              .height(48)
                              .margin(EdgeInsets.only(left: 5))
                              .make(),
                        )
                      ],
                    ).box.margin(EdgeInsets.only(bottom: 10)).make()
                ],
              )),
          10.heightBox,
        ],
      ).box.margin(EdgeInsets.only(left: 10, right: 10)).make(),
    );
  }

  Widget show_color() {
    return Visibility(
      visible: is_color_selected.value,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "Number of colors",
                        contentPadding: EdgeInsets.only(left: 15),
                        border: OutlineInputBorder(),
                      ),
                      value: selectednumberofcolor.value,
                      items: color_list
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (val) {
                        selectednumberofcolor.value = val.toString();
                        color_selected_list.clear();
                        color_quantity_list.clear();
                        for (int j = 0;
                            j < int.parse(selectednumberofcolor.value);
                            j++) {
                          color_selected_list.add(white_color_hex);
                          color_quantity_list.add("0");
                        }
                      })
                  .box
                  .width(120)
                  .margin(EdgeInsets.only(top: 10, bottom: 10))
                  .make(),
              for (int i = 1; i <= int.parse(selectednumberofcolor.value); i++)
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        initialValue: color_selected_list[i - 1],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Color Hex code",
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          counter: Offstage(),
                          prefixIcon: Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: circuler_small_color_button(25.0, 25.0,
                                  hexColor(color_selected_list[i - 1]))),
                        ),
                        maxLength: 7,
                        onChanged: (val) {
                          color_selected_list[i - 1] =
                              val.length == 7 && val[0] == '#'
                                  ? val
                                  : white_color_hex;
                        },
                      ).box.height(48).margin(EdgeInsets.only(right: 5)).make(),
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        initialValue: color_quantity_list[i - 1],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Quantity",
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          counter: Offstage(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 6,
                        onChanged: (val) {
                          color_quantity_list[i - 1] =
                              val.length > 0 ? val.toString() : "0";
                        },
                      ).box.height(48).margin(EdgeInsets.only(left: 5)).make(),
                    )
                  ],
                ).box.margin(EdgeInsets.only(bottom: 10)).make()
            ],
          ),
          10.heightBox,
        ],
      ).box.margin(EdgeInsets.only(left: 10, right: 10)).make(),
    );
  }

  Widget show_liquid_ml() {
    return Visibility(
      visible: is_liquid_selected.value,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "variation",
                        contentPadding: EdgeInsets.only(left: 15),
                        border: OutlineInputBorder(),
                      ),
                      value: selectednumberofliquid.value,
                      items: color_list
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (val) {
                        selectednumberofliquid.value = val.toString();
                        liquid_ml_list.clear();
                        liquid_weight_list.clear();
                        liquid_ml_price_list.clear();
                        liquid_quantity_list.clear();
                        for (int j = 0;
                            j < int.parse(selectednumberofliquid.value);
                            j++) {
                          liquid_ml_list.add("0");
                          liquid_weight_list.add('0');
                          liquid_ml_price_list.add("0");
                          liquid_quantity_list.add("0");
                        }
                      })
                  .box
                  .width(120)
                  .margin(EdgeInsets.only(top: 10, bottom: 10))
                  .make(),
              for (int i = 1; i <= int.parse(selectednumberofliquid.value); i++)
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        initialValue: liquid_ml_list[i - 1],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            labelText: "Size/Ml...",
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                            counter: Offstage()),
                        maxLength: 10,
                        onChanged: (val) {
                          liquid_ml_list[i - 1] =
                              val.length > 0 ? val.toString() : "0";
                        },
                      ).box.height(48).margin(EdgeInsets.only(right: 5)).make(),
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        initialValue: liquid_weight_list[i - 1],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Weight per piece(g)",
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          counter: Offstage()
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d*')),
                        ],
                        maxLength: 5,
                        onChanged: (val) {
                          liquid_weight_list[i - 1] =
                          val.length > 0 ? val.toString() : "0";
                        },
                      ).box.height(48).margin(EdgeInsets.only(left:5,right: 5)).make(),
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        initialValue: liquid_ml_price_list[i - 1],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            labelText: "Price per piece",
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                            counter: Offstage()),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d*')),
                        ],
                        maxLength: 9,
                        onChanged: (val) {
                          liquid_ml_price_list[i - 1] =
                              val.length > 0 ? val.toString() : "0";
                          if (i - 1 == 0) {
                            final_price_calculation();
                          }
                        },
                      )
                          .box
                          .height(48)
                          .margin(EdgeInsets.only(left: 5, right: 5))
                          .make(),
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        initialValue: liquid_quantity_list[i - 1],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Quantity",
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          counter: Offstage(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 6,
                        onChanged: (val) {
                          liquid_quantity_list[i - 1] =
                              val.length > 0 ? val.toString() : "0";
                        },
                      ).box.height(48).margin(EdgeInsets.only(left: 5)).make(),
                    )
                  ],
                ).box.margin(EdgeInsets.only(bottom: 10)).make()
            ],
          ),
          10.heightBox,
        ],
      ).box.margin(EdgeInsets.only(left: 10, right: 10)).make(),
    );
  }

  clear_variation_value() {
    selectednumberofcolor.value = color_list[0].toString();
    selectednumberofliquid.value = color_list[0].toString();
    compressed_size_sheet_img.clear();
    quantity.value = "0";
    selectednumberofsizecolorXS.value = color_list[0].toString();
    selectednumberofsizecolorS.value = color_list[0].toString();
    selectednumberofsizecolorM.value = color_list[0].toString();
    selectednumberofsizecolorL.value = color_list[0].toString();
    selectednumberofsizecolorXL.value = color_list[0].toString();
    selectednumberofsizecolorXXL.value = color_list[0].toString();
    selectednumberofsizecolor3XL.value = color_list[0].toString();
    color_selected_list.clear();
    color_selected_listXS.clear();
    color_selected_listS.clear();
    color_selected_listM.clear();
    color_selected_listL.clear();
    color_selected_listXL.clear();
    color_selected_listXXL.clear();
    color_selected_list3XL.clear();
    color_selected_list.add(white_color_hex);
    color_selected_listXS.add(white_color_hex);
    color_selected_listS.add(white_color_hex);
    color_selected_listM.add(white_color_hex);
    color_selected_listL.add(white_color_hex);
    color_selected_listXL.add(white_color_hex);
    color_selected_listXXL.add(white_color_hex);
    color_selected_list3XL.add(white_color_hex);
    liquid_quantity_list.clear();
    liquid_weight_list.clear();
    liquid_ml_list.clear();
    liquid_ml_price_list.clear();
    color_quantity_list.clear();
    size_color_quantity_listXS.clear();
    size_color_quantity_listS.clear();
    size_color_quantity_listM.clear();
    size_color_quantity_listL.clear();
    size_color_quantity_listXL.clear();
    size_color_quantity_listXXL.clear();
    size_color_quantity_list3XL.clear();
    liquid_quantity_list.add("0");
    liquid_weight_list.add('0');
    liquid_ml_list.add("0");
    liquid_ml_price_list.add("0");
    color_quantity_list.add("0");
    size_color_quantity_listXS.add("0");
    size_color_quantity_listS.add("0");
    size_color_quantity_listM.add("0");
    size_color_quantity_listL.add("0");
    size_color_quantity_listXL.add("0");
    size_color_quantity_listXXL.add("0");
    size_color_quantity_list3XL.add("0");
    if (is_liquid_selected.value) {
      initial_price.value = 0;
      weight_per_kg.value = "0";
    }
    if (is_size_color_selected.value) {
      for (int i = 0; i < 7; i++) product_size_selected[i] = false;
    }
  }

  Future<void> add_in_database(context) async {
    product_img_urls = "";
    product_first_img_urls = "";
    loadingController.show_dialogue(new_context);
    List tags = search_tags.value.split("#");

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("products").doc(widget.poduct_id);
    Reference size_chart_reference = FirebaseStorage.instance
        .ref()
        .child("products_picture")
        .child(widget.product_details_doc["brand_name"])
        .child(new DateTime.now().microsecondsSinceEpoch.toString());

    if (product_img_uint_list.length != 0) {
      for (int i = 0; i < product_img_uint_list.length; i++) {
        Reference reference = FirebaseStorage.instance
            .ref()
            .child("products_picture")
            .child(widget.product_details_doc["brand_name"])
            .child(new DateTime.now().microsecondsSinceEpoch.toString());
        await reference
            .putData(product_img_uint_list[i])
            .whenComplete(() async {
          await reference.getDownloadURL().then((value) => {
                product_img_urls = "${product_img_urls + "  " + value}",
                if (i == 0) product_first_img_urls = value
              });
        });
      }
      for (var val in product_prev_img_list) {
        products_img_docreference.refFromURL(val).delete();
      }
    } else {
      product_img_urls = widget.product_details_doc["product_img"].toString();
      product_first_img_urls = product_prev_img_list[0];
    }
    if (!compressed_size_sheet_img.isEmpty) {
      await size_chart_reference
          .putData(compressed_size_sheet_img[0])
          .whenComplete(() async {
        await size_chart_reference
            .getDownloadURL()
            .then((value) => {size_chart_img_urls = value});
      });
      if (prev_size_sheet_image != "")
        products_img_docreference.refFromURL(prev_size_sheet_image).delete();
    } else {
      if (is_size_color_selected.value == false &&
          is_color_selected.value == false &&
          is_liquid_selected.value == false) {
        size_chart_img_urls = "";
        if (prev_size_sheet_image != "")
          products_img_docreference.refFromURL(prev_size_sheet_image).delete();
      } else {
        size_chart_img_urls = prev_size_sheet_image;
      }
    }
    if (is_size_color_selected.value == true) {
      quantity.value = "0";
      await calculate_size_color_quantity();
    } else if (is_color_selected.value == true) {
      quantity.value = "0";
      for (var val in color_quantity_list)
        quantity.value =
            (int.parse(quantity.value) + int.parse(val)).toString();
    } else if (is_liquid_selected.value == true) {
      quantity.value = "0";
      for (var val in liquid_quantity_list)
        quantity.value =
            (int.parse(quantity.value) + int.parse(val)).toString();
    }
    await documentReference.update({
      "product_img": product_img_urls,
      "product_first_img": product_first_img_urls,
      "size_chart_img": size_chart_img_urls,
      "initial_price": is_liquid_selected.value
          ? liquid_ml_price_list[0].toString()
          : initial_price.value.toString(),
      "final_price": final_price.value,
      "off_percent": off_percent.value.toString(),
      "product_given_id": product_id.value.toString(),
      "brand_name": widget.product_details_doc["brand_name"].toString(),
      "brand_id": widget.product_details_doc["brand_id"].toString(),
      "category_name": selectedcategory["category_name"].toString(),
      "quantity": quantity.value.toString(),
      "weight_per_kg": weight_per_kg.value.toString(),
      "product_title": title.value.toString(),
      "product_description": description.value.toString(),
      "product_season": selectedSeason.toString(),
      "search_tags": FieldValue.arrayUnion(tags),
      "product_buying_limit": buying_limit.value.toString(),
      "product_editing_time":
          new DateTime.now().microsecondsSinceEpoch.toString(),
      "is_size_color_selected": is_size_color_selected.value.toString(),
      "is_color_selected": is_color_selected.value.toString(),
      "is_liquid_selected": is_liquid_selected.value.toString(),
      "color_selected_listXS": color_selected_listXS,
      "color_selected_listS": color_selected_listS,
      "color_selected_listM": color_selected_listM,
      "color_selected_listL": color_selected_listL,
      "color_selected_listXL": color_selected_listXL,
      "color_selected_listXXL": color_selected_listXXL,
      "color_selected_list3XL": color_selected_list3XL,
      "size_color_quantity_listXS": size_color_quantity_listXS,
      "size_color_quantity_listS": size_color_quantity_listS,
      "size_color_quantity_listM": size_color_quantity_listM,
      "size_color_quantity_listL": size_color_quantity_listL,
      "size_color_quantity_listXL": size_color_quantity_listXL,
      "size_color_quantity_listXXL": size_color_quantity_listXXL,
      "size_color_quantity_list3XL": size_color_quantity_list3XL,
      "color_selected_list": color_selected_list,
      "color_quantity_list": color_quantity_list,
      "liquid_ml_list": liquid_ml_list,
      "liquid_weight_list":liquid_weight_list,
      "liquid_ml_price_list": liquid_ml_price_list,
      "liquid_quantity_list": liquid_quantity_list,
    }).then((value) {
      loadingController.close_dialogue(new_context);
      show_snackbar(context, edtd_sccs, yellowColor, darkBlueColor);
    }).onError((error, stackTrace) {
      loadingController.close_dialogue(new_context);
      show_snackbar(context, error.toString(), whiteColor, Colors.red);
    });
  }

  Future<void> calculate_size_color_quantity() async {
    for (var val in size_color_quantity_listXS)
      quantity.value = (int.parse(quantity.value) + int.parse(val)).toString();
    for (var val in size_color_quantity_listS)
      quantity.value = (int.parse(quantity.value) + int.parse(val)).toString();
    for (var val in size_color_quantity_listM)
      quantity.value = (int.parse(quantity.value) + int.parse(val)).toString();
    for (var val in size_color_quantity_listL)
      quantity.value = (int.parse(quantity.value) + int.parse(val)).toString();
    for (var val in size_color_quantity_listXL)
      quantity.value = (int.parse(quantity.value) + int.parse(val)).toString();
    for (var val in size_color_quantity_listXXL)
      quantity.value = (int.parse(quantity.value) + int.parse(val)).toString();
    for (var val in size_color_quantity_list3XL)
      quantity.value = (int.parse(quantity.value) + int.parse(val)).toString();
  }

  bool validate_everything(context) {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  showAlertDialog(BuildContext context) async => showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: new Text(
            'Are you sure?',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
          ),
          content: new Text(
            "Do you really want to Delete this Product ?",
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
                Navigator.of(context).pop(),
                Navigator.of(context).pop(),
                products_docreference.doc(widget.poduct_id).delete(),
                delete_previous_img(),
                if (prev_size_sheet_image.length > 0)
                  products_img_docreference
                      .refFromURL(prev_size_sheet_image)
                      .delete(),
              },
              child: new Text('Yes'),
            ),
          ],
        ),
      );

  Future<void> delete_previous_img() async {
    for (var val in product_prev_img_list) {
      await products_img_docreference.refFromURL(val).delete();
    }
  }
}
