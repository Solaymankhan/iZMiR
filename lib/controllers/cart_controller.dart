import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/consts.dart';
import '../pages/brand_shop_home_page.dart';
import '../pages/hexcolorMaker_controller.dart';
import '../pages/product_details_page.dart';
import '../shapes/all_product_network_image_shape.dart';
import 'drawer_controller.dart';

class cart_controller extends GetxController{

  var docference = FirebaseFirestore.instance.collection("products");
  final drawer_controller drawerController = Get.find();
  RxMap<String, List<Map<String, dynamic>?>> cart_products = RxMap();
  RxMap<String, List<bool>> product_selected_map=RxMap();
  RxMap<String, List<int>?> removable_cart_info_map=RxMap();
  RxMap<String, List<String>> product_id_map=RxMap();
  RxMap<String, List<String>?> product_available_quantity_map=RxMap();
  int iter=0;
  List<String> cart_amnt=[];
  RxString total_price='0'.obs;
  RxBool is_all_selected = false.obs,isCompleted= false.obs;

  Future<void> get_product_data() async {
    is_all_selected.value=false;
    cart_products.clear();
    product_id_map.clear();
    product_selected_map.clear();
    removable_cart_info_map.clear();
    product_available_quantity_map.clear();
    cart_amnt.clear();

    RxMap<String, List<Map<String, dynamic>?>> temporary = RxMap();
    await Future.forEach(drawerController.cart.entries, (entry) async {
      String key = entry.key;
      List<Map<String,dynamic>?> data_list=[];
      List<String> product_id_list=[];
      List<String> vogas_list=[];
      List<bool> product_selected_list=[];
      int indxs=0;

      await Future.forEach(entry.value, (element) async{
        await docference.doc(element["product_database_id"]).get().then((doc) {
          if(doc.exists){
            data_list.add(doc.data());
            product_id_list.add(doc.id);
            product_selected_list.add(false);
            vogas_list.add("1");

          }else{
            removable_cart_info_map.putIfAbsent(entry.key, () => []);
            removable_cart_info_map[entry.key]!.add(indxs);
          }
        });
        indxs++;
      }).then((value) {
        temporary[key]=data_list;
        product_id_map[key]=product_id_list;
        product_selected_map[key]=product_selected_list;
        product_available_quantity_map[key]=vogas_list;
      });
    }).then((value) {
      cart_products.value = temporary;
      isCompleted.value=true;
    });

    if(!removable_cart_info_map.isEmpty){
        await Future.forEach(removable_cart_info_map.entries, (entry) async {
          for(var val in entry.value!) await drawerController.cart[entry.key]!.removeAt(val);
        });
        drawerController.update_cart();
      }
    if(cart_products.isEmpty){
      drawerController.cart.clear();
      drawerController.update_cart();
    }

  }

