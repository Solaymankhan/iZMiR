import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izmir/consts/consts.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/lists.dart';
import '../consts/strings.dart';
import '../controllers/category_controller.dart';
import '../controllers/drawer_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/dont_have_any_data.dart';
import '../shapes/dont_have_any_data_2.dart';
import '../shapes/snack_bar.dart';

final drawer_controller drawerController = Get.find();
final category_controller categoryController = Get.find();

class brand_details_page extends StatefulWidget {
  brand_details_page({Key? key,required this.brand_id})
      : super(key: key);
  var brand_id;

  @override
  State<brand_details_page> createState() => _brand_details_pageState();
}

class _brand_details_pageState extends State<brand_details_page> {
  var categorydocreference = FirebaseFirestore.instance.collection("category");
  var prodocreference = FirebaseFirestore.instance.collection("professionals");
  var branddocreference = FirebaseFirestore.instance.collection("brands");
  var productsdocreference = FirebaseFirestore.instance.collection("products");
  var brand_img_docreference=FirebaseStorage.instance;
  var firestore_instance=FirebaseFirestore.instance;
  var brand_editors_id_list = [].obs,
      brand_editors_list = [].obs,
      brand_editors_view_id_list = [].obs,
      dstrct_lst = ["Dhaka"].obs,
      brand_categories = [].obs,
      prev_categories = [].obs,
      new_list = categoryController.allsubCategorylist,
      category_selection_list = [].obs,
      editors_selection_list = [].obs,
      prev_editor_list = [].obs,
      pro_user_list = [].obs;

  final _brandinfo_formkey = GlobalKey<FormState>();

  RxString
      edtr_search_txt = "0".obs,
      brand_icon = "".obs,
      cat_search_txt = "0".obs;
  var brand_name=TextEditingController();
  var off_percent=TextEditingController();
  var dtldlctn_txt=TextEditingController();
  var phone_number=TextEditingController();
  String  selecteddivision = "Dhaka",selecteddistrict= "Dhaka";
  final int batchSize = 500;
  Uint8List image = Uint8List.fromList([0]);
  var wdt, het,brand_details;
  late BuildContext context_for_snakbar;

  @override
  initState() {
    Future.delayed(Duration(milliseconds: 400), () async{
      load_data();
    });
    super.initState();
  }

  load_data()async{
    branddocreference.doc(widget.brand_id).get().then((value) {
      brand_details=value.data();
      selecteddivision =brand_details['brand_division'];
      selecteddistrict= brand_details['brand_district'];
      brand_icon.value= brand_details["brand_icon"];
      dtldlctn_txt.text =brand_details['brand_full_location'];
      brand_name.text =brand_details["brand_name"];
      phone_number.text= brand_details['brand_contact_number'];
      off_percent.text=brand_details['brand_offer'];
      brand_editors_id_list.value =brand_details["brand_editors"];
      brand_categories.value =brand_details['brand_categories'];
      change_district((division_list.indexOf(selecteddivision) + 1).toString());
      my_categories();
      prodocreference.where(FieldPath.documentId,whereIn: brand_editors_id_list).snapshots().listen((event){
        brand_editors_list.clear();
        brand_editors_view_id_list.clear();
        brand_editors_list.addAll(event.docs.map((e) => e.data()));
        for(var val in event.docs)brand_editors_view_id_list.add(val.id);
      });

    });
  }

