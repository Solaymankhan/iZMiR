import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/strings.dart';
import '../controllers/special_sales_controller.dart';
import '../shapes/bar_with_back_button.dart';

class special_sales_page extends StatelessWidget {
  special_sales_page({Key? key}) : super(key: key);
  final specialSallesController = Get.put(special_sales_controller());

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
                bar_with_back_button(context,spcl_sls_txt),
                Expanded(
                    child: specialSallesController.getview_brands_data(het, wdt).marginOnly(left: 15,right: 15)
                ),
              ],
            )),
      ),
    );
  }
}
