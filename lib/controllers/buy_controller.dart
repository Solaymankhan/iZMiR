import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/consts.dart';
import '../consts/lists.dart';
import '../pages/brand_shop_home_page.dart';
import '../pages/hexcolorMaker_controller.dart';
import '../pages/product_details_page.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/snack_bar.dart';
import 'app_setting_controller.dart';
import 'cart_controller.dart';
import 'drawer_controller.dart';
import 'loading_dialogue_controller.dart';

class buy_controller extends GetxController{

  late BuildContext new_context;
  var firebase_instance = FirebaseFirestore.instance;
  var products_docference = FirebaseFirestore.instance.collection("products");
  var users_docference = FirebaseFirestore.instance.collection("users");
  var orders_docference = FirebaseFirestore.instance.collection("orders");
  var order_info_docference = FirebaseFirestore.instance.collection("order_info");

  final drawer_controller drawerController = Get.find();
  final app_setting_controller settingController = Get.find();
  final cart_controller cartController = Get.find();
  final loading_dialogue_controller loadingController = Get.find();
  RxMap<String, List<Map<String, String>?>> cart_info=RxMap();
  RxMap<String, List<Map<String, dynamic>?>> cart_products = RxMap();
  RxMap<String, List<int>?> removable_cart_info_map=RxMap();
  RxMap<String, List<String>> product_id_map=RxMap();
  RxMap<String, List<String>?> product_available_quantity_map=RxMap();
  RxMap<String, List<String>?> product_price_map=RxMap();
  RxMap<String, String> weight_list=RxMap();
  List dstrct_lst=[];
  RxBool is_account_balance_selected = false.obs;
  int iter=0;
  List<String> cart_amnt=[];
  RxString address = "".obs, refer_code = "".obs,total_price='0'.obs,product_total_price='0'.obs
  ,account_balance='0'.obs,delivery_fee='0'.obs,off_on_refer_buyer='0'.obs,off_on_refer_seller='0'.obs
  ,district=''.obs,division=''.obs,delivery_charge='0'.obs;

  RxBool is_all_selected = false.obs;

  Future<void> get_product_data() async {
    address.value = ""; refer_code.value = "";total_price.value='0';product_total_price.value='0';
    account_balance.value='0';delivery_fee.value='0';off_on_refer_buyer.value='0';
    off_on_refer_seller.value='0';district.value='';division.value='';delivery_charge.value='0';
    is_account_balance_selected.value = false;
    is_all_selected.value=false;
    cart_products.clear();
    product_id_map.clear();
    removable_cart_info_map.clear();
    product_available_quantity_map.clear();
    product_price_map.clear();
    cart_amnt.clear();
    address.value = await drawerController.pref_info["address"];
    division.value=await drawerController.pref_info["division"];
    district.value=await drawerController.pref_info["district"];
    change_district((division_list.indexOf(division.value) + 1).toString());

    RxMap<String, List<Map<String, dynamic>?>> temporary = RxMap();

    await Future.forEach(cartController.product_selected_map.entries, (entry) async {
      String key = entry.key;
      List<Map<String,dynamic>?> data_list=[];
      List<Map<String,String>?> cart_info_list=[];
      List<String> product_id_list=[];
      List<String> vogas_list=[];
      List<String> vogas_list2=[];
      int indxs=0;
      await Future.forEach(entry.value, (element) async{
        if(element==true && cartController.product_available_quantity_map[entry.key]![indxs]!="Not Available"){
          await products_docference.doc(drawerController.cart[entry.key]![indxs]["product_database_id"]).get().then((doc) {
            if(doc.exists){
              cart_info_list.add(drawerController.cart[entry.key]![indxs]);
              data_list.add(doc.data());
              product_id_list.add(doc.id);
              vogas_list.add("1");
              vogas_list2.add("1");
            }else{
              removable_cart_info_map.putIfAbsent(entry.key, () => []);
              removable_cart_info_map[entry.key]!.add(indxs);
            }
          });
        }
        indxs++;
      }).then((value) {
        if(data_list.isNotEmpty){
          temporary[key]=data_list;
          cart_info[key]=cart_info_list;
          product_id_map[key]=product_id_list;
          product_available_quantity_map[key]=vogas_list;
          product_price_map[key]=vogas_list2;
        }
      });
    })
        .then((value) => cart_products.value = temporary);
    if(!removable_cart_info_map.isEmpty){
      await Future.forEach(removable_cart_info_map.entries, (entry) async {
        for(var val in entry.value!) await drawerController.cart[entry.key]!.removeAt(val);
      });
      drawerController.update_cart();
    }
    product_price_calculation();
    product_weight_calculation();
    delivery_charge_calculate();
    total_price_calculator();
  }

