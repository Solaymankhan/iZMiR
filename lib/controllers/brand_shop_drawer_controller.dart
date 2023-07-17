import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/consts.dart';

class brand_shop_drawer_controller extends GetxController{
  var instance = FirebaseFirestore.instance.collection("orders");
  var scaffold_key=GlobalKey<ScaffoldState>();
  RxList orders = [].obs, orders_ids = [].obs,dash_board_list = [].obs,
  order_activity_list = ["Orders","Out from shop","Delivered","Cancels","Applied for return","Returns"].obs;
  RxString brand_id="".obs;
  var brand_info;
  RxBool is_loading_finished = false.obs;
  RxInt current_index = 0.obs;

  @override
  void onInit() {

    super.onInit();
  }
  call_for_fetch_data(index_txt){
    var refrence= instance
        .where("shop_database_id", isEqualTo:brand_id.value)
        .where("order_activity", isEqualTo: index_txt)
        .orderBy("order_time", descending: true);
    fetch_data(refrence);
  }

  fetch_data(refrence) async {
    is_loading_finished.value = false;
    orders.clear();
    orders_ids.clear();
    try {
      refrence
          .get()
          .then((valu) async {
        for (var val in valu.docs) orders_ids.add(val.id);
        orders.addAll(valu.docs.map((e) => e.data()));
      });
    } catch (e) {}
    is_loading_finished.value = true;
  }
  fetch_dash_board(brand_data)async{
    brand_info=brand_data;
    dash_board_list.value = [
      {
        "title": "Total Sells",
        "type": "taka",
        "value": brand_data["total_sells"].toString(),
        "starting_color": Vx.red800,
        "ending_color": Vx.red400
      },
      {
        "title": "Today Sells",
        "type": "taka",
        "value": brand_data["today_sells"].toString(),
        "starting_color": Vx.cyan800,
        "ending_color": Vx.cyan400
      },
      {
        "title": "Products",
        "type": "number",
        "value":  brand_data["total_products"].toString(),
        "starting_color": Vx.orange800,
        "ending_color": Vx.orange400
      },
      {
        "title": "Likes",
        "type": "number",
        "value": brand_data['brand_likes'].toString(),
        "starting_color": Vx.yellow800,
        "ending_color": Vx.yellow400
      },
      {
        "title": "Visits",
        "type": "number",
        "value": brand_data['brand_clicked'].toString(),
        "starting_color": Vx.fuchsia800,
        "ending_color": Vx.fuchsia400
      },
      {
        "title": "Orders",
        "type": "number",
        "value":  brand_data["total_orders"].toString(),
        "starting_color": Vx.emerald800,
        "ending_color": Vx.emerald400
      },
      {
        "title": "Cancels",
        "type": "number",
        "value":  brand_data["total_cancels"].toString(),
        "starting_color": Vx.pink800,
        "ending_color": Vx.pink400
      },
      {
        "title": "Delivered",
        "type": "number",
        "value": brand_data["total_delivered"].toString(),
        "starting_color": Vx.rose800,
        "ending_color": Vx.rose400
      },
      {
        "title": "Returns",
        "type": "number",
        "value": brand_data["total_returns"].toString(),
        "starting_color": Vx.violet800,
        "ending_color": Vx.violet400
      },
      {
        "title": "Offer %",
        "type": "number",
        "value": brand_data['brand_offer'].toString(),
        "starting_color": Vx.zinc800,
        "ending_color": Vx.zinc400
      }
    ];
  }




  void openDrawer(){
    scaffold_key.currentState!.openDrawer();
  }
  void closeDrawer(){
    scaffold_key.currentState!.openEndDrawer();
  }

}
