import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/cart_controller_2.dart';
import '../controllers/drawer_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/circuler_small_button.dart';
import '../shapes/dont_have_any_data.dart';
import '../shapes/snack_bar.dart';
import 'buy_product_page.dart';

class cart_page_2 extends StatefulWidget {
  cart_page_2({Key? key}) : super(key: key);

  @override
  State<cart_page_2> createState() => _cart_page_2State();
}

class _cart_page_2State extends State<cart_page_2> {
  final cart_controller cartController = Get.find();
  final drawer_controller drawerController = Get.find();

  @override
  void dispose(){
    Future.delayed(Duration(milliseconds: 100), () {
      cartController.is_all_selected.value=false;
      cartController.cart_products.clear();
      cartController.product_id_map.clear();
      cartController.product_selected_map.clear();
      cartController.removable_cart_info_map.clear();
      cartController.product_available_quantity_map.clear();
      cartController.cart_amnt.clear();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Stack(children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                          alignment: Alignment.centerRight,
                          height: 50,
                          margin: EdgeInsets.only(right: 10),
                          child: Material(
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Ink(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.back,
                                    color: Colors.black,
                                  )),
                            ),
                          )).marginOnly(left: 15),
                      Text(
                        cart_txt,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ).box.margin(EdgeInsets.only(bottom: 3)).make(),
                      Text(
                        "  ( ${drawerController.total_items_in_cart.value} )",
                        style: TextStyle( fontSize: 14),
                      ),
                    ],),
                    Visibility(
                      visible: cartController.is_all_selected.value,
                      child: Material(
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: () {
                            drawerController.removeCarts();
                            cartController.get_product_data();
                            cartController.total_price.value='0';
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: Ink(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: whiteColor,
                              ),
                              child: Icon(CupertinoIcons.delete,color: Colors.black,)

                          ),
                        ),
                      ),
                    ),
                  ],
                ).box.padding(EdgeInsets.only(top: 5,right: 15)).make(),
                Visibility(
                  visible: !cartController.cart_products.isEmpty,
                  child: Row(
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              cartController.is_all_selected.value=!cartController.is_all_selected.value;
                              drawerController.cart.forEach((key, value) {
                                cartController.product_selected_map[key]!
                                    .fillRange(0, value.length,cartController.is_all_selected.value);
                              });
                              cartController.total_price_calculation();
                            },
                            child: Ink(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: whiteColor
                              ),
                              child: Container(
                                width: 20,
                                padding: EdgeInsets.all(10),
                                child:
                                cartController.is_all_selected.value
                                    ? SvgPicture.asset(
                                  green_circle_icon,
                                )
                                    : SvgPicture.asset(
                                  white_circle_icon,
                                ),
                              ),)
                        ),
                      ).marginOnly(left: 10),
                      Text(
                        select_all,
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                10.heightBox,
                Flexible(
                    child: drawerController.cart.length!=0?cartController.cart_shape(het,wdt):
                    dont_have_any_data(het)
                ),
                45.heightBox
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: !cartController.cart_products.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Total : ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SvgPicture.asset(
                          'assets/icon/taka_svg.svg',
                          width: 16,
                        ),
                        Text(
                          cartController.total_price.value,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(6),
                      child: InkWell(
                        onTap: () {
                          if(cartController.iter==0){
                            show_snackbar(context,select_prdct_txt,whiteColor,Colors.red);
                          }else{
                            int valid=0;
                            cartController.product_available_quantity_map.forEach((key, value) {
                              for(int i=0;i<value!.length;i++){
                                if(value[i]!="Not Available" && cartController.product_selected_map[key]![i]==true){
                                  valid++;
                                }
                              }
                            });
                            if(valid!=0){
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>buy_product_page()));
                            }else{
                              show_snackbar(context,not_avlbl_txt,whiteColor,Colors.red);
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: darkBlueColor,
                          ),
                          height: 40.0,
                          width: wdt * 0.35,
                          child: Text(
                            buy,
                            style: TextStyle(
                                fontSize: 15.0,
                                color: yellowColor,
                                fontWeight: FontWeight.w500),
                          ).box.alignCenter.make(),
                        ),
                      ),
                    ).box.margin(EdgeInsets.all(3)).make(),
                  ],
                )
                    .box
                    .padding(EdgeInsets.only(right: 20,left: 20))
                    .color(lightGreyColor)
                    .make(),
              ),
            )
          ],)
        ),
      ).color(whiteColor),
    );
  }
}
