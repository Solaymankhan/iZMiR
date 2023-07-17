import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:izmir/pages/product_details_page.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/colors.dart';
import '../consts/images.dart';
import '../controllers/app_setting_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/dont_have_any_data.dart';
import '../shapes/related_products_class.dart';
import 'login_page.dart';
import 'message_page.dart';



class brands_shops_home_page extends StatelessWidget {
  brands_shops_home_page({Key? key,@required this.brand_id}) : super(key: key);
  final brand_id;
  var brand_shop_details;
  final app_setting_controller appSettingController = Get.find();
  var docreference = FirebaseFirestore.instance.collection("products");
  var brand_doc_reference=FirebaseFirestore.instance.collection("brands");
  var firebase_instance=FirebaseFirestore.instance;
  var related_products=new related_products_class();
  RxBool isLiked=false.obs;
  RxInt current_index = 0.obs;
  RxString brand_icon=''.obs,brand_verified=''.obs,brand_name=''.obs,liked_id=''.obs,
      brand_likes=''.obs,brand_location=''.obs,brand_adding_time=''.obs,brand_offer='0'.obs;
  RxList category_list = [].obs, brand_banner_img_list = [].obs;
  var date;

  @override
  Widget build(BuildContext context) {
    calculate_date_and_time();
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: Obx(()=>
       CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                title: Material(
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
                        child: Icon(CupertinoIcons.back,color: Colors.black,)),
                  ),
                ),
                backgroundColor: whiteColor,
                pinned: true,
                shadowColor: Colors.transparent,
                expandedHeight: 150,
                flexibleSpace: FlexibleSpaceBar(
                  background:  Container(
                    height: het * 0.35,
                    width: double.infinity,
                    child: Swiper(
                      physics: ScrollPhysics(),
                      autoplay: true,
                      itemBuilder: (BuildContext context, int index) {
                        return CachedNetworkImage(
                          imageUrl: brand_banner_img_list.length>0?brand_banner_img_list[index]:"",
                          imageBuilder: (context, url) =>
                              all_product_network_swiper_image_shape(
                                  url),
                          placeholder: (context, url) =>
                              all_product_asset_swiper_image_shape(),
                          errorWidget: (context, url, error) =>
                              all_product_asset_swiper_image_shape(),
                        );
                      },
                      itemCount: brand_banner_img_list.length>0?brand_banner_img_list.length:1,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  10.heightBox,
                    Row(
                      children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: brand_icon.value,
                            imageBuilder: (context, url)=>brand_network_image_shape(url),
                            placeholder: (context, url)=> brand_asset_image_shape(),
                            errorWidget: (context, url, error) =>  brand_asset_image_shape(),
                          ),
                        ),
                        Visibility(
                          visible: brand_verified.value=="verified"?true:false,
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
                      ],).marginOnly(right: 5),
                    Flexible (
                      child: Text(brand_name.value,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.w400),),
                    )
                    ],),
                  10.heightBox,
                  Visibility(
                    visible: brand_offer.value!='0'?true:false,
                    child: Text('${brand_offer.value}% Extra off',maxLines: 1,
                    overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: orangeColor,fontWeight: FontWeight.bold),)
                    .box.padding(EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2)).color(lightGreyColor).rounded.margin(EdgeInsets.only(bottom: 5)).make()
                    ,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        SvgPicture.asset(
                          likes_icon,
                          width: 20,
                          color: isLiked.value?yellowColor:Colors.grey,
                        ).marginOnly(right: 10).onTap(() {
                          if (drawerController.pref_userId.value.length > 0) {
                            isLiked.value=!isLiked.value;
                            like_dislike();
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => login_page()));
                          }
                        }),
                        Text(brand_likes.value,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        Text(" Likes",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                      ],),

                      Material(
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: () {
                            if(drawerController.pref_userId.value.length>0){
                              Get.to(()=>message_page(brand_id: brand_id,brand_name: brand_name.value
                                  ,brand_icon: brand_icon.value));
                            }else{
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => login_page()));
                            }
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: Ink(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: lightGreyColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(CupertinoIcons.bubble_left_bubble_right_fill,color: darkFontGreyColor,size: 20,)),
                        ),
                      )

                    ],
                  ),
                  10.heightBox,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(brand_location.value,maxLines: 1,
                            overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                        )),
                        Expanded(child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('Since, $date',maxLines: 1,
                            overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                        )),

                      ],
                    ),
                  10.heightBox,

                ],).box.margin(EdgeInsets.only(left: 15,right: 15)).make(),
              ),
              SliverPersistentHeader(
                  pinned: true,
                  delegate: Delegate(current_index,category_list,docreference,related_products,brand_name),
                ),
              SliverToBoxAdapter(
                child:StreamBuilder<QuerySnapshot>(
                  stream: category_list.length==0?docreference
                      .orderBy("product_adding_time", descending: true)
                      .where('brand_name',
                      isEqualTo: brand_name.value)
                      .snapshots():(category_list[current_index.value]=="All"?
                  docreference
                      .orderBy("product_adding_time", descending: true)
                      .where('brand_name',
                      isEqualTo: brand_name.value)
                      .snapshots():
                  docreference
                      .orderBy("product_adding_time", descending: true)
                      .where('brand_name',
                      isEqualTo: brand_name.value)
                      .where('category_name',
                      isEqualTo: category_list[current_index.value])
                      .snapshots()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return dont_have_any_data(het);
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                          height: het - 120,
                          child: CupertinoActivityIndicator(radius: 10)
                              .box
                              .alignCenter
                              .make());
                    }
                    if (snapshot.data!.docs.length == 0) {
                      return dont_have_any_data(het);
                    }
                    return GridView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: het > wdt ? 2 : 5,
                            mainAxisExtent: 290),
                        itemBuilder: (context, index) {


                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          List product_img_list = doc["product_img"].toString().trim().split("  ");

                          return Material(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) =>
                                            product_details_page(
                                                product_id: doc.id)));
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
                                      imageUrl: product_img_list[0],
                                      imageBuilder: (context, url)=> all_product_network_image_shape(url),
                                      placeholder: (context, url)=>all_product_asset_image_shape(),
                                      errorWidget: (context, url, error) => all_product_asset_image_shape(),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: doc["brand_icon"],
                                              imageBuilder: (context, url)=>brand_small_network_image_shape(url),
                                              placeholder: (context, url)=> brand_small_asset_image_shape(),
                                              errorWidget: (context, url, error) =>  brand_small_asset_image_shape(),
                                            ),
                                            Visibility(
                                              visible: doc["brand_verified"] ==
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
                                        ).marginOnly(right: 2),
                                        Expanded(
                                          child: Text(
                                            doc["brand_name"],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      doc["product_title"],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),
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
                                          Row(children: [Icon(CupertinoIcons.star_fill,size: 15,color: yellowColor,),
                                            Text(
                                              "${doc["product_rating"]}/5",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 12,color: darkFontGreyColor,fontWeight: FontWeight.w400),
                                            ).marginOnly(left: 5),],),
                                          Visibility(
                                            visible: doc["off_percent"] == "0"
                                                ? false
                                                : true,
                                            child: Text(
                                              "${doc["off_percent"]}% off",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: orangeColor,
                                                  fontWeight:
                                                  FontWeight.w500),
                                            ),)
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
                                                  "${doc["off_percent"] == "0" ? (double.parse(doc["liquid_ml_price_list"][0])
                                                      +double.parse(doc["initial_price"])) : ((double.parse(doc["liquid_ml_price_list"][0])
                                                      +double.parse(doc["initial_price"]))- ((double.parse(doc["off_percent"])
                                                      * (double.parse(doc["liquid_ml_price_list"][0])+
                                                          double.parse(doc["initial_price"]))) / 100)).toStringAsFixed(0)}",
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
                                            visible: doc["off_percent"] == '0' ? false : true,
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
                                                      text: doc["is_liquid_selected"]=="true"?doc["liquid_ml_price_list"][0]:doc["initial_price"],
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
                        });
                  },
                ).box.margin(EdgeInsets.only(left: 10, right: 10)).make(),)
            ],
          ).box.color(whiteColor).make()

      ),
    );
  }

  calculate_date_and_time()async{
    await brand_doc_reference.doc(brand_id).get()
        .then((value) async{
          brand_shop_details=value.data();
          brand_name.value=brand_shop_details["brand_name"];
          brand_icon.value=brand_shop_details["brand_icon"];
          brand_verified.value=brand_shop_details["brand_verified"];
          brand_adding_time.value=brand_shop_details["brand_adding_time"];
          brand_likes.value=brand_shop_details["brand_likes"].toString();
          brand_location.value=brand_shop_details["brand_full_location"];
          brand_offer.value=brand_shop_details["brand_offer"];
          DateTime dateTime = await DateTime.fromMillisecondsSinceEpoch
            ((int.parse(brand_shop_details["brand_adding_time"])/1000)
              .toInt()).toLocal();
          date = await DateFormat('dd-MM-yyyy').format(dateTime);
          brand_banner_img_list.value=brand_shop_details["brand_banner_img"].toString().trim().split("  ");
          category_list.clear();
          category_list.add("All");
          for(var val in brand_shop_details["brand_categories"])category_list.add(val);

    });
    try{
      brand_doc_reference
          .doc(brand_id)
          .collection("likes").where("user_id",isEqualTo: drawerController.pref_userId.value)
          .snapshots().listen((value){
        if(value.docs.length>0){
          isLiked.value=true;
          liked_id.value=value.docs.first.id;
        }
      });
    }catch(e){

    }
  }
  like_dislike()async{
    final batch = firebase_instance.batch();
    var likeRef =  await brand_doc_reference
        .doc(brand_id)
        .collection("likes");
    var user_pro_Ref =  await firebase_instance
        .collection(drawerController.pref_info["account_type"])
        .doc(drawerController.pref_userId.value);
    if(isLiked.value){
      batch.set(likeRef.doc(),{
        "user_id":drawerController.pref_userId.value,
        "time":new DateTime.now().microsecondsSinceEpoch.toString()
      });
      batch.update(user_pro_Ref, {"liked_brands":FieldValue.arrayUnion([brand_id])});
    }else{
      batch.delete(likeRef.doc(liked_id.value));
      batch.update(user_pro_Ref, {"liked_brands":FieldValue.arrayRemove([brand_id])});
    }
    var brandRef = await brand_doc_reference.doc(brand_id);
    batch.update(brandRef,{'brand_likes': isLiked.value?FieldValue.increment(1):FieldValue.increment(-1)});
    batch.commit();
  }
}

