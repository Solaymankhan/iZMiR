import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../consts/lists.dart';
import '../shapes/category_button_shape.dart';
import '../shapes/product_heading.dart';

class category_controller extends GetxController {

  RxInt selected_category_index=0.obs,selected_category_front_index=0.obs;

  var category_reference = FirebaseFirestore.instance.collection("category");
  var subcategory_reference = FirebaseFirestore.instance.collection("sub_category");
  var allCategorylist = [].obs,selectedsubCategorylist = [].obs,allsubCategorylist = [].obs,
      allCategoryFrontlist = [].obs,allsubCategoryFrontlist = [].obs;

  @override
  void onInit() async{
    get_home_subcategory_data();
    await get_front_category_data();
    await get_front_subcategory_data(allCategoryFrontlist[selected_category_front_index.value]["category_id"]);
    super.onInit();
  }

  Future<void> get_home_subcategory_data()async{
    await subcategory_reference
        .orderBy('sub_category_clicked',descending: false)
        .get().then((value) {
      for(var val in value.docs){
        allsubCategorylist.add({
          "category_id": val.get("category_id"),
          "sub_category_id": val.id,
          'sub_category_name': val.get('sub_category_name'),
          'sub_category_icon': val.get('sub_category_icon'),
          'sub_category_season': val.get('sub_category_season'),
          'sub_category_offer': val.get('sub_category_offer'),
          'sub_category_clicked': val.get('sub_category_clicked'),
          'sub_category_adding_time': val.get('sub_category_adding_time'),
          "sub_category_selected": false,
        });
      }
    });
  }

  Future<void> get_front_category_data() async {
    await category_reference
        .orderBy("category_name",descending: false)
        .get().then((value) {
      allCategoryFrontlist.clear();
      for(var val in value.docs){
        allCategoryFrontlist.add({
          "category_id": val.id,
          "category_name": val.get("category_name"),
          "category_icon": val.get("category_icon"),
          "category_adding_time": val.get("category_adding_time"),
          "category_selected": false,
        });
      }
    });
  }

  Future<void> get_front_subcategory_data(category_id)async{
    await subcategory_reference
        .where('category_id',isEqualTo:category_id)
        .orderBy('sub_category_name',descending: false)
        .get().then((value) {
      for(var val in value.docs){
        allsubCategoryFrontlist.add({
          "category_id": val.get("category_id"),
          "sub_category_id": val.id,
          'sub_category_name': val.get('sub_category_name'),
          'sub_category_icon': val.get('sub_category_icon'),
          'sub_category_season': val.get('sub_category_season'),
          'sub_category_offer': val.get('sub_category_offer'),
          'sub_category_clicked': val.get('sub_category_clicked'),
          'sub_category_adding_time': val.get('sub_category_adding_time'),
          "sub_category_selected": false,
        });
      }
    });
  }

  Future<void> get_category_data() async {
    await category_reference
        .orderBy("category_name",descending: false)
        .get().then((value) {
      allCategorylist.clear();
      for(var val in value.docs){
        allCategorylist.add({
          "category_id": val.id,
          "category_name": val.get("category_name"),
          "category_icon": val.get("category_icon"),
          "category_adding_time": val.get("category_adding_time"),
          "category_selected": false,
        });
      }
    });
  }

  Future<void> get_subcategory_data(category_id)async{
    await subcategory_reference
         .where('category_id',isEqualTo:category_id)
         .orderBy('sub_category_name',descending: false)
         .get().then((value) {
      for(var val in value.docs){
        selectedsubCategorylist.add({
          "category_id": val.get("category_id"),
          "sub_category_id": val.id,
          'sub_category_name': val.get('sub_category_name'),
          'sub_category_icon': val.get('sub_category_icon'),
          'sub_category_season': val.get('sub_category_season'),
          'sub_category_offer': val.get('sub_category_offer'),
          'sub_category_clicked': val.get('sub_category_clicked'),
          'sub_category_adding_time': val.get('sub_category_adding_time'),
          "sub_category_selected": false,
        });
      }
    });
  }

}