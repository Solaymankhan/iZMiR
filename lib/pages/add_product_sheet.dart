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
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/circuler_small_color_button.dart';
import '../shapes/snack_bar.dart';

class add_product_sheet extends StatefulWidget {
  add_product_sheet({Key? key,required this.brand,required this.brand_id}) : super(key: key);
  var brand,brand_id;

  @override
  State<add_product_sheet> createState() => _add_product_sheetState();
}

class _add_product_sheetState extends State<add_product_sheet> {
  final category_controller categoryController = Get.find();

  final brands_controller brandController = Get.find();

  final loading_dialogue_controller loadingController = Get.find();

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
      cat_list = [].obs;

  RxList product_img_uint_list= [].obs,compressed_size_sheet_img = [].obs;

  String product_img_urls = "",product_first_img_urls = "", size_chart_img_urls = "";

  RxInt variation_value = 0.obs,
      off_percent = 0.obs,
      initial_price = 0.obs,
      quantity = 0.obs,
      buying_limit = 0.obs,
      weight_per_kg = 0.obs,
      color_count = 1.obs;

  RxList liquid_quantity_list = ["0"].obs,
      liquid_weight_list = ["0"].obs,
      liquid_ml_list = ["0"].obs,
      liquid_ml_price_list = ["0"].obs,
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
      product_id = "".obs,
      final_price="0".obs;

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

  final _formKey = GlobalKey<FormState>();
  var selectedcategory,selectedSeason=seasons_list[0];
  var my_category_list = [].obs;

