import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/colors.dart';
import 'circuler_small_button.dart';

Widget notification_shape(cartController,wdt) {
  return ListView.builder(
      controller: cartController.scrollController,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: cartController.cart_data.length,
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: lightGreyColor),
          margin: EdgeInsets.only(
              left: 10, top: 2.5, bottom: 2.5, right: 10),
          padding: EdgeInsets.only(left: 3),
          child: Row(
            children: [
              Material(
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(6),
                  child: Ink(
                    color: lightGreyColor,
                    width: wdt*0.8,
                    child: Row(
                      children: [
                        Container(
                            height: 90,
                            width: 120,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(6),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(cartController
                                      .cart_data[index]
                                      .product_img),
                                )))
                            .box
                            .padding(EdgeInsets.all(3))
                            .make(),
                        Container(
                              width: wdt*0.45,
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(top: 5,bottom: 5),
                              child: Text(
                                cartController
                                    .cart_data[index]
                                    .product_description,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(50),
                      child: Ink(
                        height: 30,
                        width: 30,
                        color: lightGreyColor,
                        child: Icon(CupertinoIcons.xmark,size: 20.0),
                      ),
                    ),
                  ).box.margin(EdgeInsets.only(right: 5)).make(),
                ],
              )
            ],
          ),
        );
      });
}