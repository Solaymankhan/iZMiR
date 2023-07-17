import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../controllers/cart_controller.dart';
import 'circuler_small_button.dart';

Widget orders_shape(cartController, wdt) {
  return ListView.builder(
      controller: cartController.scrollController,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: cartController.cart_data.length,
      itemBuilder: (context, index) {
        return Material(
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            child: Ink(
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: lightGreyColor),
              child: Row(
                children: [
                  Container(
                    width: wdt * 0.65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: null,
                    ),
                    child: Row(
                      children: [
                        Container(
                            height: 60,
                            width: 60,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(cartController
                                      .cart_data[index].product_img),
                                ))).box.padding(EdgeInsets.all(3)).make(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: wdt * 0.45,
                              child: Text(
                                cartController
                                    .cart_data[index].product_description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icon/taka_svg.svg',
                                  width: 15,
                                ),
                                Text(
                                  cartController.cart_data[index].product_price,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          ],
                        )
                            .box
                            .padding(EdgeInsets.only(top: 7, bottom: 7))
                            .make(),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      "Deivered",
                      style: TextStyle(
                          color: darkBlueColor, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
            .box
            .margin(EdgeInsets.only(left: 10, top: 2.5, bottom: 2.5, right: 10))
            .make();
      });
}
