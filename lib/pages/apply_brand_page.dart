import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izmir/pages/view_category_items.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/images.dart';
import '../consts/lists.dart';
import '../consts/strings.dart';
import '../controllers/brands_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/drawer_controller.dart';
import '../controllers/loading_dialogue_controller.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/snack_bar.dart';

final category_controller categoryController = Get.find();
final drawer_controller drawerController = Get.find();
final brands_controller brandController = Get.find();
final loading_dialogue_controller loadingController = Get.find();

class apply_brand_page extends StatefulWidget {
  apply_brand_page({Key? key}) : super(key: key);

  @override
  State<apply_brand_page> createState() => _apply_brand_page_pageState();
}

class _apply_brand_page_pageState extends State<apply_brand_page> {
  var selectedcategory = categoryController.allsubCategorylist[0],
      selecteddivision = division_list[0],
      selecteddistrict = "";
  var docbrandreference = FirebaseFirestore.instance.collection("brands");
  Uint8List image = Uint8List.fromList([0]);
  final _brandName_formkey = GlobalKey<FormState>();
  var dtldlctnController = TextEditingController();
  var brandNameController = TextEditingController();
  var wdt,het,from = "edit",phone_number="";
  List dstrct_lst = [];
  late BuildContext context_for_snakbar;
  var allbrandslist = [].obs, mybrandlist = [].obs;

  @override
  initState() {
    super.initState();
    change_district("1");
  }

  @override
  Widget build(BuildContext context) {
    wdt = (MediaQuery.of(context).size.width);
    het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              bar_with_back_button(context,apply_for_brand_txt),
              Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child:Form(
                      key: _brandName_formkey,
                      child:
                      Obx(() => Column(
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
                                    child: Ink(
                                      height: 50,
                                      width: 50,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        image: new DecorationImage(
                                          image: image.length > 1
                                              ? MemoryImage(image)
                                              : AssetImage(add_icon) as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
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
                            ),
                            10.heightBox,
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(),
                                labelText: "Brand/Shop name",
                                prefixIcon: Icon(CupertinoIcons.music_house),
                              ),
                              maxLength: 25,
                              controller: brandNameController,
                              validator: (value) {
                                return validatebrandname(value!);
                              },
                            ),
                            10.heightBox,
                            TextFormField(
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
                              onChanged:  (value) {
                                phone_number=value.toString();
                              },
                              validator: (value) {
                                return validatePhone(value!);
                              },
                            ),
                            10.heightBox,
                            DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    labelText: "Initial Category",
                                    contentPadding: EdgeInsets.only(left: 15, right: 5),
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedcategory,
                                  items: categoryController.allsubCategorylist
                                      .map((e) => DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: new BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(100),
                                            image: new DecorationImage(
                                              image: e['sub_category_icon']
                                                  .toString()
                                                  .length ==
                                                  0
                                                  ? AssetImage(add_icon)
                                                  : NetworkImage(
                                                  e['sub_category_icon'])
                                              as ImageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                            .box
                                            .margin(EdgeInsets.only(right: 10))
                                            .make(),
                                        Text(e['sub_category_name'])
                                      ],
                                    ),
                                    value: e,
                                  ))
                                      .toList(),
                                  onChanged: (val) {
                                    selectedcategory = val;
                                  },
                                ),
                            30.heightBox,
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
                                    setState(() {
                                      selecteddivision = val.toString();
                                      change_district(
                                          (division_list.indexOf(selecteddivision) + 1)
                                              .toString());
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
                                  ))
                                      .toList(),
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
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(),
                                labelText: "Detailed Location (Comma separated)",
                                prefixIcon: Icon(CupertinoIcons.placemark),
                              ),
                              maxLength: 40,
                              controller: dtldlctnController,
                              validator: (value) {
                                return validatefulladdress(value!);
                              },
                            ),
                            10.heightBox,
                            Material(
                              borderRadius: BorderRadius.circular(6),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: () {
                                  save_data(context);
                                },
                                child: Ink(
                                  height: 40,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: darkBlueColor),
                                  child: Center(
                                    child: Text(
                                      "Apply",
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
                            30.heightBox,
                          ],
                        ).marginOnly(left: 15,right: 15),
                      ),
                    )
                  )),
            ],
          )
      ).color(whiteColor),
    );
  }

  change_district(indx) {
    dstrct_lst = [];
    district_list.forEach((key, value) {
      if (indx == value) {
        dstrct_lst.add(key);
      }
    });
    selecteddistrict = dstrct_lst[0];
  }

  save_data(context) async {
    if (_brandName_formkey.currentState!.validate() && image.length! > 1) {
      Navigator.pop(context);
      final QuerySnapshot result = await docbrandreference
          .where('brand_name_lowercase',
          isEqualTo: brandNameController.text.toLowerCase())
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        Reference reference = FirebaseStorage.instance
            .ref()
            .child("brand_icon")
            .child(brandNameController.text)
            .child(new DateTime.now().microsecondsSinceEpoch.toString());
        try {
          await reference.putData(image);
          String img_url = await reference.getDownloadURL();
          List brand_editors_list = [drawerController.pref_userId.value];
          List brand_category_list = [selectedcategory["category_name"]];
          await docbrandreference.add({
            'brand_icon': img_url.toString(),
            'brand_name': brandNameController.text,
            'brand_name_lowercase': brandNameController.text.toLowerCase(),
            'brand_offer': "0",
            'brand_division': selecteddivision,
            'brand_district': selecteddistrict,
            'brand_full_location': dtldlctnController.text,
            'brand_status': deactivated,
            'brand_likes': 0,
            "total_products":0,
            "today_sells":0,
            "total_sells":0,
            "total_orders":0,
            "total_cancels":0,
            "total_delivered":0,
            "total_returns":0,
            'brand_contact_number': phone_number,
            'brand_clicked': 0,
            'brand_verified': "not_verified",
            "brand_banner_img": "",
            'brand_admin': drawerController.pref_userId.value.trim(),
            'brand_categories': brand_category_list,
            'brand_editors': FieldValue.arrayUnion(brand_editors_list),
            'brand_adding_time':
            new DateTime.now().microsecondsSinceEpoch.toString(),
          });
          show_snackbar(context_for_snakbar, sccs_Applied_txt, yellowColor, darkBlueColor);
        } catch (e) {
          show_snackbar(context_for_snakbar, e.toString(), whiteColor, Colors.red);
        }
      } else {
        show_snackbar(context_for_snakbar, same_brand_exist_txt, whiteColor, Colors.red);
      }
    }
  }

  String? validatebrandname(String value) {
    if (value.length == 0) {
      return "Brand name can't be empty";
    }
    if (value.length > 25) {
      return "Brand name can't be more than 25 character";
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
}
