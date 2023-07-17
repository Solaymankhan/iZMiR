import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/strings.dart';
import '../controllers/brands_controller.dart';
import '../shapes/bar_with_back_button.dart';

class brands_and_shops_page extends StatelessWidget {
  brands_and_shops_page({Key? key}) : super(key: key);

  final brands_controller brandController = Get.find();

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
                bar_with_back_button(context,brands_shops_txt),
                Expanded(
                    child: brandController.all_brands_shape(het, wdt)
                ),
              ],
            )),
      ),
    );
  }
}
