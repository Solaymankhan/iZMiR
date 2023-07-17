import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izmir/shapes/snack_bar.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/lists.dart';
import '../controllers/category_controller.dart';
import '../pages/view_category_items.dart';
import 'all_product_network_image_shape.dart';

final category_controller categoryController=Get.find();
var category_img_docreference=FirebaseStorage.instance;
var docimgreference = FirebaseFirestore.instance.collection("category");
Uint8List selected_image = Uint8List.fromList([0]);
RxString selectedval = "".obs,image="".obs,name="".obs,time="".obs,cat_id="".obs,off_percent="".obs;


Widget home_category_button_shape(all_categorylist, het, wdt) {
  return
    Container(
        width: double.infinity,
        height: 100,
        padding: EdgeInsets.only(top: 15, bottom: 20),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: whiteColor),
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: all_categorylist.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return
                Material(
                  borderRadius: BorderRadius.circular(6),
                  color: whiteColor,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => view_category_items
                                (category_name: all_categorylist[index]['sub_category_name'],)));
                    },
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: all_categorylist[index]['sub_category_icon'],
                          imageBuilder: (context, url)=>brand_ink_network_image_shape(url),
                          placeholder: (context, url)=> brand_ink_asset_image_shape(),
                          errorWidget: (context, url, error) =>  brand_ink_asset_image_shape(),
                        ),
                        5.heightBox,
                        Text(
                          all_categorylist[index]['sub_category_name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: darkFontGreyColor,
                            fontWeight: FontWeight.w500
                          ),
                        ).marginOnly(left: 5,right: 5)
                      ],
                    ),
                  ),
                ).box.width(75).margin(EdgeInsets.only(left: index==0?5:0,right:index==all_categorylist.length-1?10:0)).make();
            })
    );
}

