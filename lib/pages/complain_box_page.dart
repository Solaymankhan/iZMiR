import 'package:flutter/cupertino.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/cart_controller_2.dart';
import '../shapes/bar_with_back_button.dart';



class complain_box_page extends StatelessWidget {
  final cartController = Get.put(cart_controller_2());

  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    final maxLines = 5;
    return Scaffold(
      body: Container(
        color: whiteColor,
        child: SafeArea(
          child: Column(
            children: [
              bar_with_back_button(context,conplain_box_txt),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      5.heightBox,
                      SizedBox(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Write here...',
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(fontSize: 16),
                          maxLines: null,
                          minLines: 5,
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(top: 10),
                          child: Material(
                            borderRadius: BorderRadius.circular(6),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(6),
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: darkBlueColor,
                                ),
                                height: 35.0,
                                width: 100.0,
                                child: Text(
                                  submit,
                                  style: TextStyle(
                                      fontSize: 15.0,color: yellowColor, fontWeight: FontWeight.w500),
                                ).box.alignCenter.make(),
                              ),
                            ),
                          ),)
                    ],
                  ).box.margin(EdgeInsets.only(right: 15,left: 15,bottom: 15)).make()
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
