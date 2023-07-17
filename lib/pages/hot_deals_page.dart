import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/strings.dart';
import '../controllers/hot_deals_controller.dart';
import '../shapes/bar_with_back_button.dart';

class hot_deals_page extends StatelessWidget {
  hot_deals_page({Key? key}) : super(key: key);
  final hot_deals_controller hotDealsController = Get.find();
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
                bar_with_back_button(context,hot_deals_txt),
                hotDealsController.hot_deals_shape(het, wdt).expand(),
              ],
            )),
      ),
    );
  }
}