  Widget cart_shape(het,wdt) {
    if (cart_products.isEmpty) {
      return Container(
          height: het/2+200 ,
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
                physics: const BouncingScrollPhysics(),
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
                                      flex: 2,
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
                                                fontWeight: FontWeight.w400),).marginOnly(left: 5),
                                        )
                                      ],),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          cart_products[cart_products.keys.elementAt(index)]![0]!["brand_offer"]=='0'?"":
                                          "${cart_products[cart_products.keys.elementAt(index)]![0]!["brand_offer"]}% Extra off",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: orangeColor,fontWeight: FontWeight.bold),)
                                        ,),
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
                                      print(product_id_map);
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
                                              Obx(
                                                ()=> Material(
                                                  borderRadius: BorderRadius.circular(50),
                                                  child: InkWell(
                                                      borderRadius: BorderRadius.circular(50),
                                                      onTap: () {

                                                          product_selected_map[cart_products.keys.elementAt(index)]![index2]=!
                                                          product_selected_map[cart_products.keys.elementAt(index)]![index2];
                                                          total_price_calculation();
                                                      },
                                                      child: Ink(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(50),
                                                            color: lightGreyColor
                                                        ),
                                                        child: Container(
                                                          width: 20,
                                                          padding: EdgeInsets.all(10),
                                                          child:
                                                          product_selected_map[cart_products.keys.elementAt(index)]![index2]
                                                              ? SvgPicture.asset(
                                                            green_circle_icon,
                                                          )
                                                              : SvgPicture.asset(
                                                            grey_circle_icon,
                                                          ),
                                                        ),)
                                                  ),
                                                ),
                                              ),
                                              CachedNetworkImage(
                                                imageUrl:cart_products[cart_products.keys.elementAt(index)]![index2]!["product_first_img"],
                                                imageBuilder: (context, url)=> cart_network_image_shape(url),
                                                placeholder: (context, url)=>cart_asset_image_shape(),
                                                errorWidget: (context, url, error) => cart_asset_image_shape(),
                                              ),
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
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    7.heightBox,
                                                    Visibility(
                                                      visible: drawerController.cart[cart_products.keys.elementAt(index)]![index2]
                                                      ["selected_size"]==""?false:true,
                                                      child: Text(
                                                        "Size : ${drawerController.cart[cart_products.keys.elementAt(index)]![index2]
                                                        ["selected_size"]}",
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                    2.heightBox,
                                                    Visibility(
                                                      visible: drawerController.cart[cart_products.keys.elementAt(index)]![index2]
                                                      ["selected_size_color"]==""?false:true,
                                                      child: Row(children: [
                                                        Text("Color : "),
                                                        Container(
                                                          margin: EdgeInsets.only(left:5,right: 5),
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                            color: hexColor(drawerController.cart[cart_products.keys.elementAt(index)]![index2]
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
                                                      visible: drawerController.cart[cart_products.keys.elementAt(index)]![index2]
                                                      ["selected_color"]==""?false:true,
                                                      child: Row(children: [
                                                        Text("Color : "),
                                                      Container(
                                                        margin: EdgeInsets.only(left:5,right: 5),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                          color: hexColor(drawerController.cart[cart_products.keys.elementAt(index)]![index2]
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
                                                        visible:drawerController.cart[cart_products.keys.elementAt(index)]![index2]
                                                        ["selected_variation"]==""?false:true,
                                                      child: Text(
                                                        "Variation : ${drawerController.cart[cart_products.keys.elementAt(index)]![index2]
                                                        ["selected_variation"]}",
                                                        style: TextStyle(
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

                                                          )),
                                                          TextSpan(
                                                            text: item_price(drawerController.cart[cart_products.keys.elementAt(index)]![index2],
                                                                cart_products[cart_products.keys.elementAt(index)]![index2]),
                                                            style: TextStyle(
                                                                fontSize: 16,
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
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Material(
                                                  borderRadius: BorderRadius.circular(50),
                                                  child: InkWell(
                                                    onTap: () {
                                                      total_price.value='0';
                                                      String s=cart_products.keys.elementAt(index);
                                                      drawerController.cart[s]!.removeAt(index2);
                                                      if(drawerController.cart[s]!.length==0){
                                                        drawerController.cart.remove(s);
                                                      }
                                                      drawerController.update_cart();
                                                      get_product_data();
                                                    },
                                                    borderRadius: BorderRadius.circular(50),
                                                    child: Ink(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(50),
                                                          color: lightGreyColor
                                                      ),
                                                      child: Icon(CupertinoIcons.xmark,size: 20.0),
                                                    ),
                                                  ),
                                                ).box.margin(EdgeInsets.only(right: 5)).make(),
                                                55.heightBox,
                                                Text(
                                                    item_storage(drawerController.cart,cart_products,cart_products.keys.elementAt(index),index2),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500),
                                                ).box.margin(EdgeInsets.only(left: 5,right: 5)).make(),
                                              ],
                                            ),
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
                            .margin(EdgeInsets.only(left: 15,right: 15,bottom: 20)).make(),
                  );}
            ),
    );
    }
  }

  item_storage(cart,products,key,index2){
    String s=available_item(cart[key]![index2],products[key]![index2]);
        product_available_quantity_map[key]![index2]=s;
        return s;
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

  total_price_calculation(){
    total_price.value='0';
    iter=0;
    product_selected_map.forEach((key, value) {
      for(int i=0;i<value.length;i++){
        if(value[i]){
          if(drawerController.cart[key]![i]["selected_variation"]!=''){
            int cart_quantity=int.parse(drawerController.cart[key]![i]["product_quantity"]!);
            List l= cart_products[key]![i]!["liquid_ml_list"];
            for(int j=0;j<l.length;j++){
              if(l[j]==drawerController.cart[key]![i]["selected_variation"]){
                if(int.parse(cart_products[key]![i]!["liquid_quantity_list"][j])>=cart_quantity){
                  total_price.value= "${(double.parse(total_price.value)+((int.parse(cart_products[key]![i]!["liquid_ml_price_list"][j])-
                      (((int.parse(cart_products[key]![i]!["brand_offer"])+int.parse(cart_products[key]![i]!["off_percent"]))
                          *int.parse(cart_products[key]![i]!["liquid_ml_price_list"][j]))/100
                      ))* cart_quantity)).toStringAsFixed(0)}";
                }
                else if(int.parse(cart_products[key]![i]!["liquid_quantity_list"][j])<cart_quantity){
                  total_price.value= "${(double.parse(total_price.value)+((int.parse(cart_products[key]![i]!["liquid_ml_price_list"][j])-
                      (((int.parse(cart_products[key]![i]!["brand_offer"])+int.parse(cart_products[key]![i]!["off_percent"]))
                          *int.parse(cart_products[key]![i]!["liquid_ml_price_list"][j]))/100
                      ))* int.parse(cart_products[key]![i]!["liquid_quantity_list"][j]))).toStringAsFixed(0)}";
                }
                else if(int.parse(cart_products[key]![i]!["liquid_quantity_list"][j])==0){
                  total_price.value= "${(double.parse(total_price.value)+0)}";
                }
              }
            }
          }else{
            total_price.value="${(double.parse(total_price.value)+
                ((double.parse(cart_products[key]![i]!["final_price"])-
                    ((double.parse(cart_products[key]![i]!["brand_offer"])*double.parse(cart_products[key]![i]!["final_price"]))/100
                    ))*double.parse(drawerController.cart[key]![i]["product_quantity"]!))).toStringAsFixed(0)}";
          }
          iter++;
        }
      }
    });
    is_all_selected.value=(iter!=0 && iter==drawerController.total_items_in_cart.value)?true:false;
  }

  Future<void> delete_bought_items_from_cart()async{
    await Future.forEach(product_selected_map.entries,(entries) {
      int ind=0;
      for(int i=0;i<entries.value.length;i++){
        if(entries.value[i]){
          drawerController.cart[entries.key]!.removeAt(ind);
          ind--;
        }
        ind++;
      }
      if(drawerController.cart[entries.key]!.length==0){
        drawerController.cart.remove(entries.key);
      }
    });
    total_price.value='0';
    drawerController.update_cart();
    await get_product_data();
  }

}