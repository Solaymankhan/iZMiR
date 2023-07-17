import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izmir/shapes/snack_bar.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/lists.dart';
import '../controllers/category_controller.dart';
import '../pages/view_category_items.dart';
import 'all_product_network_image_shape.dart';

final category_controller categoryController=Get.find();
var category_img_docreference=FirebaseStorage.instance;
var docimgreference = FirebaseFirestore.instance.collection("category");
Uint8List selected_image = Uint8List.fromList([0]);
RxString selectedval = "".obs,image="".obs,name="".obs,time="".obs,cat_id="".obs,off_percent="".obs;
final _addcategory_formkey = GlobalKey<FormState>();


Widget category_button_shape(all_categorylist,id, het, wdt, from) {
  return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: all_categorylist.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: het > wdt ? 4 : 7,
      ),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Material(
              borderRadius: BorderRadius.circular(100),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  cat_id.value=id[index];
                  image.value=all_categorylist[index]["category_icon"];
                  selectedval.value=all_categorylist[index]["category_for"];
                  name.value=all_categorylist[index]["category_name"];
                  off_percent.value=all_categorylist[index]["category_offer"];
                  time.value=all_categorylist[index]["category_adding_time"];
                  if (from == "edit") {
                    profile_settigs_sheet(context);
                  } else {
                    Get.to(() => view_category_items(category_name: name.value,));
                  }
                },
                child:
                CachedNetworkImage(
                  imageUrl: all_categorylist[index]["category_icon"],
                  imageBuilder: (context, url)=>brand_ink_network_image_shape(url),
                  placeholder: (context, url)=> brand_ink_asset_image_shape(),
                  errorWidget: (context, url, error) =>  brand_ink_asset_image_shape(),
                ),
              ),
            ),
            5.heightBox,
            Text(
              all_categorylist[index]["category_name"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                  fontWeight: FontWeight.w500
              ),
            ).box.padding(EdgeInsets.only(left: 10,right: 10)).make()
          ],
        );
      });
}

Future profile_settigs_sheet(context) =>
    showSlidingBottomSheet(context,
        builder: (context) => SlidingSheetDialog(
            duration: const Duration(milliseconds: 150),
            snapSpec: SnapSpec(initialSnap: 0.9, snappings: [0.9]),
            cornerRadius: 15,
            scrollSpec: ScrollSpec(physics: NeverScrollableScrollPhysics()),
            builder: buildSheet));

Widget buildSheet(context, state) => Material(child: StatefulBuilder(
      builder: (context, setState) {
        return Obx(()=> Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Edit category",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              10.heightBox,
              Form(
                key: _addcategory_formkey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Material(
                            borderRadius: BorderRadius.circular(100),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () async {
                                ImagePicker imagePicker = ImagePicker();
                                XFile? img = await imagePicker.pickImage(
                                    source: ImageSource.gallery);
                                selected_image =
                                (await FlutterImageCompress.compressWithFile(
                                  img!.path,
                                  quality: 20,
                                  format: CompressFormat.jpeg,
                                ))!;
                                image.value="";
                                setState(() {});
                              },
                              child: Ink(
                                height: 50,
                                width: 50,
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: new DecorationImage(
                                    image: get_image(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Icon",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ).box.margin(EdgeInsets.only(left: 10)).make(),
                        ],),
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
                        )
                      ],
                    ).box.margin(EdgeInsets.only(left: 5,right: 5)).make(),
                    10.heightBox,
                    TextFormField(
                      initialValue: name.value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        contentPadding: EdgeInsets.all(8),
                        labelText: "Category name",
                        prefixIcon: Icon(CupertinoIcons.circle_grid_3x3_fill),
                      ),
                      maxLength: 20,
                      onChanged: (value) {
                        name.value=value;
                      },
                      validator: (value) {
                        return validatecategory(value!);
                      },
                    ),
                    10.heightBox,
                    DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: EdgeInsets.all(8),
                          labelText: "Category For",
                          prefixIcon: Icon(CupertinoIcons.person),
                        ),
                        value: selectedval.value,
                        items: seasons_list
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          selectedval.value = val.toString();
                        }),
                    30.heightBox,
                    TextFormField(
                        autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                        initialValue: off_percent.value,
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
                        maxLength: 2,
                        onChanged: (val) {
                          off_percent.value = val.length == 0 ? "0" : val.toString();
                        }),
                  ],
                ),
              ),
              10.heightBox,
              Material(
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () async {
                    Navigator.of(context).pop();
                    if (_addcategory_formkey.currentState!.validate() &&
                        (selected_image.length > 1 || image.value.length > 1)) {
                      Reference reference = FirebaseStorage.instance
                          .ref()
                          .child("category_icon")
                          .child(name.value);
                      try {
                        String img_url;
                        if(selected_image.length > 1){
                          await reference.putData(selected_image);
                          img_url = await reference.getDownloadURL();
                        }else{
                          img_url=image.value;
                        }
                        await docimgreference.doc(cat_id.value)
                            .update({
                              'category_icon': img_url.toString(),
                              'category_name': name.value,
                              'category_for': selectedval.value,
                              'category_offer': off_percent.value,
                              'last_editing_time': new DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString(),
                            });
                        categoryController.get_category_data();
                        show_snackbar(
                            context, sccs_cat_edit_txt, yellowColor, darkBlueColor);
                      } catch (e) {
                        show_snackbar(
                            context, e.toString(), whiteColor, Colors.red);
                      }
                    }
                  },
                  child: Ink(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: darkBlueColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Save changes",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              color: yellowColor,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              30.heightBox,
            ],
          ).box.padding(EdgeInsets.all(10)).make(),
        );
      },
    ));

String? validatecategory(String value) {
  if (value.length == 0) {
    return "Category name can't be empty";
  }
  return null;
}

get_image() => image.value.length > 1 ? NetworkImage(image.value):MemoryImage(selected_image);

showAlertDialog(BuildContext context) async =>
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: new Text(
          'Are you sure?',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
        ),
        content: new Text(
          "Do you really want to Delete this category ?",
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
              docimgreference.doc(cat_id.value).delete(),
              category_img_docreference.refFromURL(image.value).delete(),
              show_snackbar(context, cat_dlt_sccs_txt, yellowColor, darkBlueColor),
              categoryController.get_category_data(),
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
