import 'package:get/get.dart';
import '../consts/colors.dart';
import '../consts/lists.dart';
import 'brands_controller.dart';
import 'category_controller.dart';

class products_previous_details_controller extends GetxController{
  final brands_controller brandController = Get.find();
  final category_controller categoryController = Get.find();

  RxList<String> size_name = ["XS", "S", "M", "L", "XL", "XXL", "3XL"].obs;

  RxList color_selected_list = [white_color_hex].obs,
      color_selected_listXS = [white_color_hex].obs,
      color_selected_listS = [white_color_hex].obs,
      color_selected_listM = [white_color_hex].obs,
      color_selected_listL = [white_color_hex].obs,
      color_selected_listXL = [white_color_hex].obs,
      color_selected_listXXL = [white_color_hex].obs,
      color_selected_list3XL = [white_color_hex].obs;


  RxList<bool> product_size_selected = [false, false, false, false, false, false, false].obs;
  RxList product_img_list = [].obs,product_prev_img_list = [].obs, cat_list = [].obs;
  RxList compressed_size_sheet_img = [].obs,product_img_uint_list = [].obs;
  String product_img_urls = "", size_chart_img_urls = "",prev_size_sheet_image=""
  ,product_first_img_urls = "";
  RxInt variation_value = 0.obs,
      off_percent = 0.obs,
      initial_price = 0.obs,
      color_count = 1.obs;
  RxList liquid_quantity_list = ["0"].obs,
      liquid_ml_price_list = ["0"].obs,
      liquid_ml_list = ["0"].obs,
      color_quantity_list = ["0"].obs,
      size_color_quantity_listXS = ["0"].obs,
      size_color_quantity_listS = ["0"].obs,
      size_color_quantity_listM = ["0"].obs,
      size_color_quantity_listL = ["0"].obs,
      size_color_quantity_listXL = ["0"].obs,
      size_color_quantity_listXXL = ["0"].obs,
      size_color_quantity_list3XL = ["0"].obs;

  RxString title = "".obs,
      description = "".obs,
      search_tags = "".obs,
      quantity = "0".obs,
      buying_limit = "0".obs,
      weight_per_kg = "0".obs,
      sell_will_start_from = "0".obs,
      product_id = "".obs;

  RxBool is_size_color_selected = false.obs,
      is_color_selected = false.obs,
      is_liquid_selected = false.obs;

  RxString selectednumberofsizecolorXS = color_list[0].toString().obs,
      selectednumberofsizecolorS = color_list[0].toString().obs,
      selectednumberofsizecolorM = color_list[0].toString().obs,
      selectednumberofsizecolorL = color_list[0].toString().obs,
      selectednumberofsizecolorXL = color_list[0].toString().obs,
      selectednumberofsizecolorXXL = color_list[0].toString().obs,
      selectednumberofsizecolor3XL = color_list[0].toString().obs,
      selectednumberofcolor = color_list[0].toString().obs,
      selectednumberofliquid = color_list[0].toString().obs;

  var selectedcategory;
  var my_category_list = [].obs;

/*  @override
  onInit(){
    load_previous_data();
    super.onInit();
  }*/