class Delegate extends SliverPersistentHeaderDelegate  {
  Delegate(this.current_index,this.category_list,this.docreference,this.related_products,this.brand_name);
  RxInt current_index = 0.obs;
  RxList category_list=[].obs;
  var docreference,related_products,brand_name=''.obs;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container (
                    child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: category_list.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  current_index.value = index;

                                  /*Future.delayed(Duration(milliseconds: 200), () async{
                                    final collectionRef=category_list[current_index.value]=="All"?
                                    docreference.where('brand_name', isEqualTo: brand_name.value)
                                        .orderBy("product_adding_time", descending: true)
                                        :
                                    docreference.where('brand_name',isEqualTo: brand_name.value)
                                        .where('category_name',isEqualTo: category_list[current_index.value])
                                        .orderBy("product_adding_time", descending: true);
                                    related_products.change_data(collectionRef);
                                  });*/

                                },
                                child: Row(
                                  children: [
                                    Text(
                                      category_list[index],
                                      style: TextStyle(
                                        color: current_index.value == index
                                            ? darkBlueColor
                                            : Colors.black,
                                        fontSize: current_index.value == index ? 16 : 14,
                                        fontWeight: current_index.value == index
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                      ),
                                    )
                                  ],
                                )
                                    .box
                                    .rounded
                                    .padding(EdgeInsets.only(
                                    left: 10, right: 10))
                                    .margin(EdgeInsets.only(
                                    left: index == 0 ? 10 : 5,
                                    right: index ==
                                        category_list.length - 1
                                        ? 10
                                        : 0))
                                    .color(current_index.value == index
                                    ? yellowColor
                                    : whiteColor)
                                    .make(),
                              );
                            }),

                  ).box.color(whiteColor).padding(EdgeInsets.only(top: 5,bottom: 5)).make();
  }

  @override
  double get maxExtent => 40;
  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}