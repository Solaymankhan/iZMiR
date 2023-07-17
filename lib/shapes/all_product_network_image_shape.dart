import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/images.dart';

Widget all_product_network_image_shape(url){
  return Container(
      height: 180,
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: url,
          )));
}

Widget all_product_asset_image_shape(){
  return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(izmir_error_img_icon),
          )));
}

Widget home_network_swiper_image_shape(url){
  return Container(
    margin: EdgeInsets.only(left: 2,right: 2),
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      image: new DecorationImage(
        image: url,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget home_file_swiper_image_shape(file){
  return Container(
    margin: EdgeInsets.only(left: 2,right: 2),
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      image: new DecorationImage(
        image: MemoryImage(file),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget home_asset_swiper_image_shape(){
  return Container(
    margin: EdgeInsets.only(left: 2, right: 2),
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      image: new DecorationImage(
        image:AssetImage(izmir_error_img_icon),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget all_product_network_swiper_image_shape(url){
  return Container(
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      image: new DecorationImage(
        image: url,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget all_product_file_swiper_image_shape(file){
  try {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: new DecorationImage(
          image: MemoryImage(file),
          fit: BoxFit.cover,
        ),
      ),
    );
  } catch (e) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: new DecorationImage(
          image: AssetImage(izmir_error_img_icon),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

Widget all_product_asset_swiper_image_shape(){
  return Container(
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      image: new DecorationImage(
        image:AssetImage(izmir_error_img_icon),
        fit: BoxFit.cover,
      ),
    ),
  );
}



Widget brand_network_image_shape(url){
  return Container(
    height: 40,
    width: 40,
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(
          width: 1,
          color: lightGreyColor),
      image: new DecorationImage(
        image: url,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget brand_asset_image_shape(){
  return Container(
    height: 40,
    width: 40,
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(
          width: 1,
          color: lightGreyColor),
      image: new DecorationImage(
        image: AssetImage(izmir_error_img_icon),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget brand_ink_network_image_shape(url){
  return Ink(
    height: 40,
    width: 40,
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(
          width: 1,
          color: lightGreyColor),
      image: new DecorationImage(
        image: url,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget brand_ink_asset_image_shape(){
  return Ink(
    height: 40,
    width: 40,
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(
          width: 1,
          color: lightGreyColor),
      image: new DecorationImage(
        image: AssetImage(izmir_error_img_icon),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget brand_small_network_image_shape(url){
  return  Container(
    height: 30,
    width: 30,
    decoration: new BoxDecoration(
      borderRadius:
      BorderRadius.circular(
          100),
      border: Border.all(
          width: 1,
          color: whiteColor),
      image: new DecorationImage(
        image: url,
        fit: BoxFit.cover,
      ),
    ),
  )
      .box
      .padding(EdgeInsets.all(2))
      .make();
}

Widget brand_small_asset_image_shape(){
  return  Container(
    height: 30,
    width: 30,
    decoration: new BoxDecoration(
      borderRadius:
      BorderRadius.circular(
          100),
      border: Border.all(
          width: 1,
          color: whiteColor),
      image: new DecorationImage(
        image: AssetImage(izmir_error_img_icon),
        fit: BoxFit.cover,
      ),
    ),
  )
      .box
      .padding(EdgeInsets.all(2))
      .make();
}

Widget profile_network_image_shape(url){
  return Ink(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(100),
          border: Border.all(
              width: 1,
              color: darkFontGreyColor),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: url,
          )));
}

Widget profile_asset_image_shape(){
  return Ink(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(100),
          border: Border.all(
              width: 1,
              color: darkFontGreyColor),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(profile_avater),
          )));
}

Widget product_size_chart_network_image_shape(url){
  return Container(
    width: double.infinity,
    height: 220,
    margin: EdgeInsets.only(left: 2, right: 2),
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      image: new DecorationImage(
        image: url,
        fit: BoxFit.scaleDown,
      ),
    ),
  );
}

Widget product_size_chart_asset_image_shape(){
  return Container(
    margin: EdgeInsets.only(left: 2, right: 2),
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      image: new DecorationImage(
        image:AssetImage(izmir_error_img_icon),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget event_network_image_shape(url){
  return Container(
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      image: new DecorationImage(
        image: url,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget event_asset_image_shape(){
  return Container(
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      image: new DecorationImage(
        image: AssetImage(izmir_error_img_icon),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget special_sales_network_image_shape(url,wdt){
  return Ink(
      height: 100,
      width: wdt/2,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: new DecorationImage(
          image: url,
          fit: BoxFit.cover,
        ),
      ),
    );
}
Widget special_sales_asset_image_shape(wdt){
  return Ink(
    height: 100,
    width: wdt/2,
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      image: new DecorationImage(
        image: AssetImage(izmir_error_img_icon),
        fit: BoxFit.cover,
      ),
    ),
  );
}


Widget cart_network_image_shape(url){
  return Container(
      height: 100,
      width: 60,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(6),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: url,
          )
      ))
      .box
      .padding(EdgeInsets.all(3))
      .make();
}
Widget cart_asset_image_shape(){
  return Container(
      height: 100,
      width: 60,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(6),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(izmir_error_img_icon),
          )))
      .box
      .padding(EdgeInsets.all(3))
      .make();
}


Widget hot_deals_asset_image_shape(){
  return Container(
    height: 180,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(izmir_error_img_icon),
        )),
  );
}

Widget message_network_image_shape(url,wdt){
  return Container(
      height: 300,
      width: wdt*0.6,
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: url,
          )));
}
Widget message_asset_image_shape(wdt){
  return Container(
      height: 300,
      width: wdt*0.6,
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(izmir_error_img_icon),
          )));
}