  Widget buy_shape(het,wdt) {
    if (cart_products.isEmpty) {
      return Container(
          height: het/2+100 ,
          child: CupertinoActivityIndicator(radius: 10)
              .box
              .alignCenter
              .make());
    } else {
      return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return false;
        },
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cart_products.length,
            itemBuilder: (context, index) {
              return  Obx(
                    ()=> Column(children: [
                  Material(
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () {
                        Get.to(()=>brands_shops_home_page(brand_id: cart_products[cart_products.keys.elementAt(index)]![0]!["brand_id"]));
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: lightGreyColor
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(children: [
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:cart_products[cart_products.keys.elementAt(index)]![0]!["brand_icon"],
                                      imageBuilder: (context, url)=> brand_ink_network_image_shape(url),
                                      placeholder: (context, url)=>brand_ink_asset_image_shape(),
                                      errorWidget: (context, url, error) => brand_ink_asset_image_shape(),
                                    ),
                                    Visibility(
                                      visible: cart_products[cart_products.keys.elementAt(index)]![0]!["brand_verified"] ==
                                          "verified"
                                          ? true
                                          : false,
                                      child: Container(
                                          height: 13,
                                          width: 13,
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
                                Expanded(
                                  child: Text(cart_products.keys.elementAt(index),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 18,
                                        color: darkFontGreyColor,
                                        fontWeight: FontWeight.w400),).marginOnly(left: 5),
                                )
                              ],),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child:
                                Text.rich(
                                  overflow: TextOverflow.ellipsis,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:"Delivery ",
                                        style: TextStyle(fontSize: 14,color: darkFontGreyColor,fontWeight: FontWeight.w500),),
                                      WidgetSpan(child: SvgPicture.asset(
                                        'assets/icon/taka_svg.svg',
                                        width: 14,
                                        color: darkFontGreyColor,
                                      )),
                                      TextSpan(
                                        text:"${int.parse(weight_list[cart_products.keys.elementAt(index)]!)*int.parse(delivery_charge.value)}",
                                        style: TextStyle(fontSize: 14,color: darkFontGreyColor,fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                ),
                                ),
                            ),
                          ],
                        ).paddingOnly(top: 5,bottom: 5,left: 5,right: 10),
                      ),
                    ),
                  ),

                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cart_products[cart_products.keys.elementAt(index)]!.length,
                      itemBuilder: (context, index2) {
                        return Material(
                          borderRadius: BorderRadius.circular(6),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          product_details_page(
                                              product_id: product_id_map[product_id_map.keys.elementAt(index)]![index2])));
                            },
                            child: Ink(
                              padding: EdgeInsets.only(top: 5,bottom: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: lightGreyColor
                              ),
                              child:Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(children: [
                                      CachedNetworkImage(
                                        imageUrl:cart_products[cart_products.keys.elementAt(index)]![index2]!["product_first_img"],
                                        imageBuilder: (context, url)=> cart_network_image_shape(url),
                                        placeholder: (context, url)=>cart_asset_image_shape(),
                                        errorWidget: (context, url, error) => cart_asset_image_shape(),
                                      ).marginOnly(left: 5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              cart_products[cart_products.keys.elementAt(index)]![index2]!["product_title"],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: darkFontGreyColor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            7.heightBox,
                                            Visibility(
                                              visible: cart_info[cart_products.keys.elementAt(index)]![index2]!
                                              ["selected_size"]==""?false:true,
                                              child: Text(
                                                "Size : ${cart_info[cart_products.keys.elementAt(index)]![index2]!
                                                ["selected_size"]}",
                                                style: TextStyle(
                                                    color: darkFontGreyColor,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            2.heightBox,
                                            Visibility(
                                              visible: cart_info[cart_products.keys.elementAt(index)]![index2]!
                                              ["selected_size_color"]==""?false:true,
                                              child: Row(children: [
                                                Text("Color : "),
                                                Container(
                                                  margin: EdgeInsets.only(left:5,right: 5),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                    color: hexColor(cart_info[cart_products.keys.elementAt(index)]![index2]!
                                                    ["selected_size_color"].toString()),
                                                    border: Border.all(
                                                      color: textFieldGreyColor,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  height: 15,
                                                  width: 30,
                                                )
                                              ],),
                                            ),
                                            2.heightBox,
                                            Visibility(
                                              visible: cart_info[cart_products.keys.elementAt(index)]![index2]!
                                              ["selected_color"]==""?false:true,
                                              child: Row(children: [
                                                Text("Color : "),
                                                Container(
                                                  margin: EdgeInsets.only(left:5,right: 5),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                    color: hexColor(cart_info[cart_products.keys.elementAt(index)]![index2]!
                                                    ["selected_color"].toString()),
                                                    border: Border.all(
                                                      color: textFieldGreyColor,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  height: 15,
                                                  width: 30,
                                                ),
                                              ],),
                                            ),
                                            2.heightBox,
                                            Visibility(
                                              visible:cart_info[cart_products.keys.elementAt(index)]![index2]!
                                              ["selected_variation"]==""?false:true,
                                              child: Text(
                                                "Variation : ${cart_info[cart_products.keys.elementAt(index)]![index2]!
                                                ["selected_variation"]}",
                                                style: TextStyle(
                                                    color: darkFontGreyColor,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            2.heightBox,
                                            Text.rich(
                                              overflow: TextOverflow.ellipsis,
                                              TextSpan(
                                                children: [
                                                  WidgetSpan(child: SvgPicture.asset(
                                                    'assets/icon/taka_svg.svg',
                                                    width: 16,
                                                    color: darkFontGreyColor,
                                                  )),
                                                  TextSpan(
                                                    text: item_price_storage(cart_info,cart_products,cart_products.keys.elementAt(index),index2),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: darkFontGreyColor,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text:cart_products[cart_products.keys.elementAt(index)]![index2]!["off_percent"]=='0'?'':
                                                    "   ${cart_products[cart_products.keys.elementAt(index)]![index2]!["off_percent"]}% off",

                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: orangeColor,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ).marginOnly(right:50),
                                      )
                                    ],),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      item_storage(cart_info,cart_products,cart_products.keys.elementAt(index),index2),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: darkFontGreyColor,
                                          fontWeight: FontWeight.w500),
                                    ).box.margin(EdgeInsets.only(left: 5,right: 5,top: 87)).make(),
                                  )
                                ],
                              ),

                            ),
                          ),
                        )
                            .box.margin(EdgeInsets.only(top: 2,
                            bottom: cart_products[cart_products.keys.elementAt(index)]!.length-1==index2?0:5)).make();
                      })
                ],).box.customRounded(BorderRadius.all(Radius.circular(6)))
                    .margin(EdgeInsets.only(bottom: 20)).make(),
              );}
        ),
      );
    }
  }

  item_price_storage(cart,products,key,index2){
    String price=item_price(cart[key]![index2],products[key]![index2]);
    product_price_map[key]![index2]=price;
    return price;
  }

  item_price(cart_item,product_info){
    if(cart_item["selected_variation"]!=''){
      List l=product_info["liquid_ml_list"];
      for(int i=0;i<l.length;i++){
        if(l[i]==cart_item["selected_variation"]){
          if(int.parse(product_info["liquid_quantity_list"][i])>=int.parse(cart_item["product_quantity"])){
            return "${((int.parse(product_info["liquid_ml_price_list"][i])-
                (((int.parse(product_info["brand_offer"])+int.parse(product_info["off_percent"]))
                    *int.parse(product_info["liquid_ml_price_list"][i]))/100
                ))* int.parse(cart_item["product_quantity"])).toStringAsFixed(0)}";
          }else if(int.parse(product_info["liquid_quantity_list"][i])<int.parse(cart_item["product_quantity"])){
            return "${((int.parse(product_info["liquid_ml_price_list"][i])-
                (((int.parse(product_info["brand_offer"])+int.parse(product_info["off_percent"]))
                    *int.parse(product_info["liquid_ml_price_list"][i]))/100
                ))* int.parse(product_info["liquid_quantity_list"][i])).toStringAsFixed(0)}";
          }
        }
      }
      return "0";
    }else{
      return "${((int.parse(product_info["final_price"])-
          ((int.parse(product_info["brand_offer"])*int.parse(product_info["final_price"]))/100)
      )* int.parse(cart_item["product_quantity"])).toStringAsFixed(0)}";
    }
  }

  item_storage(cart,products,key,index2){
    String quantity=available_item(cart[key]![index2],products[key]![index2]);
    final splitted = quantity.split(' ');
    product_available_quantity_map[key]![index2]=(splitted.last=='Available'?'0':splitted.last);
    return quantity;
  }

  available_item(cart_item,product_info){
    if(cart_item["selected_size"]!='' || cart_item["selected_color"]!='' || cart_item["selected_variation"]!=''){
      List selected_list=[],quantity_list=[];
      String selected_size_color='';
      if(cart_item["selected_size"]!=''){
        selected_list=product_info["color_selected_list${cart_item["selected_size"]}"];
        selected_size_color=cart_item["selected_size_color"];
        quantity_list=product_info["size_color_quantity_list${cart_item["selected_size"]}"];
      }
      else if(cart_item["selected_color"]!=''){
        selected_list=product_info["color_selected_list"];
        selected_size_color=cart_item["selected_color"];
        quantity_list=product_info["color_quantity_list"];
      }
      else if(cart_item["selected_variation"]!=''){
        selected_list=product_info["liquid_ml_list"];
        selected_size_color=cart_item["selected_variation"];
        quantity_list=product_info["liquid_quantity_list"];
      }
      for(int i=0;i<selected_list.length;i++){
        if(selected_list[i]==selected_size_color){
          if(quantity_list[i]=='0'){
            return "Not Available";
          }
          else if(int.parse(quantity_list[i])>=int.parse(cart_item["product_quantity"])){
            return "Quantity : ${cart_item["product_quantity"]}";
          }else if(int.parse(quantity_list[i])<int.parse(cart_item["product_quantity"])){
            return "Available : ${quantity_list[i]}";
          }
        }
      }
    }
    else{
      if(product_info["quantity"]=='0'){
        return "Not Available";
      }
      else if(int.parse(product_info["quantity"])>=int.parse(cart_item["product_quantity"])){
        return "Quantity : ${cart_item["product_quantity"]}";
      }else if(int.parse(product_info["quantity"])<int.parse(cart_item["product_quantity"])){
        return "Available : ${product_info["quantity"]}";
      }
    }
  }

  product_price_calculation(){
    product_total_price.value='0';
    cart_products.forEach((key, value) {
      for(int i=0;i<value.length;i++){
        int cart_quantity=int.parse(cart_info[key]![i]!["product_quantity"]!);
          if(cart_info[key]![i]!["selected_variation"]!=''){
            List l= cart_products[key]![i]!["liquid_ml_list"];
            for(int j=0;j<l.length;j++){
              if(l[j]==cart_info[key]![i]!["selected_variation"]){
                if(int.parse(cart_products[key]![i]!["liquid_quantity_list"][j])>=cart_quantity){
                  product_total_price.value= "${(int.parse(product_total_price.value)+((int.parse(cart_products[key]![i]!["liquid_ml_price_list"][j])-
                      (((int.parse(cart_products[key]![i]!["brand_offer"])+int.parse(cart_products[key]![i]!["off_percent"]))
                          *int.parse(cart_products[key]![i]!["liquid_ml_price_list"][j]))/100
                      ))* cart_quantity)).toStringAsFixed(0)}";
                }
                else if(int.parse(cart_products[key]![i]!["liquid_quantity_list"][j])<cart_quantity){
                  product_total_price.value= "${(int.parse(product_total_price.value)+((int.parse(cart_products[key]![i]!["liquid_ml_price_list"][j])-
                      (((int.parse(cart_products[key]![i]!["brand_offer"])+int.parse(cart_products[key]![i]!["off_percent"]))
                          *int.parse(cart_products[key]![i]!["liquid_ml_price_list"][j]))/100
                      ))* int.parse(cart_products[key]![i]!["liquid_quantity_list"][j]))).toStringAsFixed(0)}";
                }
                else if(int.parse(cart_products[key]![i]!["liquid_quantity_list"][j])==0){
                  product_total_price.value= "${(int.parse(product_total_price.value)+0)}";
                }
              }
            }
          }else{
            product_total_price.value="${(int.parse(product_total_price.value)+
                ((int.parse(cart_products[key]![i]!["final_price"])-
                    ((int.parse(cart_products[key]![i]!["brand_offer"])*int.parse(cart_products[key]![i]!["final_price"]))/100
                    ))*cart_quantity)).toStringAsFixed(0)}";
          }
      }
    });

  }

  product_weight_calculation(){
    weight_list.clear();
    String weight='0';
    cart_products.forEach((key, value) {
      for(int i=0;i<value.length;i++){
        int cart_quantity=int.parse(cart_info[key]![i]!["product_quantity"]!);
        if(cart_info[key]![i]!["selected_variation"]!=''){
          List l= cart_products[key]![i]!["liquid_ml_list"];
          for(int j=0;j<l.length;j++){
            if(l[j]==cart_info[key]![i]!["selected_variation"]){
              if(int.parse(cart_products[key]![i]!["liquid_quantity_list"][j])>=cart_quantity){
                weight= "${(int.parse(weight)+
                    (int.parse(cart_products[key]![i]!["liquid_weight_list"][j])*
                        cart_quantity)).toStringAsFixed(0)}";
              }
              else if(int.parse(cart_products[key]![i]!["liquid_quantity_list"][j])<cart_quantity){
                weight= "${(int.parse(weight)+
                    (int.parse(cart_products[key]![i]!["liquid_weight_list"][j])*
                        cart_products[key]![i]!["liquid_quantity_list"][j])).toStringAsFixed(0)}";
              }
            }
          }
        }else{
          weight= "${(int.parse(weight)+
              (int.parse(cart_products[key]![i]!["weight_per_kg"])*cart_quantity)).toStringAsFixed(0)}";
        }
      }
      weight_list[key]="${(int.parse(weight)/1000).ceil().toStringAsFixed(0)}";
    });
  }

  delivery_charge_calculate(){
    delivery_charge.value= district.value=="Dhaka"? settingController.setting_list["delivery_charge_indhaka"]
        :settingController.setting_list["delivery_charge_outdhaka"];
  }

  total_price_calculator(){
    delivery_fee.value='0';
    account_balance.value=is_account_balance_selected.value?drawerController.account_balance_txt.value:'0';
    account_balance.value="${int.parse(product_total_price.value)>int.parse(account_balance.value)?
    int.parse(account_balance.value).toStringAsFixed(0):int.parse(product_total_price.value)}";

    off_on_refer_buyer.value="${refer_code.value.length>0?((int.parse(product_total_price.value)
        *int.parse(settingController.setting_list["off_customer"]))/100).toStringAsFixed(0):"0"}";

    off_on_refer_seller.value="${refer_code.value.length>0?((int.parse(product_total_price.value)
        *int.parse(settingController.setting_list["off_seller"]))/100).toStringAsFixed(0):"0"}";

    if(refer_code.value.length>0){
      account_balance.value="${(int.parse(product_total_price.value)-int.parse(off_on_refer_buyer.value))
          >int.parse(account_balance.value)?int.parse(account_balance.value).toStringAsFixed(0)
          :(int.parse(product_total_price.value)-int.parse(off_on_refer_buyer.value)).toStringAsFixed(0)}";
    }

    weight_list.forEach((key, value) {
      delivery_fee.value="${(int.parse(delivery_fee.value)+
          (int.parse(value)*int.parse(delivery_charge.value))).toStringAsFixed(0)}";
    });


    total_price.value="${
        (int.parse(product_total_price.value)
            +int.parse(delivery_fee.value)-int.parse(account_balance.value)-int.parse(off_on_refer_buyer.value)
        ).toStringAsFixed(0)
    }";
  }

  Future address_edit_sheet(context) =>
      showSlidingBottomSheet(context,
          builder: (context) => SlidingSheetDialog(
              duration: const Duration(milliseconds: 150),
              snapSpec: SnapSpec(initialSnap: 0.9, snappings: [0.9]),
              cornerRadius: 15,
              scrollSpec: ScrollSpec(physics: BouncingScrollPhysics()),
              builder: buildSheet));

  Widget buildSheet(context, state) => Material(
    child: Obx(
      ()=> Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "Address",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          10.heightBox,
          Column(
            children: [
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Division",
                  contentPadding: EdgeInsets.only(left: 15, right: 5),
                  border: OutlineInputBorder(),
                ),
                value: division.value,
                items: division_list
                    .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
                    .toList(),
                onChanged: (val) {
                  division.value = val.toString();
                  change_district(
                      (division_list.indexOf(division.value) + 1)
                          .toString());
                  delivery_charge_calculate();
                  total_price_calculator();
                },
              ),
              10.heightBox,
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "District",
                  contentPadding: EdgeInsets.only(left: 15, right: 5),
                  border: OutlineInputBorder(),
                ),
                value: district.value,
                items: dstrct_lst
                    .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
                    .toList(),
                onChanged: (val) {
                  district.value = val.toString();
                  delivery_charge_calculate();
                  total_price_calculator();
                },
                validator: (value) {
                  if (value.toString().length == 0)
                    return "District can't be empty";
                },
              ),
              10.heightBox,
              TextFormField(
                initialValue: address.value,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  labelText: "Full address (Comma separated)",
                  prefixIcon: Icon(CupertinoIcons.placemark),
                ),
                maxLength: 40,
                onChanged: (val){
                  address.value=val.toString();
                },
                validator: (value) {
                  if (value!.length == 0) {
                    return "Address can't be empty";
                  }
                  return null;
                },
              ),
            ],
          ),
          30.heightBox
        ],
      ).box.padding(EdgeInsets.all(10)).make(),
    ),
  );
  change_district(indx) {
    dstrct_lst.clear();
    district_list.forEach((key, value) {
      if (indx == value) {
        dstrct_lst.add(key);
      }
    });
    district.value = dstrct_lst[0];
  }

  call_payment_gateway_sheet(context){
    new_context=context;
    chose_payment_gateway_sheet(new_context);
  }

  Future chose_payment_gateway_sheet(context) =>
      showSlidingBottomSheet(context,
          builder: (context) => SlidingSheetDialog(
              duration: const Duration(milliseconds: 150),
              color: lightGreyColor,
              snapSpec: SnapSpec(initialSnap: 0.9, snappings: [0.9]),
              cornerRadius: 15,
              scrollSpec: ScrollSpec(physics: BouncingScrollPhysics()),
              builder: buildSheet2));

  Widget buildSheet2(context, state) => Material(
    child:Column(
        children: [
          add_buttons(money_icon,cash_on_del_txt,0,new_context),
          add_buttons(payment_icon,digital_payment_txt,1,new_context),
        ],
      ).box.color(lightGreyColor).make(),
  );

  Widget add_buttons(icon,title,page,context){
    return Material(
      child: InkWell(
        onTap: () async{
          Navigator.of(context).pop();
          loadingController.show_dialogue(context);
          if(page==0){
           await check_order_validation(context,"false");
          }
          else if(page==1){
            await check_order_validation(context,"true");
          }
          loadingController.close_dialogue(context);
        },
        child: Ink(
          height: 50,
          padding: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: lightGreyColor),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: BlackColor),
              )
            ],
          ),
        ),
      ),
    );
  }

   Future<void> check_order_validation(context,payment_complete)async{
    if(refer_code.value!=drawerController.pref_info["referral_code"]){
      int refer_code_user=0;
      if(refer_code.value!=''){
        await users_docference.where("referral_code",isEqualTo: refer_code.value).get().then((event) {
          refer_code_user=event.docs.length;
        });
      }
      if((refer_code.value!='' && refer_code_user!=0) ||
          (refer_code.value=='' && refer_code_user==0)
      ){
        bool is_ok=true;
        await Future.forEach(cart_products.entries,(entries) async{
          for(int i=0;i<entries.value.length;i++){
            if((int.parse(cart_info[entries.key]![i]!["product_quantity"]!)<=int.parse(entries.value[i]!["product_buying_limit"]))
                || entries.value[i]!["product_buying_limit"]=='0'
            ){
              await orders_docference.where("customer_database_id",isEqualTo: drawerController.pref_userId.value)
                  .where("product_database_id",isEqualTo: product_id_map[entries.key]![i]).get().then((doc){
                if(doc.size>0){
                  int total_bought=0;
                  for(var val in doc.docs)total_bought=total_bought+int.parse(val.get("product_quantity"));
                  total_bought=int.parse(product_available_quantity_map[entries.key]![i])+total_bought;
                  if(total_bought > int.parse(entries.value[i]!["product_buying_limit"])
                      && entries.value[i]!["product_buying_limit"]!='0'){
                    is_ok=false;
                    show_snackbar(context,"You exceeded the limit of '${entries.value[i]!["product_title"]}' this product",whiteColor,Colors.red);
                  }
                }
              });
            }
            else{
              is_ok=false;
              show_snackbar(context,"${cants_buy_more_txt}"
                  "${entries.value[i]!["product_buying_limit"]} items of '"
                  "${entries.value[i]!["product_title"]}' this product",whiteColor,Colors.red);
            }
          }
        });
        if(is_ok){
          if(payment_complete=="false"){
            await place_order("false");
            await cartController.delete_bought_items_from_cart();
            Get.back();
            show_snackbar(context, "Order has placed Successfully",yellowColor,darkBlueColor);
          }else if(payment_complete=="true"){
            sslCommerzGeneralCall(context);
          }
        }
      }
      else{
        show_snackbar(context,refercode_doesnt_exist_txt,whiteColor,Colors.red);
      }
    }else{
      show_snackbar(context,cant_use_own_ref_code_txt,whiteColor,Colors.red);
    }
  }

  Future<void> sslCommerzGeneralCall(context) async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        store_id: "izmir6441f10e41f49",
        store_passwd: "izmir6441f10e41f49@ssl",
        ipn_url: "www.ipnurl.com",
        currency: SSLCurrencyType.BDT,
        product_category: "Fashion",
        sdkType: SSLCSdkType.TESTBOX,
        total_amount: double.parse(total_price.value),
        tran_id: drawerController.pref_userId.value,
      ),
    );
    sslcommerz.addCustomerInfoInitializer(
      customerInfoInitializer: SSLCCustomerInfoInitializer(
        customerState: drawerController.pref_info['division'],
        customerName: drawerController.pref_info['name'],
        customerEmail: drawerController.pref_info['email'],
        customerAddress1: drawerController.pref_info['address'],
        customerCity: drawerController.pref_info['district'],
        customerPostCode: "",
        customerCountry: "Bangladesh",
        customerPhone: drawerController.pref_info['phone'],
      ),
    );
    try {
      SSLCTransactionInfoModel result = await sslcommerz.payNow();
      if (result.status!.toLowerCase() == "failed") {
        show_snackbar(context,"Transaction is Failed",whiteColor,Colors.red);
      } else if (result.status!.toLowerCase() == "closed") {
        show_snackbar(context,"Transaction Closed",whiteColor,Colors.red);
      } else {
        loadingController.show_dialogue(context);
        await place_order("true");
        await cartController.delete_bought_items_from_cart();
        loadingController.close_dialogue(context);
        Get.back();
        show_snackbar(context, "Transaction is ${result.status} and Amount is ${result.amount}",yellowColor,darkBlueColor);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  Future<void> place_order(payment_complete) async {
    final batch = firebase_instance.batch();
    var order_time= new DateTime.now().microsecondsSinceEpoch.toString();
    if(account_balance.value!='0'){
      drawerController.account_balance_txt.value=(int.parse(drawerController.account_balance_txt.value)-
          int.parse(account_balance.value)).toStringAsFixed(0);
    }
    if(payment_complete=="true"){
      drawerController.account_balance_txt.value=(int.parse(drawerController.account_balance_txt.value)
          +((int.parse(product_total_price.value)
              *int.parse(settingController.setting_list["app_offer"]))/100)).toStringAsFixed(0);
    }
    drawerController.buying_ammount_txt.value=(int.parse(drawerController.buying_ammount_txt.value)
        +  int.parse(total_price.value)).toStringAsFixed(0);


    Map<String, String> order_info = new Map();
    order_info = {
      "customer_database_id": drawerController.pref_userId.value,
      "customer_division": drawerController.pref_info['division'],
      "customer_district": drawerController.pref_info['district'],
      "customer_full_address": drawerController.pref_info['address'],
      "customer_name": drawerController.pref_info['name'],
      "customer_phone": drawerController.pref_info['phone'],
      "customer_email": drawerController.pref_info['email'],

      "total_product_price": product_total_price.value,
      "account_balance_used": account_balance.value,
      "off_on_refer": off_on_refer_buyer.value,
      "referral_code": refer_code.value,
      "delivery_fee": delivery_fee.value,
      "total_payment":total_price.value,
      "total_order_time": order_time,
      "payment_method":payment_complete=="true"?"sslCommerz":"Cash on delivery",
      "paid":payment_complete
    };

    var user_doc_Ref = await firebase_instance.collection(drawerController.pref_info["account_type"])
        .doc(drawerController.pref_userId.value);
    batch.update(user_doc_Ref,{
          "balance": drawerController.account_balance_txt.value,
          "buying_ammount": drawerController.buying_ammount_txt.value
        });
    if(refer_code.value.length>0){
      await firebase_instance.collection("users")
          .where("referral_code",isEqualTo: refer_code.value).get().then((value){
        batch.update(firebase_instance.collection("users").doc(value.docs.first.id),
            {
              "balance": (int.parse(value.docs.first.get("balance"))+
                  int.parse(off_on_refer_seller.value)).toStringAsFixed(0)
            });
      });

      drawerController.account_balance_txt.value=(int.parse(drawerController.account_balance_txt.value)
          +((int.parse(product_total_price.value)
              *int.parse(settingController.setting_list["off_customer"]))/100)).toStringAsFixed(0);
    }
    var ordringodocRef = order_info_docference.doc();
    batch.set(ordringodocRef,order_info);

    await Future.forEach(cart_products.entries, (entries) async{
      for(int i=0;i<entries.value.length;i++){
        Map<String,String> order_data=new Map();
        order_data={
          "order_id":ordringodocRef.id,
          "product_database_id":product_id_map[entries.key]![i],
          "product_given_id":entries.value[i]!["product_given_id"],
          "product_image":entries.value[i]!["product_first_img"],
          "product_title":entries.value[i]!["product_title"],
          "product_price":product_price_map[entries.key]![i],
          "product_color":cart_info[entries.key]![i]!["selected_color"]==''?
          cart_info[entries.key]![i]!["selected_size_color"]!:
          cart_info[entries.key]![i]!["selected_color"]!,
          "product_size":cart_info[entries.key]![i]!["selected_size"]!,
          "product_variation":cart_info[entries.key]![i]!["selected_variation"]!,
          "product_quantity":product_available_quantity_map[entries.key]![i],

          "shop_database_id":entries.value[i]!["brand_id"],
          "shop_name":entries.value[i]!["brand_name"],
          "shop_icon":entries.value[i]!["brand_icon"],
          "shop_division":entries.value[i]!["brand_division"].toString(),
          "shop_district":entries.value[i]!["brand_district"].toString(),
          "shop_full_address":entries.value[i]!["brand_full_address"].toString(),

          "customer_database_id":drawerController.pref_userId.value,
          "customer_division":drawerController.pref_info['division'],
          "customer_district":drawerController.pref_info['district'],
          "customer_full_address":drawerController.pref_info['address'],
          "customer_name":drawerController.pref_info['name'],
          "customer_phone":drawerController.pref_info['phone'],
          "customer_email":drawerController.pref_info['email'],

          "return_apply_time":"",
          "returned_time":"",
          "referral_code": refer_code.value,
          "order_activity":"In shop",
          "order_time":order_time,
          "out_from_store_time":"",
          "on_the_way_to_deliver_time":"",
          "delivered_time":"",
          "payment_method":payment_complete=="true"?"sslCommerz":"Cash on delivery",
          "paid":payment_complete
        };
        var ordrsRef = await orders_docference.doc();
        batch.set(ordrsRef,order_data);

        final prdctDocRef = await products_docference.doc(product_id_map[entries.key]![i]);
        if(cart_info[entries.key]![i]!["selected_size"]!=''){
          final snapshot = await prdctDocRef.get();
          List l=snapshot.get("color_selected_list${cart_info[entries.key]![i]!["selected_size"]!}");
          List l2=snapshot.get("size_color_quantity_list${cart_info[entries.key]![i]!["selected_size"]!}");
          for(int j=0;j<=l.length;j++){
            if(l[j]==cart_info[entries.key]![i]!["selected_size_color"]){
              l2[j]=(int.parse(l2[j])-int.parse(product_available_quantity_map[entries.key]![i])).toString();
              break;
            }
          }
          String total_quantity=(int.parse(snapshot.get("quantity"))
              -int.parse(product_available_quantity_map[entries.key]![i])).toString();
          batch.update(prdctDocRef, {"size_color_quantity_list${cart_info[entries.key]![i]!["selected_size"]!}"
              : l2,"quantity":total_quantity});
        }
        else if(cart_info[entries.key]![i]!["selected_color"]!=''){
            final snapshot = await prdctDocRef.get();
            List l=snapshot.get("color_selected_list");
            List l2=snapshot.get("color_quantity_list");
            for(int j=0;j<=l.length;j++){
              if(l[j]==cart_info[entries.key]![i]!["selected_color"]){
                l2[j]=(int.parse(l2[j])-int.parse(product_available_quantity_map[entries.key]![i])).toString();
                break;
              }
            }
            String total_quantity=(int.parse(snapshot.get("quantity"))
                -int.parse(product_available_quantity_map[entries.key]![i])).toString();
            batch.update(prdctDocRef, {"color_quantity_list": l2,"quantity":total_quantity});
        }
        else if(cart_info[entries.key]![i]!["selected_variation"]!=''){
            final snapshot = await prdctDocRef.get();
            List l=snapshot.get("liquid_ml_list");
            List l2=snapshot.get("liquid_quantity_list");
            for(int j=0;j<=l.length;j++){
              if(l[j]==cart_info[entries.key]![i]!["selected_variation"]){
                l2[j]=(int.parse(l2[j])-int.parse(product_available_quantity_map[entries.key]![i])).toString();
                break;
              }
            }
            String total_quantity=(int.parse(snapshot.get("quantity"))
                -int.parse(product_available_quantity_map[entries.key]![i])).toString();
            batch.update(prdctDocRef, {"liquid_quantity_list": l2,"quantity":total_quantity});
        }
        else{
            final snapshot = await prdctDocRef.get();
            String total_quantity=(int.parse(snapshot.get("quantity"))
                -int.parse(product_available_quantity_map[entries.key]![i])).toString();
            batch.update(prdctDocRef, {"quantity":total_quantity});
        }

      }
    });

    batch.commit();

  }
}