  my_categories(){
        for(var val in categoryController.allsubCategorylist){
          if(brand_categories.contains(val['sub_category_name'])){
            prev_categories.add(val);
          }
    }
  }
  @override
  void dispose() {
      Future.delayed(Duration(milliseconds: 200), () async{
        for (int i = 0; i < new_list.length; i++) {
          new_list[i]["sub_category_selected"] = false;
        }
      });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    wdt = (MediaQuery.of(context).size.width);
    het = (MediaQuery.of(context).size.height);
    context_for_snakbar=context;

    return Scaffold(
      body: SafeArea(
          child:
          Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                  ),
                  Container(
                      alignment: Alignment.centerRight,
                      height: 50,
                      margin: EdgeInsets.only(right: 10),
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: Ink(
                              height: 40,
                              width: 40,
                              color: whiteColor,
                              child: Icon(CupertinoIcons.back)),
                        ),
                      )),
                  Text(
                    edt_brand_txt,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ).box.margin(EdgeInsets.only(bottom: 3)).make(),
                ],
              ).box.padding(EdgeInsets.only(top: 5)).make(),
              Material(
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    showAlertDialog(context);
                  },
                  child: Ink(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: lightGreyColor),
                      child: Icon(CupertinoIcons.delete)),
                ),
              ).box.margin(EdgeInsets.only(right: 15)).make(),
            ],
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child:Form(
                  key: _brandinfo_formkey,
                  child: Obx(
                      ()=> Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(100),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () async {
                                    ImagePicker imagePicker = ImagePicker();
                                    XFile? img = await imagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    image = (await FlutterImageCompress
                                        .compressWithFile(img!.path,
                                        quality: 15))!;

                                    setState(() {});
                                  },
                                  child:image.length > 1?
                                  Ink(
                                    height: 50,
                                    width: 50,
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      image: new DecorationImage(
                                        image:MemoryImage(image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ):CachedNetworkImage(
                                    imageUrl: brand_icon.value,
                                    imageBuilder: (context, url)=> profile_network_image_shape(url),
                                    placeholder: (context, url)=>profile_asset_image_shape(),
                                    errorWidget: (context, url, error) => profile_asset_image_shape(),
                                  ),
                                ),
                              ),
                              Text(
                                "Brand/Shop Logo",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ).box.margin(EdgeInsets.only(left: 10)).make(),
                            ],
                          )
                              .box
                              .margin(EdgeInsets.only(left: 5, right: 5))
                              .make(),
                          20.heightBox,
                          TextFormField(
                            controller: brand_name,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: "Brand/Shop name",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(CupertinoIcons.music_house),
                              contentPadding: EdgeInsets.all(8),
                            ),
                            maxLength: 25,
                            validator: (value) {
                              return validatebrandname(value!);
                            },
                          ),
                              10.heightBox,
                              TextFormField(
                                controller: phone_number,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  labelText: "Contact/Phone number",
                                  prefixIcon: Icon(Icons.phone),
                                ),
                                maxLength: 11,
                                keyboardType: TextInputType.number,

                                validator: (value) {
                                  return validatePhone(value!);
                                },
                              ),
                          10.heightBox,
                          TextFormField(
                            controller: off_percent,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: "Off",
                                prefixIcon: Icon(CupertinoIcons.percent),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              maxLength: 2,),
                          10.heightBox,
                          DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: "Division",
                                  contentPadding: EdgeInsets.only(left: 15, right: 5),
                                  border: OutlineInputBorder(),
                                ),
                                value: selecteddivision,
                                items: division_list
                                    .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                                    .toList(),
                                onChanged: (val) {
                                  String s=val.toString();
                                selecteddivision = s;
                                change_district((division_list.indexOf(selecteddivision) + 1).toString());
                                setState(() {
                                });
                                },
                          ),
                          30.heightBox,
                          DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: "District",
                                  contentPadding: EdgeInsets.only(left: 15, right: 5),
                                  border: OutlineInputBorder(),
                                ),
                                value: selecteddistrict,
                                items: dstrct_lst
                                    .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                )).toList(),
                                onChanged: (val) {
                                  selecteddistrict = val.toString();
                                },
                                validator: (value) {
                                  if (value.toString().length == 0)
                                    return "District can't be empty";
                                },
                              ),
                          30.heightBox,
                          TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: dtldlctn_txt,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: OutlineInputBorder(),
                                  labelText: "Detailed Location (Comma separated)",
                                  prefixIcon: Icon(CupertinoIcons.placemark),
                                ),
                                maxLength: 40,
                                validator: (val){
                                  return validatefulladdress(val!);
                                },
                              ),
                          10.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  Container(
                                    height: 16,
                                    width: 5,
                                    color: yellowColor,
                                  ),
                                  Container(
                                    height: 16,
                                    width: 5,
                                    color: darkBlueColor,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                  ),
                                  Text(
                                    editors_txt,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                 Text(
                                      editors_selection_list.length.toString() +
                                          " Selected",
                                      style: TextStyle(color: darkBlueColor),
                                    )
                                        .box
                                        .rounded
                                        .color(yellowColor)
                                        .padding(EdgeInsets.only(
                                            top: 3, bottom: 3, left: 8, right: 8))
                                        .margin(EdgeInsets.only(right: 5))
                                        .make(),
                                  Material(
                                    borderRadius: BorderRadius.circular(50),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(50),
                                      onTap: () {
                                        if(brand_editors_id_list.length>=10){
                                          show_snackbar(context_for_snakbar,more_than_10_txt,whiteColor,Colors.red);
                                        }else{
                                          edit_brand_sheet(context);
                                        }

                                      },
                                      child: Ink(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: lightGreyColor),
                                          child: Icon(CupertinoIcons.add)),
                                    ),
                                  )
                                ],
                              ).box.margin(EdgeInsets.only(right: 5)).make()
                            ],
                          ).box.margin(EdgeInsets.only(bottom: 5)).make(),
                          ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: brand_editors_list.length,
                                  itemBuilder: (context, index) {
                                    prev_editor_list.add(brand_editors_id_list[index]);
                                    return Material(
                                      borderRadius: BorderRadius.circular(6),
                                      child: InkWell(
                                          borderRadius:
                                          BorderRadius.circular(6),
                                          onTap: () {
                                            showAlertDialog2(context,brand_editors_view_id_list[index]);
                                          },
                                          child: Ink(
                                            padding: EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                                top: 2.5,
                                                bottom: 2.5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(6),
                                                color: lightGreyColor),
                                            child: Row(children: [
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                height: 50,
                                                width: 50,
                                                decoration: new BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      100),
                                                  image: new DecorationImage(
                                                    image: brand_editors_list[index]["profile_picture"]
                                                        .toString()
                                                        .length >
                                                        1
                                                        ? NetworkImage(brand_editors_list[index][
                                                    "profile_picture"])
                                                        : AssetImage(
                                                        profile_avater)
                                                    as ImageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                brand_editors_list[index]["name"],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              )
                                                  .box
                                                  .margin(
                                                  EdgeInsets.only(left: 5))
                                                  .make()
                                            ]),
                                          )),
                                    )
                                        .box
                                        .margin(EdgeInsets.only(
                                        top: 0.5, bottom: 0.5))
                                        .make();
                                  }),
                          10.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  Container(
                                    height: 16,
                                    width: 5,
                                    color: yellowColor,
                                  ),
                                  Container(
                                    height: 16,
                                    width: 5,
                                    color: darkBlueColor,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                  ),
                                  Text(
                                    categories_txt,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      category_selection_list.length.toString() +
                                          " Selected",
                                      style: TextStyle(color: darkBlueColor),
                                    )
                                        .box
                                        .rounded
                                        .color(yellowColor)
                                        .padding(EdgeInsets.only(
                                            top: 3, bottom: 3, left: 8, right: 8))
                                        .margin(EdgeInsets.only(right: 5))
                                        .make(),
                                  Material(
                                    borderRadius: BorderRadius.circular(50),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(50),
                                      onTap: () {
                                        edit_category_sheet(context);
                                      },
                                      child: Ink(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: lightGreyColor),
                                          child: Icon(CupertinoIcons.add)),
                                    ),
                                  )
                                ],
                              ).box.margin(EdgeInsets.only(right: 5)).make()
                            ],
                          ).box.margin(EdgeInsets.only(bottom: 5)).make(),
                          prev_categories.length==0?dont_have_any_data_2():Obx(
                              ()=> GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: prev_categories.length,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: het > wdt ? 4 : 7,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Material(
                                            borderRadius:
                                            BorderRadius.circular(100),
                                            child: InkWell(
                                              borderRadius:
                                              BorderRadius.circular(100),
                                              onTap: () {
                                                showAlertDialog3(context,index,prev_categories[index]['sub_category_name']);
                                              },
                                              child:CachedNetworkImage(
                                                imageUrl: prev_categories[index]['sub_category_icon'],
                                                imageBuilder: (context, url) => brand_ink_network_image_shape(url),
                                                placeholder: (context, url) => brand_ink_asset_image_shape(),
                                                errorWidget: (context, url, error) => brand_ink_asset_image_shape(),
                                              )
                                            ),
                                          ),
                                          5.heightBox,
                                          Text(
                                            prev_categories[index]['sub_category_name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                          ),
                          20.heightBox,
                          Center(
                            child: Material(
                              borderRadius: BorderRadius.circular(6),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: () {
                                  update_data_in_database();
                                },
                                child: Ink(
                                  height: 40,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: darkBlueColor),
                                  child: Center(
                                    child: Text(
                                      "Save changes",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: yellowColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          30.heightBox,
                        ])
                        .box
                        .margin(EdgeInsets.only(left: 15, right: 15))
                        .make(),
                  ),
                ),
            ),
          )
        ],
      )).color(whiteColor),
    );
  }



  change_district(indx) {
    dstrct_lst.clear();
    district_list.forEach((key, value) {
      if (indx == value) {
        dstrct_lst.add(key);
      }
    });
    selecteddistrict = dstrct_lst[0];
  }

  String? validatebrandname(String value) {
    if (value.length == 0) {
      return "Brand/Shop name can't be empty";
    }
    if (value.length > 25) {
      return "Brand/Shop name can't be more than 25 character";
    }
    return null;
  }
  RegExp _numeric = RegExp(r'^\+?01[3456789][0-9]{8}\b');
  String? validatePhone(String value) {
    if (!_numeric.hasMatch(value)) {
      return "Provide valid number";
    }
    return null;
  }

  String? validatefulladdress(String value) {
    if (value.length == 0) {
      return "Deatailed Location can't be empty";
    }
    if (value.length > 40) {
      return "Deatailed Location can't be more than 40 character";
    }
    return null;
  }

  Future edit_brand_sheet(context) => showSlidingBottomSheet(context,
      builder: (context) => SlidingSheetDialog(
          duration: const Duration(milliseconds: 150),
          snapSpec: SnapSpec(initialSnap: 0.9, snappings: [0.9]),
          cornerRadius: 15,
          scrollSpec: ScrollSpec(physics: BouncingScrollPhysics()),
          builder: buildSheet1));

  Widget buildSheet1(context, state) => Material(child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  adnw_edtr_txt,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              10.heightBox,
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: "Search Editors",
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    update_pro_user_list(value.toLowerCase());
                  });
                },
              )
                  .box
                  .height(40)
                  .width(
                    wdt < 800 ? double.infinity : wdt * 0.5,
                  )
                  .make(),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: pro_user_list.length,
                  itemBuilder: (context, index) {
                    return Material(
                      borderRadius: BorderRadius.circular(6),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () {
                            if(!prev_editor_list.contains(pro_user_list[index]["account_id"])
                            && !editors_selection_list.contains(pro_user_list[index]["account_id"])
                            ){
                              editors_selection_list.add(pro_user_list[index]["account_id"]);
                            }else{
                              show_snackbar(context_for_snakbar,alrdy_exst_txt,whiteColor,Colors.red);
                            }
                            Navigator.of(context).pop();
                          },
                          child: Ink(
                            padding: EdgeInsets.only(
                                left: 5, right: 5, top: 2.5, bottom: 2.5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: lightGreyColor),
                            child: Row(children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                height: 50,
                                width: 50,
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: new DecorationImage(
                                    image: pro_user_list[index]
                                                    ["profile_picture"]
                                                .toString()
                                                .length >
                                            1
                                        ? NetworkImage(pro_user_list[index]
                                            ["profile_picture"])
                                        : AssetImage(profile_avater)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                pro_user_list[index]["name"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ).box.margin(EdgeInsets.only(left: 5)).make()
                            ]),
                          )),
                    ).box.margin(EdgeInsets.only(top: 0.5, bottom: 0.5)).make();
                  }),
            ],
          ).box.color(whiteColor).padding(EdgeInsets.all(10)).make();
        },
      ));

  update_pro_user_list(value) async {
    QuerySnapshot q = await prodocreference
        .where("name_lowercase", isEqualTo: value)
        .where("account_status", isEqualTo: activated)
        .limit(10).get();
    pro_user_list.clear();
    for (var doc in q.docs) {
      if (doc.id != drawerController.pref_userId.value) {
        pro_user_list.add({
          "account_id": doc.id,
          "name": doc.get("name"),
          "profile_picture": doc.get("profile_picture"),
          "phone": doc.get("phone"),
          "email": doc.get("email"),
          "address": doc.get("address"),
          "account_type": doc.get("account_type"),
          "division": doc.get("division"),
          "district": doc.get("district"),
          "time": doc.get("time"),
          "selected": false,
        });
      }
    }

    print(pro_user_list);

  }

  Future edit_category_sheet(context) => showSlidingBottomSheet(context,
      builder: (context) => SlidingSheetDialog(
          duration: const Duration(milliseconds: 150),
          snapSpec: SnapSpec(snappings: [0.9]),
          cornerRadius: 15,
          scrollSpec: ScrollSpec(physics: BouncingScrollPhysics()),
          builder: buildSheet2));

  Widget buildSheet2(context, state) =>
      Material(child: StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                adnw_ctgry_txt,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            10.heightBox,
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: "Search category",
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  update_cat_list(value);
                });
              },
            )
                .box
                .height(40)
                .width(
                  wdt < 600 ? double.infinity : wdt * 0.6,
                )
                .make(),
            GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: new_list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: het > wdt ? 4 : 7,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          child:CachedNetworkImage(
                            imageUrl:new_list[index]['sub_category_icon'],
                            imageBuilder: (context, url) => brand_ink_network_image_shape(url),
                            placeholder: (context, url) => brand_ink_asset_image_shape(),
                            errorWidget: (context, url, error) => brand_ink_asset_image_shape(),
                          )
                        ),
                      ),
                      5.heightBox,
                      Text(
                        new_list[index]['sub_category_name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )
                    ],
                  )
                      .box
                      .rounded
                      .color(new_list[index]["sub_category_selected"]
                          ? yellowColor
                          : whiteColor)
                      .make()
                      .onTap(() {
                    if (!brand_categories
                        .contains(new_list[index]['sub_category_name'])) {
                      new_list[index]["sub_category_selected"] =
                          !new_list[index]["sub_category_selected"];
                    }
                    if (new_list[index]["sub_category_selected"]) {
                      category_selection_list
                          .add(new_list[index]['sub_category_name']);
                    } else {
                      category_selection_list
                          .remove(new_list[index]['sub_category_name']);
                    }
                    setState(() {});
                  });
                }),
          ],
        ).box.color(whiteColor).padding(EdgeInsets.all(10)).make();
      }));

  void update_cat_list(value) {
    if (value.toString().length == 0) {
      new_list = categoryController.allsubCategorylist;
    } else {
      RxList l = [].obs;
      for (int i = 0; i < categoryController.allsubCategorylist.length; i++) {
        if (categoryController.allsubCategorylist[i]["sub_category_name"]
            .toLowerCase()
            .contains(value.toLowerCase())) {
          l.add(categoryController.allsubCategorylist[i]);
        }
      }
      new_list = l;
    }
  }

  showAlertDialog(BuildContext context) async => showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: new Text(
        'Are you sure?',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
      ),
      content: new Text(
        "Do you really want to Delete this Brand/Shop ?",
        style: TextStyle(fontSize: 14, color: darkBlueColor),
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: new Text('No'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => {
            Navigator.of(context).pop(),
            Navigator.of(context).pop(),
            branddocreference.doc(widget.brand_id).delete(),
            brand_img_docreference.refFromURL(brand_details["brand_icon"]).delete(),
            delete_all_products(),
            productsdocreference.where("brand_id",isEqualTo: widget.brand_id).get().then((value) async{
              for(var val in value.docs) await productsdocreference.doc(val.id).delete();
            }),
          },
          child: new Text('Yes'),
        ),
      ],
    ),
  );
  delete_all_products()async{
    QuerySnapshot querySnapshot = await productsdocreference
        .where("brand_id",isEqualTo: widget.brand_id)
        .limit(batchSize).get();
    while (querySnapshot.docs.isNotEmpty) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for(var val in querySnapshot.docs) batch.delete(productsdocreference.doc(val.id));
      await batch.commit();
      querySnapshot =await productsdocreference
          .where("brand_id",isEqualTo: widget.brand_id)
          .startAfterDocument(querySnapshot.docs.last).limit(batchSize).get();
    }
  }
  showAlertDialog2(BuildContext context,id) async => showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: new Text(
        'Are you sure?',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
      ),
      content: new Text(
        "Do you really want to Remove this Editor ?",
        style: TextStyle(fontSize: 14, color: darkBlueColor),
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: new Text('No'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () =>{
            if(brand_details['brand_admin']!=id){
              branddocreference.doc(widget.brand_id)
                  .update({"brand_editors":FieldValue.arrayRemove([id])}),
              brand_editors_id_list.remove(id),
             show_snackbar(context, sccs_removed_txt, yellowColor, darkBlueColor)
            }else{
            show_snackbar(context, edtr_remove_ntpsbl_txt, whiteColor, Colors.red)
            },
            Navigator.of(context).pop(),
          },
          child: new Text('Yes'),
        ),
      ],
    ),
  );
  showAlertDialog3(BuildContext context,idx,catname) async => showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: new Text(
        'Are you sure?',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
      ),
      content: new Text(
        "Do you really want to Remove this Category ?",
        style: TextStyle(fontSize: 14, color: darkBlueColor),
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: new Text('No'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () =>{
            if(brand_categories.length>1){
              branddocreference.doc(widget.brand_id)
                  .update({'brand_categories':FieldValue.arrayRemove([catname])}),
              prev_categories.removeAt(idx),
              show_snackbar(context, sccs_removed_cat_txt, yellowColor, darkBlueColor)
            }else{
              show_snackbar(context, last_cat_txt, whiteColor, Colors.red)
            },
            Navigator.of(context).pop(),
          },
          child: new Text('Yes'),
        ),
      ],
    ),
  );