  @override
  void initState() {
    category_list();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    add_product_txt,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ).box.margin(EdgeInsets.only(bottom: 3)).make(),
                ],
              ).box.padding(EdgeInsets.only(top: 5)).make(),
              Flexible(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: het * 0.4,
                            width: double.infinity,
                            child: Swiper(
                              physics: product_img_uint_list.length == 0
                                  ? NeverScrollableScrollPhysics()
                                  : ScrollPhysics(),
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
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      image: new DecorationImage(
                                        image: product_img_uint_list.length == 0
                                            ? AssetImage(product_image_icon)
                                            : MemoryImage(product_img_uint_list[index]) as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: product_img_uint_list.length == 0
                                  ? 1
                                  : product_img_uint_list.length,
                              pagination: product_img_uint_list.length == 0
                                  ? null
                                  : SwiperPagination(
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
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.brand["brand_icon"],
                                        imageBuilder: (context, url)=>brand_network_image_shape(url),
                                        placeholder: (context, url)=> brand_asset_image_shape(),
                                        errorWidget: (context, url, error) =>  brand_asset_image_shape(),
                                      ),
                                    ),
                                    Visibility(
                                      visible: widget.brand['brand_verified']=="verified"?true:false,
                                      child: Container(
                                          height: 13,
                                          width: 13,
                                          decoration: BoxDecoration(
                                              color: yellowColor,
                                              borderRadius:
                                              BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: whiteColor,
                                                  width: 1)
                                          ),
                                          child:Icon(
                                            Icons.check,
                                            color: darkBlueColor,
                                            size: 10,
                                          )
                                      ),
                                    )
                                  ],).marginOnly(right: 5),
                                Flexible (
                                  child: Text(widget.brand["brand_name"],
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.w400),),
                                )
                              ],),
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
                                          decoration: TextDecoration.lineThrough,
                                          fontWeight: FontWeight.w500,
                                          color: FontGreyColor),
                                    ),
                                    Text(
                                      "${off_percent.value}% off",
                                      style: TextStyle(color: orangeColor),
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
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        labelText: "Initial Price",
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
                                        initial_price.value =
                                        val.length == 0 ? 0 : int.parse(val);
                                        final_price_calculation();
                                      },
                                      validator: (value) {
                                        if (value.toString().length == 0) {
                                          return "Field can't be empty";
                                        }
                                        return null;
                                      },
                                    ).box.margin(EdgeInsets.only(right: 5)).make(),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        labelText: "Off",
                                        contentPadding: EdgeInsets.all(8),
                                        border: OutlineInputBorder(),
                                        prefixIcon:
                                        Icon(CupertinoIcons.percent),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      maxLength: 2,
                                      onChanged: (val) {
                                        off_percent.value = val.length == 0
                                            ? 0
                                            : int.parse(val);
                                        final_price_calculation();
                                      })
                                      .box
                                      .margin(EdgeInsets.only(left: is_liquid_selected.value?0:5))
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
                                          BorderRadius.circular(100),
                                          image: new DecorationImage(
                                            image: e['sub_category_icon']
                                                .toString()
                                                .length ==
                                                0
                                                ? AssetImage(add_icon)
                                                : NetworkImage(e[
                                            'sub_category_icon'])
                                            as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                          .box
                                          .margin(
                                          EdgeInsets.only(right: 10))
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
                                          borderRadius: BorderRadius.circular(50),
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
                                      .margin(EdgeInsets.only(left: 3, right: 10))
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
                                          borderRadius: BorderRadius.circular(50),
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
                                      .margin(EdgeInsets.only(left: 3, right: 10))
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
                                      final_price.value="0";
                                    },
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: is_liquid_selected.value
                                              ? darkBlueColor
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(50),
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
                                      .margin(EdgeInsets.only(left: 3, right: 10))
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
                                        ImagePicker imagePicker = ImagePicker();
                                        XFile? img = await imagePicker.pickImage(
                                            source: ImageSource.gallery);
                                        compressed_size_sheet_img.clear();
                                        if(img!=null)
                                          compressed_size_sheet_img.add(
                                              (await FlutterImageCompress
                                                  .compressWithFile(
                                                  img!.path,
                                                  quality: 25))!);
                                      },
                                      child: Ink(
                                        height: het > wdt ? het * 0.2 : wdt * 0.2,
                                        width: double.infinity,
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                              width: 1, color: lightGreyColor),
                                          image: new DecorationImage(
                                            image: compressed_size_sheet_img.length == 0
                                                ? AssetImage(product_image_icon)
                                                : MemoryImage(compressed_size_sheet_img[0]) as ImageProvider,
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
                                    val.length == 0 ? 0 : int.parse(val);
                                  },
                                  validator: (value) {
                                    if (value.toString().length == 0) {
                                      return "Field can't be empty";
                                    } else if (int.parse(value.toString()) == 0) {
                                      return "Field value can't be 0";
                                    }
                                    return null;
                                  },
                                )),
                            10.heightBox,
                            Visibility(
                              visible: !is_liquid_selected.value,
                              child: TextFormField(
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: "Weight per Piece (g)",
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
                                  val.length == 0 ? 0 : int.parse(val);
                                },
                                validator: (value) {
                                  if (value.toString().length == 0) {
                                    return "Field can't be empty";
                                  } else if (double.parse(value.toString()) == 0) {
                                    return "Field value can't be 0";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            10.heightBox,
                            SizedBox(
                              child: TextFormField(
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
                                  search_tags.value = val.length == 0 ? "" : val;
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
                                val.length == 0 ? 0 : int.parse(val);
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
                                        borderRadius: BorderRadius.circular(6),
                                        color: darkBlueColor),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                          ],).marginOnly(left: 15,right: 15)
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  final_price_calculation(){
   if(is_liquid_selected.value){
     if(is_liquid_selected.value && off_percent.value == 0){
       final_price.value=liquid_ml_price_list[0].toString();
       initial_price.value=0;
     }else{
       final_price.value=(int.parse(liquid_ml_price_list[0]) - ((off_percent.value
           * int.parse(liquid_ml_price_list[0])) / 100)).toStringAsFixed(0);
       initial_price.value=int.parse(liquid_ml_price_list[0]);
     }
   }else{
     final_price.value= off_percent.value == 0 ?
     initial_price.value.toStringAsFixed(0) :
     (initial_price.value - ((off_percent.value
         * initial_price.value) / 100)).toStringAsFixed(0);
   }
  }

  category_list(){
    Future.delayed(Duration(milliseconds: 200), () async {
      my_category_list.clear();
      for (int i = 0; i < brandController.mybrandlist.length; i++) {
        if (brandController.mybrandlist[i]["brand_name"] == widget.brand["brand_name"]) {
          cat_list.value = await brandController.mybrandlist[i]['brand_categories'];
        }
      }
      for (var val in categoryController.allsubCategorylist) {
        if (cat_list.contains(val['sub_category_name'])) {
          my_category_list.add(val);
        }
      }
      selectedcategory = my_category_list[0];
    });
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
                        liquid_quantity_list.clear();
                        liquid_ml_price_list.clear();
                        for (int j = 0; j < int.parse(selectednumberofliquid.value);j++) {
                          liquid_ml_list.add("0");
                          liquid_weight_list.add("0");
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            labelText: "Size/Ml...",
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                            ),
                        maxLength: 10,
                        onChanged: (val) {
                          liquid_ml_list[i - 1] =
                              val.length > 0 ? val.toString() : "0";
                        },
                      ).box.height(60).margin(EdgeInsets.only(right: 5)).make(),
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            labelText: "Weight per piece(g)",
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
                          liquid_weight_list[i - 1] =
                          val.length > 0 ? val.toString() : "0";
                        },
                      ).box.height(60).margin(EdgeInsets.only(left:5,right: 5)).make(),
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Price per piece",
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d*')),
                        ],
                        maxLength: 9,
                        onChanged: (val) {
                          liquid_ml_price_list[i - 1] =
                          val.length > 0 ? val.toString() : "0";
                          if(i-1==0){
                            final_price_calculation();
                          }
                        },
                      ).box.height(60).margin(EdgeInsets.only(left:5,right: 5)).make(),
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Quantity",
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
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
                      ).box.height(60).margin(EdgeInsets.only(left: 5)).make(),
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
    quantity.value = 0;
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
    liquid_ml_price_list.clear();
    liquid_ml_list.clear();
    color_quantity_list.clear();
    size_color_quantity_listXS.clear();
    size_color_quantity_listS.clear();
    size_color_quantity_listM.clear();
    size_color_quantity_listL.clear();
    size_color_quantity_listXL.clear();
    size_color_quantity_listXXL.clear();
    size_color_quantity_list3XL.clear();
    liquid_quantity_list.add("0");
    liquid_weight_list.add("0");
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
    if(is_liquid_selected.value){
      initial_price.value=0;
      weight_per_kg.value=0;
    }
    if(is_size_color_selected.value){
      for (int i = 0; i < 7; i++) product_size_selected[i] = false;
    }
  }

  add_in_database(context) async {
    product_img_urls = "";
    product_first_img_urls = "";
    loadingController.show_dialogue(context);
    List tags = search_tags.value.split("#");

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("products").doc();
    Reference size_chart_reference = FirebaseStorage.instance
        .ref()
        .child("products_picture")
        .child(widget.brand["brand_name"])
        .child(new DateTime.now().microsecondsSinceEpoch.toString());

    for (int i = 0; i < product_img_uint_list.length; i++) {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("products_picture")
          .child(widget.brand["brand_name"])
          .child(new DateTime.now().microsecondsSinceEpoch.toString());
      await reference.putData(product_img_uint_list[i]).whenComplete(() async {
        await reference.getDownloadURL().then((value) => {
              product_img_urls = "${product_img_urls + "  " + value}",
               if(i==0) product_first_img_urls=value
            });
      });
    }
    if (!compressed_size_sheet_img.isEmpty) {
      await size_chart_reference
          .putData(compressed_size_sheet_img[0])
          .whenComplete(() async {
        await size_chart_reference
            .getDownloadURL()
            .then((value) => {size_chart_img_urls = value});
      });
    }

    if(is_size_color_selected.value==true){
      quantity.value=0;
      await calculate_size_color_quantity();
    }
    else if(is_color_selected.value==true){
      quantity.value=0;
      for(var val in color_quantity_list)
        quantity.value=(quantity.value+int.parse(val));
    }
    else if(is_liquid_selected.value==true){
      quantity.value=0;
      for(var val in liquid_quantity_list)
        quantity.value=(quantity.value+int.parse(val));
    }

    await documentReference.set({
      "product_img": product_img_urls,
      "product_first_img": product_first_img_urls,
      "size_chart_img": size_chart_img_urls,
      "initial_price": is_liquid_selected.value?liquid_ml_price_list[0].toString()
          :initial_price.value.toString(),
      "final_price": final_price.value,
      "off_percent": off_percent.value.toString(),
      "product_given_id": product_id.value.toString(),
      "brand_name": widget.brand["brand_name"].toString(),
      "brand_icon":widget.brand["brand_icon"].toString(),
      "brand_offer": widget.brand["brand_offer"].toString(),
      "brand_and_product_offer": (int.parse(widget.brand["brand_offer"])+off_percent.value).toStringAsFixed(0),
      "brand_verified": widget.brand["brand_verified"].toString(),
      "brand_id": widget.brand_id.toString(),
      "brand_division": widget.brand["brand_division"].toString(),
      "brand_district": widget.brand["brand_district"].toString(),
      "brand_full_address": widget.brand["brand_full_location"].toString(),
      "category_name": selectedcategory['sub_category_name'].toString(),
      "quantity": quantity.value.toString(),
      "weight_per_kg": weight_per_kg.value.toString(),
      "product_title": title.value.toString(),
      "product_description": description.value.toString(),
      "product_season": selectedSeason.toString(),
      "search_tags": FieldValue.arrayUnion(tags),
      "product_buying_limit": buying_limit.value.toString(),
      "product_clicked": 0,
      "product_likes": 0,
      "product_comments": 0,
      "product_rating": 0,
      "product_adding_time": new DateTime.now().microsecondsSinceEpoch.toString(),
      "is_size_color_selected": is_size_color_selected.value.toString(),
      "is_color_selected": is_color_selected.value.toString(),
      "is_liquid_selected": is_liquid_selected.value.toString(),
      "sell_will_start_from": new DateTime.now().microsecondsSinceEpoch.toString(),


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
      loadingController.close_dialogue(context);
      show_snackbar(context, sccs_add, yellowColor, darkBlueColor);
    }).onError((error, stackTrace) {
      loadingController.close_dialogue(context);
      show_snackbar(context, error.toString(), whiteColor, Colors.red);
    });
  }

  Future<void>  calculate_size_color_quantity()async{
    for(var val in size_color_quantity_listXS)
      quantity.value=(quantity.value+int.parse(val));
    for(var val in size_color_quantity_listS)
      quantity.value=(quantity.value+int.parse(val));
    for(var val in size_color_quantity_listM)
      quantity.value=(quantity.value+int.parse(val));
    for(var val in size_color_quantity_listL)
      quantity.value=(quantity.value+int.parse(val));
    for(var val in size_color_quantity_listXL)
      quantity.value=(quantity.value+int.parse(val));
    for(var val in size_color_quantity_listXXL)
      quantity.value=(quantity.value+int.parse(val));
    for(var val in size_color_quantity_list3XL)
      quantity.value=(quantity.value+int.parse(val));
  }

  bool validate_everything(context) {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    if (product_img_uint_list.isEmpty) {
      show_snackbar(context, pr_img_empty, whiteColor, Colors.red);
      return false;
    }
    return true;
  }
}