  load_previous_data(product_details_doc)async{
    product_prev_img_list.value = await product_details_doc["product_img"].toString().trim().split("  ");
    product_first_img_urls=await product_prev_img_list[0];
    prev_size_sheet_image=await product_details_doc["size_chart_img"];
    await initial_category_list(product_details_doc["brand_name"],product_details_doc["category_name"]);
    initial_price.value =await  int.parse(
        product_details_doc["initial_price"].toString().trim());
    off_percent.value =
    await  int.parse(product_details_doc["off_percent"].toString().trim());
    product_id.value =await  product_details_doc["product_given_id"];
    quantity.value =await  product_details_doc["quantity"];
    weight_per_kg.value =await  product_details_doc["weight_per_kg"];
    title.value =await  product_details_doc["product_title"];
    description.value =await  product_details_doc["product_description"];
    sell_will_start_from.value =await  product_details_doc["sell_will_start_from"];
    for (var val in await product_details_doc["search_tags"]) {
      search_tags.value =search_tags.value + "#" + val.toString();
    }
    buying_limit.value =await  product_details_doc["product_buying_limit"];

    is_size_color_selected.value =
    await product_details_doc["is_size_color_selected"] == "true"
        ? true
        : false;
    is_color_selected.value=await product_details_doc["is_color_selected"]=="true"?true:false;
    is_liquid_selected.value =await
    product_details_doc["is_liquid_selected"] == "true"
        ? true
        : false;

    if (is_size_color_selected.value) {
      color_selected_listXS.clear();
      color_selected_listS.clear();
      color_selected_listM.clear();
      color_selected_listL.clear();
      color_selected_listXL.clear();
      color_selected_listXXL.clear();
      color_selected_list3XL.clear();
      size_color_quantity_listXS.clear();
      size_color_quantity_listS.clear();
      size_color_quantity_listM.clear();
      size_color_quantity_listL.clear();
      size_color_quantity_listXL.clear();
      size_color_quantity_listXXL.clear();
      size_color_quantity_list3XL.clear();
      for (var val in await product_details_doc["color_selected_listXS"])
        color_selected_listXS.add(val);
      for (var val in await product_details_doc["color_selected_listS"])
        color_selected_listS.add(val);
      for (var val in await product_details_doc["color_selected_listM"])
        color_selected_listM.add(val);
      for (var val in await product_details_doc["color_selected_listL"])
        color_selected_listL.add(val);
      for (var val in await product_details_doc["color_selected_listXL"])
        color_selected_listXL.add(val);
      for (var val in await product_details_doc["color_selected_listXXL"])
        color_selected_listXXL.add(val);
      for (var val in await product_details_doc["color_selected_list3XL"])
        color_selected_list3XL.add(val);

      for (var val in await product_details_doc["size_color_quantity_listXS"])
        size_color_quantity_listXS.add(val);
      for (var val in await product_details_doc["size_color_quantity_listS"])
        size_color_quantity_listS.add(val);
      for (var val in await product_details_doc["size_color_quantity_listM"])
        size_color_quantity_listM.add(val);
      for (var val in await product_details_doc["size_color_quantity_listL"])
        size_color_quantity_listL.add(val);
      for (var val in await product_details_doc["size_color_quantity_listXL"])
        size_color_quantity_listXL.add(val);
      for (var val in await product_details_doc["size_color_quantity_listXXL"])
        size_color_quantity_listXXL.add(val);
      for (var val in await product_details_doc["size_color_quantity_list3XL"])
        size_color_quantity_list3XL.add(val);

      if (color_selected_listXS.length > 1 ||
          color_selected_listXS[0] != white_color_hex ||
          size_color_quantity_listXS[0] != "0") {
        product_size_selected.value[0] =await  true;
        selectednumberofsizecolorXS.value =
        await color_selected_listXS.length.toString();
      }
      if (color_selected_listS.length > 1 ||
          color_selected_listS[0] != white_color_hex ||
          size_color_quantity_listS[0] != "0") {
        product_size_selected.value[1] =await  true;
        selectednumberofsizecolorS.value =
        await  color_selected_listS.length.toString();
      }
      if (color_selected_listM.length > 1 ||
          color_selected_listM[0] != white_color_hex ||
          size_color_quantity_listM[0] != "0") {
        product_size_selected.value[2] =await  true;
        selectednumberofsizecolorM.value =
        await  color_selected_listM.length.toString();
      }
      if (color_selected_listL.length > 1 ||
          color_selected_listL[0] != white_color_hex ||
          size_color_quantity_listL[0] != "0") {
        product_size_selected.value[3] =await  true;
        selectednumberofsizecolorL.value =
        await  color_selected_listL.length.toString();
      }
      if (color_selected_listXL.length > 1 ||
          color_selected_listXL[0] != white_color_hex ||
          size_color_quantity_listXL[0] != "0") {
        product_size_selected.value[4] =await  true;
        selectednumberofsizecolorXL.value =
        await   color_selected_listXL.length.toString();
      }
      if (color_selected_listXXL.length > 1 ||
          color_selected_listXXL[0] != white_color_hex ||
          size_color_quantity_listXXL[0] != "0") {
        product_size_selected.value[5] =await  true;
        selectednumberofsizecolorXXL.value =
        await  color_selected_listXXL.length.toString();
      }
      if (color_selected_list3XL.length > 1 ||
          color_selected_list3XL[0] != white_color_hex ||
          size_color_quantity_list3XL[0] != "0") {
        product_size_selected.value[6] =await  true;
        selectednumberofsizecolor3XL.value =
        await  color_selected_list3XL.length.toString();
      }
    } else if (is_color_selected.value) {
      color_selected_list.clear();
      color_quantity_list.clear();
      for (var val in await product_details_doc["color_selected_list"]) {
        color_selected_list.add(val);
      }
      for (var val in await product_details_doc["color_quantity_list"]) {
        color_quantity_list.add(val);
      }
      selectednumberofcolor.value = await color_selected_list.length.toString();
    } else if (is_liquid_selected.value) {
      liquid_ml_list.clear();
      liquid_ml_price_list.clear();
      liquid_quantity_list.clear();

      for (var val in product_details_doc["liquid_ml_list"]) {
        liquid_ml_list.add(val);
      }
      for (var val in product_details_doc["liquid_ml_price_list"]) {
        liquid_ml_price_list.add(val);
      }
      for (var val in product_details_doc["liquid_quantity_list"]) {
        liquid_quantity_list.add(val);
      }
      selectednumberofliquid.value =await  liquid_quantity_list.length.toString();
    }
  }

  initial_category_list(String selected_brand,category_name) {
    my_category_list.clear();
    for (int i = 0; i < brandController.mybrandlist.length; i++) {
      if (brandController.mybrandlist[i]["brand_name"] == selected_brand) {
        cat_list.value = brandController.mybrandlist[i]['brand_categories'];
      }
    }
    for (var val in categoryController.allCategorylist) {
      if (cat_list.contains(val["category_name"])) {
        my_category_list.add(val);
      }
    }
    for (var val in my_category_list) {
      if (val["category_name"] == category_name) {
        selectedcategory = val;
        break;
      }
    }
  }


}