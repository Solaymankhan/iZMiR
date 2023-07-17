import 'package:flutter/cupertino.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller_2.dart';
import '../shapes/bar_with_back_button.dart';




class statistics_page extends StatelessWidget {
  statistics_page({Key? key,required this.brand_details,required this.brand_id}) : super(key: key);
 var brand_details,brand_id;
  bool is_selected = false;

  @override
  Widget build(BuildContext context) {
    var cartController = Get.put(cart_controller_2());
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: Container(
        color: whiteColor,
        child: SafeArea(
          child: Column(
            children: [
              bar_with_back_button(context,cart_txt),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                  ),
                  GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: is_selected ? darkBlueColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          border: is_selected
                              ? null
                              : Border.all(color: textFieldGreyColor, width: 2)),
                      child: is_selected
                          ? Icon(
                        Icons.check,
                        color: whiteColor,
                        size: 13,
                      )
                          : null,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      select_all,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
              10.heightBox,
              Flexible(
                child: Container()
              ),
            ],
          ),
        ),
      ),
    );
  }
}
