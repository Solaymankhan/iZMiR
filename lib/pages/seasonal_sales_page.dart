import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/strings.dart';
import '../controllers/app_setting_controller.dart';
import '../shapes/bar_with_back_button.dart';

class seasonal_sales_page extends StatelessWidget {
  seasonal_sales_page({Key? key}) : super(key: key);
  final app_setting_controller appSettingController = Get.find();

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
                bar_with_back_button(context,appSettingController.seasonal_sale_name.value),
                Expanded(
                    child:   appSettingController.seaconal_sales_vertical(het, wdt),
        ),
              ],
            )),
      ),
    );
  }
}
