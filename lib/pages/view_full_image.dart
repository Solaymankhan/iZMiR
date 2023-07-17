import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/drawer_controller.dart';
import '../shapes/all_product_network_image_shape.dart';


class view_full_image extends StatelessWidget {
  view_full_image({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.maxFinite,
      width: double.maxFinite,
      child: InteractiveViewer(
        clipBehavior: Clip.none,
          child: CachedNetworkImage(
            imageUrl: Get.arguments,
            imageBuilder: (context, url)=>Image.network(Get.arguments),
            placeholder: (context, url)=>all_product_asset_swiper_image_shape(),
            errorWidget: (context, url, error) => all_product_asset_swiper_image_shape(),
          ),
      ),
    );
  }
}
