import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../consts/consts.dart';

class drawer_controller extends GetxController{
  var user_doc_id="".obs,pref_userId="".obs,lgin_lgot_txt="".obs,account_balance_txt="0".obs,
      buying_ammount_txt="0".obs;
  RxInt starting_first_time=0.obs,total_items_in_cart=0.obs;
  RxList liked_brands_list=[].obs;
  RxMap<String, List<Map<String,String>>> cart = RxMap();
  var scaffold_key=GlobalKey<ScaffoldState>();
  RxMap pref_info=RxMap();

  void openDrawer(){
    scaffold_key.currentState!.openDrawer();
  }
  void closeDrawer(){
    scaffold_key.currentState!.openEndDrawer();
  }

  @override
  void onInit() {
    starting_first_time.value++;
    get_userId();
    getProfileInfo();
    get_cart();
    super.onInit();
  }

  void save_cart(brand_name,product_info_map){
    if (!cart.containsKey(brand_name)) {
      cart[brand_name] = [];
    }
    final productIndex = cart[brand_name]!.indexWhere(
            (item) =>
        item["product_given_id"]== product_info_map["product_given_id"] &&
        item["selected_variation"] == product_info_map["selected_variation"] &&
        item["selected_size"] == product_info_map["selected_size"] &&
        item["selected_size_color"] == product_info_map["selected_size_color"] &&
        item["selected_color"] == product_info_map["selected_color"] &&
        item["product_database_id"] == product_info_map["product_database_id"]
    );
    if (productIndex != -1) {
      cart[brand_name]![productIndex]["product_quantity"]=
          (int.parse(cart[brand_name]![productIndex]["product_quantity"]!)+
              int.parse(product_info_map["product_quantity"])).toString();
    } else {
      cart[brand_name]!.add(product_info_map);
    }
    update_cart();
  }

  void update_cart()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('cart', json.encode(cart));
    count_total_item();
  }


  void get_cart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final cartData = preferences.getString('cart');
    var val = (cartData != null) ? json.decode(cartData) : {};
    await val.forEach((key, value) async{
      List< Map<String,String>> l=[];
      await value.forEach((element) async{
        Map<String,String> mp= {
          "selected_size":element["selected_size"].toString(),
          "selected_size_color":element["selected_size_color"].toString(),
          "selected_variation":element["selected_variation"].toString(),
          "selected_color":element["selected_color"].toString(),
          "product_database_id":element["product_database_id"].toString(),
          "product_given_id":element["product_given_id"].toString(),
          "product_quantity":element["product_quantity"].toString()
        };
        l.add(mp);
      });
      cart[key]=l;
    });
    count_total_item();
    }


  void save_userId(String pref_userId) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.setString("pref_userId", pref_userId);
    lgin_lgot_txt.value = logout_txt;
    this.pref_userId.value=pref_userId;
  }
  void get_userId() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref_userId.value=pref.getString("pref_userId")!;
  }
  void saveProfileInfo(Map info) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String encodedMap = json.encode(info);
    pref.setString("profile_info", encodedMap);
    pref_info.value=info;
    get_interactive_info();
  }
  void getProfileInfo() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String encodedMap = pref.getString("profile_info")!;
    pref_info.value = json.decode(encodedMap);
    get_interactive_info();
  }

  void get_interactive_info() async{
    await FirebaseFirestore.instance.collection(pref_info["account_type"])
        .doc(pref_userId.value).snapshots().listen((value){
      account_balance_txt.value=value.get("balance");
      buying_ammount_txt.value =value.get("buying_ammount");
      liked_brands_list.value=value.get("liked_brands");
    });
  }

  void save_profile_info_again()async{
    if(pref_userId.value.length>0 && pref_info.value.length>0){
      await FirebaseFirestore.instance.collection(pref_info["account_type"])
          .doc(pref_userId.value).get().then((value){
        var info = new Map();
        info["name"] = value.get("name");
        info["profile_picture"] = value.get("profile_picture");
        info["phone"] = value.get("phone");
        info["email"] = value.get("email");
        info["address"] = value.get("address");
        info["account_type"] = value.get("account_type");
        info["division"] =value.get("division");
        info["district"] =value.get("district");
        info["referral_code"]=value.get("referral_code");
        info["level"] = value.get("level");
        info["time"] = value.get("time");
        saveProfileInfo(info);
      });
    }
  }

void delete_pref_info() async{
  SharedPreferences pref=await SharedPreferences.getInstance();
  pref.remove("profile_info");
  pref_info.clear();
}

  void removeCarts() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("cart");
    cart.clear();
    count_total_item();
  }

  void removeUserId() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.remove("pref_userId");
    pref.remove("cart");
    pref_info.clear();
    cart.clear();
    lgin_lgot_txt.value = login_txt;
    pref_userId.value="";
    user_doc_id.value="";
  }


  Widget notification_icon(){
    return Obx(
      ()=> Badge(
        backgroundColor: orangeColor,
        label: Text("${total_items_in_cart.value}"),
        child: Icon(CupertinoIcons.cart_fill),
        isLabelVisible: total_items_in_cart.value==0?false:true,
      ),
    );
  }

  count_total_item(){
    total_items_in_cart.value=0;
    cart.forEach((key, value) {total_items_in_cart.value=total_items_in_cart.value+value.length;});
  }

  is_limited_and_bought(){
    return false;
  }


}
