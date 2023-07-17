import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/brands_controller.dart';
import '../pages/product_details_page.dart';
import '../shapes/all_product_network_image_shape.dart';



class related_products_class{
  var docreference = FirebaseFirestore.instance.collection("products");

  RxList list=[].obs;
  RxList product_id_list=[].obs;
  ScrollController scrollController = ScrollController();
  DocumentSnapshot? lastDocument;
  bool isMoreData=true;


  change_data(collectionRef){
    PaginatedData(collectionRef);
    scrollController.addListener(() {
      if(scrollController.position.pixels
          ==scrollController.position.maxScrollExtent){
        PaginatedData(collectionRef);
      }
    });
}

  void PaginatedData(collectionRef)async{
    if(isMoreData){
      try{
        late QuerySnapshot<Map<String,dynamic>> querySnapshot;
        if(lastDocument==null){
          querySnapshot=await collectionRef.limit(7).get();
        }else{
          querySnapshot=await collectionRef.limit(7).startAfterDocument(lastDocument!).get();
        }
        lastDocument=querySnapshot.docs.last;
        list.addAll(querySnapshot.docs.map((e) => e.data()));
        product_id_list.addAll(querySnapshot.docs.map((e) => e.id));
        if(querySnapshot.docs.length<7) isMoreData=false;
      }catch(e){
        print(e.toString());
      }

    }
  }


  Widget related_producs_shape(het,wdt) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: het > wdt ? 2 : 5,
            mainAxisExtent: 310),
        itemBuilder: (context, index) {
          return Material(
            child: InkWell(
              onTap: () {

                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) =>
                            product_details_page(
                                product_id: product_id_list[index])));

              },
              borderRadius: BorderRadius.circular(6),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: lightGreyColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: list[index]["product_first_img"].toString().trim(),
                      imageBuilder: (context, url)=> all_product_network_image_shape(url),
                      placeholder: (context, url)=>all_product_asset_image_shape(),
                      errorWidget: (context, url, error) => all_product_asset_image_shape(),
                    ),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: list[index]["brand_icon"],
                          imageBuilder: (context, url)=>brand_small_network_image_shape(url),
                          placeholder: (context, url)=> brand_small_asset_image_shape(),
                          errorWidget: (context, url, error) =>  brand_small_asset_image_shape(),
                        ),
                        Expanded(
                          child: Text(
                            list[index]["brand_name"]+para,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      list[index]["product_title"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                    )
                        .box
                        .padding(EdgeInsets.only(
                        top: 3,
                        bottom: 3,
                        left: 7,
                        right: 7))
                        .make(),
                    2.heightBox,
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(CupertinoIcons.star_fill,size: 15,color: yellowColor,),
                              Text(
                                "${list[index]["product_rating"]}/5",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12,color: darkFontGreyColor,fontWeight: FontWeight.w400),
                              ).marginOnly(left: 5),],),
                          Text(
                            list[index]["off_percent"] == "0"?"":"${list[index]["off_percent"]}% off",
                            style: TextStyle(
                                fontSize: 12,
                                color: orangeColor,
                                fontWeight:
                                FontWeight.w500),
                          )
                        ]
                    ).marginOnly(left: 5,right: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icon/taka_svg.svg',
                                width: 16,
                              ),
                              Expanded(
                                child: Text(
                                  list[index]["final_price"],
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Visibility(
                            visible: list[index]["off_percent"] == '0' ? false : true,
                            child:
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text.rich(
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  children: [
                                    WidgetSpan(child: SvgPicture.asset(
                                      'assets/icon/taka_svg.svg',
                                      width: 14,
                                      color: FontGreyColor,
                                    )),
                                    TextSpan(
                                      text: list[index]["initial_price"],
                                      style: TextStyle(
                                        fontSize: 14,
                                        decoration: TextDecoration
                                            .lineThrough,
                                        fontWeight:
                                        FontWeight.w400,
                                        color: FontGreyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                              .box
                              .padding(
                              EdgeInsets.only(right: 3))
                              .make(),
                        )
                      ],
                    ).box.padding(EdgeInsets.all(3)).make(),
                  ],
                ),
              ),
            ),
          ).box.padding(EdgeInsets.all(2)).make();
        }).box.margin(EdgeInsets.only(left: 13, right: 13)).make();
  }

}

