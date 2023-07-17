import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';

class view_category_items extends StatelessWidget {
  view_category_items({Key? key,@required this.category_name}) : super(key: key);
  final category_name;
  @override
  Widget build(BuildContext context) {
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
                          category_name,
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ).box.margin(EdgeInsets.only(bottom: 3)).make(),
                      ],
                    ),
                  ],
                ).box.padding(EdgeInsets.only(top: 5)).make(),
                Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // category_button_cart(item_icon_list, item_name_list, het, wdt)
                        ],
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
