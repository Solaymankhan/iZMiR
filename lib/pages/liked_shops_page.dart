import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller_2.dart';
import '../controllers/drawer_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/bar_with_back_button.dart';
import 'brand_shop_home_page.dart';



class liked_shops_page extends StatefulWidget {
  liked_shops_page({Key? key}) : super(key: key);
  @override
  State<liked_shops_page> createState() => _liked_shops_pageState();
}

class _liked_shops_pageState extends State<liked_shops_page> {

  final drawer_controller drawerController = Get.find();
  RxList brand_list=[].obs,id_list=[].obs;
  final int batchSize = 10;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () async{
      for (int i = 0; i < drawerController.liked_brands_list.length; i += batchSize){
        final List batchIds =
        drawerController.liked_brands_list.sublist(i, i + batchSize > drawerController.liked_brands_list.length ? drawerController.liked_brands_list.length : i + batchSize);
        FirebaseFirestore.instance
            .collection('brands')
            .where(FieldPath.documentId,whereIn: batchIds)
            .snapshots().listen((event) {
          brand_list.clear();
          id_list.clear();
          brand_list.addAll(event.docs.map((e) => e.data()));
          for(var val in event.docs)id_list.add(val.id);
        });
      }
    });

    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            bar_with_back_button(context,liked_brands_shops_txt),
            10.heightBox,
            Obx(()=> ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: brand_list.length,
                  itemBuilder: (context, index) {
                    return Material(
                      borderRadius: BorderRadius.circular(6),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () {
                            Get.to(() => brands_shops_home_page(brand_id:id_list[index]));
                          },
                          child: Ink(
                            padding: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: lightGreyColor),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: brand_list[index]["brand_icon"],
                                            imageBuilder: (context, url)=>brand_network_image_shape(url),
                                            placeholder: (context, url)=> brand_asset_image_shape(),
                                            errorWidget: (context, url, error) =>  brand_asset_image_shape(),
                                          ),
                                          Visibility(
                                            visible: brand_list[index]['brand_verified']=="verified"?true:false,
                                            child: Container(
                                                height: 13,
                                                width: 13,
                                                decoration: BoxDecoration(
                                                    color: yellowColor,
                                                    borderRadius:
                                                    BorderRadius.circular(50),
                                                    border: Border.all(
                                                        color: whiteColor,
                                                        width: 1)
                                                ),
                                                child:Icon(
                                                  Icons.check,
                                                  color: darkBlueColor,
                                                  size: 10,
                                                )
                                            ),
                                          )
                                        ],),
                                      Flexible(
                                        child: Text(
                                          brand_list[index]["brand_name"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,

                                          ),
                                        ).box.margin(EdgeInsets.only(left: 5)).make(),
                                      )
                                    ],),
                                  ),
                                  Text("${brand_list[index]['brand_likes']} Likes")
                                ]),
                          )
                      ),
                    ).box
                        .margin(EdgeInsets.only(left: 15,right: 15,top: 0.5,bottom: 0.5))
                        .make();
                  }),
            ),
          ],
        ).color(whiteColor),
      ),
    );
  }
}
