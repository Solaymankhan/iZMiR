import 'package:flutter/cupertino.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/cart_controller_2.dart';
import '../shapes/bar_with_back_button.dart';



class rules_and_guide_page extends StatelessWidget {
  final cartController = Get.put(cart_controller_2());

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
              bar_with_back_button(context,Rules_and_guide_txt),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Text(para,style: TextStyle(fontSize: 15),).box.margin(EdgeInsets.only(left: 15,right: 15,bottom: 20)).make(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
