import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izmir/pages/view_category_items.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/images.dart';
import '../consts/lists.dart';
import '../consts/strings.dart';
import '../controllers/brands_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/drawer_controller.dart';
import '../controllers/loading_dialogue_controller.dart';
import '../shapes/snack_bar.dart';
import 'apply_brand_page.dart';

final category_controller categoryController = Get.find();
final drawer_controller drawerController = Get.find();
final brands_controller brandController = Get.find();
final loading_dialogue_controller loadingController = Get.find();

class my_brands_page extends StatelessWidget {
  my_brands_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: Container(
        color: whiteColor,
        child: SafeArea(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                             Navigator.of(context).pop();
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
                      my_brands_txt,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ).box.margin(EdgeInsets.only(bottom: 3)).make(),
                  ],
                ),
                Material(
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => apply_brand_page()));
                    },
                    child: Ink(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: lightGreyColor),
                        child: Icon(Icons.add)),
                  ),
                ).box.margin(EdgeInsets.only(right: 15)).make()
              ],
            ).box.padding(EdgeInsets.only(top: 5)).make(),
            Obx(()=> Expanded(
                  child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: brandController.getedit_brands_data(het, wdt),
              )),
            ),
          ],
        )),
      ),
    );
  }
}