update_data_in_database()async {
    if (_brandinfo_formkey.currentState!.validate() &&
        (brand_details["brand_icon"].length > 1 || image.length > 1)) {
      Navigator.of(context).pop();
      Reference reference = brand_img_docreference
          .ref()
          .child("brand_icon")
          .child(brand_name.text);
      try {
        String img_url;
        if (image.length > 1) {
          await reference.putData(image);
          img_url = await reference.getDownloadURL();
        } else {
          img_url = brand_details
          ["brand_icon"];
        }
        await branddocreference.doc(widget.brand_id).update({
          "brand_name": brand_name.text.trim(),
          'brand_name_lowercase': brand_name.text.toLowerCase(),
          "brand_editors":FieldValue.arrayUnion(editors_selection_list) ,
          'brand_editing_time': new DateTime.now()
              .microsecondsSinceEpoch
              .toString(),
          'brand_categories': FieldValue.arrayUnion(category_selection_list),
          "brand_icon": img_url.toString(),
          'brand_offer':  off_percent.text,
          'brand_division': selecteddivision,
          'brand_district': selecteddistrict,
          'brand_full_location':dtldlctn_txt.text,
        }).then((value)async{
          if (image.length > 1 || brand_name.value!=brand_details["brand_name"]||
              off_percent.text!=brand_details["brand_offer"]
          ) {
            QuerySnapshot querySnapshot = await productsdocreference
                .where("brand_name",isEqualTo:brand_details["brand_name"])
                .limit(batchSize).get();
            while (querySnapshot.docs.isNotEmpty) {
              WriteBatch batch = FirebaseFirestore.instance.batch();
              for(var val in querySnapshot.docs){
                if(image.length > 1)
                  batch.update(val.reference,{"brand_icon": img_url.toString()});
                if(brand_name.text!=brand_details["brand_name"])
                  batch.update(val.reference,{"brand_name": brand_name.text.trim()});
                if(off_percent.text!=brand_details["brand_offer"])
                batch.update(val.reference,
                    {"brand_offer":off_percent.text.trim(),
                     "brand_and_product_offer":(int.parse(off_percent.text)+int.parse(val.get("off_percent")))
                          .toStringAsFixed(0)
                    });
              }
              await batch.commit();
              querySnapshot =await productsdocreference
                  .where("brand_name",isEqualTo:brand_details["brand_name"]).startAfterDocument(querySnapshot.docs.last).limit(batchSize).get();
            }
          }
        });
        show_snackbar(context, sccs_edtt,
            yellowColor, darkBlueColor);
      } catch (e) {
        show_snackbar(context, e.toString(),
            whiteColor, Colors.red);
      }
    }
  }



}

