import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/brands_controller.dart';
import '../pages/add_product_sheet.dart';
import '../pages/product_details_page.dart';
import '../pages/product_edit_details_page.dart';
import '../shapes/all_product_network_image_shape.dart';


class brand_home_producs_controller extends GetxController{

  RxInt current_index = 0.obs;
  RxList category_list=["All"].obs;

  var docreference;
  final brands_controller brandController = Get.find();

  RxList list=[].obs;
  RxList product_id_list=[].obs;

  ScrollController scrollController = ScrollController();
  DocumentSnapshot? lastDocument;
  bool isMoreData=true;
  RxBool visibility_of_widget=false.obs;


  @override
  void onInit() {
    super.onInit();
    PaginatedData();
    scrollController.addListener(() {
      if(scrollController.position.pixels
          ==scrollController.position.maxScrollExtent){
        PaginatedData();
      }
    });
  }


  void reload_brand_product_data(){
    isMoreData=true;
    scrollController=ScrollController();
    list.clear();
    product_id_list.clear();
    lastDocument=null;
    PaginatedData();
  }


  void PaginatedData()async{
    if(isMoreData){
      try{
        final collectionRef=docreference;
        late QuerySnapshot<Map<String,dynamic>> querySnapshot;
        if(lastDocument==null){
          querySnapshot=await collectionRef.limit(7).get();
        }else{
          querySnapshot=await collectionRef.limit(7)
              .startAfterDocument(lastDocument!).get();
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


  Widget all_products_shape(het,wdt) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: het > wdt ? 2 : 5,
            mainAxisExtent: 235),
        itemBuilder: (context, index) {

          List product_img_list = list[index]["product_img"].toString().trim().split("  ");

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
                    Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: product_img_list[0],
                          imageBuilder: (context, url)=> all_product_network_image_shape(url),
                          placeholder: (context, url)=>all_product_asset_image_shape(),
                          errorWidget: (context, url, error) => all_product_asset_image_shape(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Visibility(
                              visible: list[index]["off_percent"] == "0"
                                  ? false
                                  : true,
                              child: Text(
                                "${(double.parse(list[index]["off_percent"])+double.parse(list[index]['brand_offer'])).toStringAsFixed(0)}% off",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: yellowColor,
                                    fontWeight:
                                    FontWeight.w500),
                              )
                                  .box
                                  .rounded
                                  .color(darkBlueColor)
                                  .padding(EdgeInsets.only(
                                  top: 1,
                                  right: 5,
                                  bottom: 1,
                                  left: 5))
                                  .make()),
                        ),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: list[index]["brand_icon"],
                                  imageBuilder: (context, url)=> brand_small_network_image_shape(url),
                                  placeholder: (context, url)=>brand_small_asset_image_shape(),
                                  errorWidget: (context, url, error) => brand_small_asset_image_shape(),
                                ),
                                Visibility(
                                  visible: list[index]['brand_verified'] ==
                                      "verified"
                                      ? true
                                      : false,
                                  child: Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                          color: yellowColor,
                                          borderRadius:
                                          BorderRadius
                                              .circular(50),
                                          border: Border.all(
                                              color: whiteColor,
                                              width: 1)),
                                      child: Icon(
                                        Icons.check,
                                        color: darkBlueColor,
                                        size: 10,
                                      )),
                                )
                              ],
                            ),
                            Text(
                              list[index]["brand_name"].length > 10
                                  ? list[index]["brand_name"]
                                  .substring(0, 10) +
                                  "..."
                                  : list[index]["brand_name"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: yellowColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )
                                .box
                                .color(darkBlueColor)
                                .rounded
                                .padding(EdgeInsets.only(
                                left: 3, right: 3))
                                .make()
                          ],
                        )
                      ],
                    ),
                    Text(
                      list[index]["product_title"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                    )
                        .box
                        .padding(EdgeInsets.only(
                        top: 3,
                        bottom: 3,
                        left: 7,
                        right: 7))
                        .make(),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
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
                                  "${list[index]["off_percent"] == "0" ? list[index]["initial_price"] :
                                  (double.parse(list[index]["initial_price"]) - (((double.parse(list[index]["off_percent"])+
                                      double.parse(list[index]['brand_offer']))* double.parse(list[index]["initial_price"])) / 100))
                                      .toStringAsFixed(0)}",
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
                            visible: double.parse(list[index]["off_percent"])+double.parse(list[index]['brand_offer']) == 0
                                ? false
                                : true,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icon/taka_svg.svg',
                                  width: 14,
                                  color: FontGreyColor,
                                ),
                                Expanded(
                                  child: Text(
                                    "${list[index]["initial_price"]}",
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration
                                          .lineThrough,
                                      fontWeight:
                                      FontWeight.w400,
                                      color: FontGreyColor,
                                    ),
                                  ),
                                ),
                              ],
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
        }).box.margin(EdgeInsets.only(left: 10, right: 10)).make();
  }




}

