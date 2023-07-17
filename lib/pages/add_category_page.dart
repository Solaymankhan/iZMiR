
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izmir/consts/consts.dart';
import 'package:get/get.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/lists.dart';
import '../controllers/category_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/dont_have_any_data.dart';
import '../shapes/snack_bar.dart';


class add_category_page extends StatefulWidget {

  @override
  State<add_category_page> createState() => _add_category_pageState();
}

class _add_category_pageState extends State<add_category_page> {
  final category_controller categoryController=Get.find();
  var docCategoryReference = FirebaseFirestore.instance.collection("category");
  var docSubCategoryReference = FirebaseFirestore.instance.collection("sub_category");
  var firestore_storage_instance = FirebaseStorage.instance;
  Uint8List category_image_uint = Uint8List.fromList([0]);
  Uint8List selected_category_image_uint = Uint8List.fromList([0]);
  Uint8List subcategory_image_uint = Uint8List.fromList([0]);
  Uint8List selected_subcategory_image_uint = Uint8List.fromList([0]);
  String selectedval = seasons_list[0];
  RxString category_image_url="".obs,category_name="".obs,category_id="".obs;
  RxString selectedval2 = "".obs,subcategory_image="".obs,subcategory_name="".obs,
      subcategory_id="".obs,subcategory_off_percent="".obs;
  bool is_selected = false;
  final _addcategory_formkey = GlobalKey<FormState>();
  final _editcategory_formkey = GlobalKey<FormState>();
  final _addSubcategory_formkey = GlobalKey<FormState>();
  final _editSubcategory_formkey = GlobalKey<FormState>();
  var catNameController,SubcatNameController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 400), () async{
      await categoryController.get_category_data();
      await categoryController.get_subcategory_data(
          categoryController.allCategorylist
          [categoryController.selected_category_index.value]["category_id"]
      );
    });
    super.initState();
  }

  void dispose() {
    categoryController.selected_category_index.value=0;
    categoryController.selectedsubCategorylist.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    var wdt = (MediaQuery
        .of(context)
        .size
        .width);
    var het = (MediaQuery
        .of(context)
        .size
        .height);

    return Scaffold(
      body: Obx(()=>   SafeArea(
            child: categoryController.allCategorylist.isEmpty?
            CupertinoActivityIndicator(radius: 10)
            .box
            .alignCenter
            .make()
            :Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15),
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            height: 50,
                            margin: EdgeInsets.only(right: 10),
                            child: Material(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
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
                          add_category_txt,
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ).box.margin(EdgeInsets.only(bottom: 3)).make(),
                      ],
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          add_category_sheet(context);
                        },
                        child: Ink(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: lightGreyColor),
                            child: Icon(Icons.add)),
                      ),
                    ).box.margin(EdgeInsets.only(right: 15)).make()
                  ],
                ).box.padding(EdgeInsets.only(top: 5)).make(),
               Expanded(
                    child: Row(
                        children: [
                          Container(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: categoryController.allCategorylist.length,
                              itemBuilder: (context, index) {
                            return  Material(
                              color: categoryController.selected_category_index.value==index?textFieldGreyColor:Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: () async{
                                  categoryController.selected_category_index.value=index;
                                  categoryController.selectedsubCategorylist.clear();
                                  await categoryController.get_subcategory_data(
                                      categoryController.allCategorylist[index]["category_id"]
                                  );
                                },
                                child:
                                [CachedNetworkImage(
                                  imageUrl: categoryController.allCategorylist[index]["category_icon"],
                                  imageBuilder: (context, url)=>brand_ink_network_image_shape(url),
                                  placeholder: (context, url)=> brand_ink_asset_image_shape(),
                                  errorWidget: (context, url, error) =>  brand_ink_asset_image_shape(),
                                ),
                                  5.heightBox,
                                  Text(
                                    categoryController.allCategorylist[index]["category_name"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500
                                    ),
                                  )
                                ].column().paddingOnly(top: 10,bottom: 10),
                              ),
                            );
                            }),
                          ).box.color(lightGreyColor).width(wdt>600?150:90).make(),
                          Expanded(
                            child: [
                              Material(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(6),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: () {
                                    category_id.value=categoryController.allCategorylist
                                    [categoryController.selected_category_index.value]["category_id"];
                                    category_image_url.value=categoryController.allCategorylist
                                    [categoryController.selected_category_index.value]["category_icon"];
                                    category_name.value=categoryController.allCategorylist
                                    [categoryController.selected_category_index.value]["category_name"];

                                    edit_category_sheet(context);
                                  },
                                  child: [
                                    CachedNetworkImage(
                                    imageUrl: categoryController.allCategorylist
                                    [categoryController.selected_category_index.value]
                                    ["category_icon"],
                                    imageBuilder: (context, url)=>brand_network_image_shape(url),
                                    placeholder: (context, url)=>brand_asset_image_shape(),
                                    errorWidget: (context, url, error) =>brand_asset_image_shape(),
                                  ).marginOnly(right: 5),
                                    Text(
                                      categoryController.allCategorylist
                                      [categoryController.selected_category_index.value]
                                      ["category_name"],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ).expand(),
                                    Material(
                                      borderRadius: BorderRadius.circular(40),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(40),
                                        onTap: () {
                                          add_subcategory_sheet(context);
                                        },
                                        child: Ink(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(40),
                                                color: lightGreyColor),
                                            child: Icon(Icons.add)),
                                      ),
                                    )
                                  ].row(alignment: MainAxisAlignment.start)
                                      .box.border(color: textFieldGreyColor)
                                  .padding(EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2))
                                  .customRounded(BorderRadius.circular(6))
                                      .width(double.infinity).make(),
                                ),
                              ).marginOnly(left: 5),
                              Expanded(
                                child: categoryController.selectedsubCategorylist.isEmpty?
                                CupertinoActivityIndicator(radius: 10)
                                    .box
                                    .alignCenter
                                    .make()
                                    :GridView.builder(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: categoryController.selectedsubCategorylist.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 600 > wdt ? 3 : 7,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Material(
                                        borderRadius: BorderRadius.circular(6),
                                        color: whiteColor,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(6),
                                          onTap: () {
                                            subcategory_id.value=categoryController.selectedsubCategorylist
                                            [categoryController.selected_category_index.value]["sub_category_id"];
                                            subcategory_image.value=categoryController.selectedsubCategorylist
                                            [categoryController.selected_category_index.value]['sub_category_icon'];
                                            subcategory_name.value=categoryController.selectedsubCategorylist
                                            [categoryController.selected_category_index.value]['sub_category_name'];
                                            subcategory_off_percent.value=categoryController.selectedsubCategorylist
                                            [categoryController.selected_category_index.value]['sub_category_offer'];
                                            selectedval2=categoryController.selectedsubCategorylist
                                            [categoryController.selected_category_index.value]['sub_category_season'];
                                            edit_subcategory_sheet(context);
                                          },
                                          child:Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: categoryController.selectedsubCategorylist[index]['sub_category_icon'],
                                                imageBuilder: (context, url)=>brand_ink_network_image_shape(url),
                                                placeholder: (context, url)=> brand_ink_asset_image_shape(),
                                                errorWidget: (context, url, error) =>  brand_ink_asset_image_shape(),
                                              ),
                                              5.heightBox,
                                              Text(
                                                categoryController.selectedsubCategorylist[index]['sub_category_name'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                ),
                                              ).marginOnly(left: 5,right: 5)
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )].column(),
                          )
                        ],
                      ).marginOnly(left: 15,right: 15),
                  ),
              ],
            )
        ).color(whiteColor),
      ),
    );
  }

  Future add_category_sheet(context) =>
      showSlidingBottomSheet(context,
          builder: (context) =>
              SlidingSheetDialog(
                  duration: const Duration(milliseconds: 150),
                  snapSpec: SnapSpec(initialSnap: 0.9, snappings: [0.9]),
                  cornerRadius: 15,
                  scrollSpec: ScrollSpec(
                      physics: NeverScrollableScrollPhysics()),
                  builder:add_category_buildSheet));

  Widget add_category_buildSheet(context, state) =>
      Material(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Add category",
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

                                  category_image_uint = (await FlutterImageCompress
                                      .compressWithFile(
                                      img!.path,
                                      quality: 20))!;

                                  setState(() {});
                                },
                                child: Ink(
                                  height: 50,
                                  width: 50,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: new DecorationImage(
                                      image: category_image_uint.length > 1 ?
                                      MemoryImage(category_image_uint) : AssetImage(add_icon)
                                      as ImageProvider,
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
                          ],
                        ),
                        10.heightBox,
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            contentPadding: EdgeInsets.all(8),
                            labelText: "Category name",
                            prefixIcon: Icon(CupertinoIcons
                                .circle_grid_3x3_fill),
                          ),
                          maxLength: 20,
                          controller: catNameController,
                          validator: (value) {
                            return validatecategory(value!);
                          },
                        ),
                      ],
                    ),
                  ),
                  10.heightBox,
                  Material(
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () async {
                        if (_addcategory_formkey.currentState!.validate() &&
                            category_image_uint.length! > 1) {
                          Navigator.of(context).pop();
                          Reference reference = FirebaseStorage.instance
                              .ref()
                              .child("category_icon")
                              .child(catNameController.text);
                          try {
                            await reference.putData(category_image_uint);
                            String img_url = await reference.getDownloadURL();
                            docCategoryReference.add({
                              'category_icon': img_url.toString(),
                              'category_name': catNameController.text,
                              'category_adding_time': new DateTime.now().microsecondsSinceEpoch.toString(),
                            });
                            categoryController.get_category_data();
                            show_snackbar(
                                context, sccs_cat_add_txt, yellowColor,
                                darkBlueColor);
                          } catch (e) {
                            show_snackbar(context, e.toString(), whiteColor,
                                Colors.red);
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
                              "Save",
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
              ).box.padding(EdgeInsets.all(10)).make();
            },
          )
      );

  Future edit_category_sheet(context) =>
      showSlidingBottomSheet(context,
          builder: (context) => SlidingSheetDialog(
              duration: const Duration(milliseconds: 150),
              snapSpec: SnapSpec(initialSnap: 0.9, snappings: [0.9]),
              cornerRadius: 15,
              scrollSpec: ScrollSpec(physics: NeverScrollableScrollPhysics()),
              builder:edit_category_buildSheet));

  Widget edit_category_buildSheet(context, state) => Material(child: StatefulBuilder(
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
            key: _editcategory_formkey,
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
                            selected_category_image_uint =
                            (await FlutterImageCompress.compressWithFile(
                              img!.path,
                              quality: 20,
                              format: CompressFormat.jpeg,
                            ))!;
                            category_image_url.value="";
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
                            color: darkFontGreyColor,
                            fontWeight: FontWeight.bold),
                      ).box.margin(EdgeInsets.only(left: 10)).make(),
                    ],),
                    Material(
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          delete_category_AlertDialog(context);
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
                  initialValue: category_name.value,
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
                    category_name.value=value;
                  },
                  validator: (value) {
                    return validatecategory2(value!);
                  },
                ),
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
                if (_editcategory_formkey.currentState!.validate() &&
                    (selected_category_image_uint.length > 1 || category_image_url.value.length > 1)) {
                  Reference reference = FirebaseStorage.instance
                      .ref()
                      .child("category_icon")
                      .child(category_image_url.value);
                  try {
                    String img_url;
                    if(selected_category_image_uint.length > 1){
                      await reference.putData(selected_category_image_uint);
                      img_url = await reference.getDownloadURL();
                    }else{
                      img_url=category_image_url.value;
                    }
                    await docCategoryReference.doc(category_id.value)
                        .update({
                      'category_icon': img_url.toString(),
                      'category_name': category_name.value,
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

  Future add_subcategory_sheet(context) =>
      showSlidingBottomSheet(context,
          builder: (context) => SlidingSheetDialog(
              duration: const Duration(milliseconds: 150),
              snapSpec: SnapSpec(initialSnap: 0.9, snappings: [0.9]),
              cornerRadius: 15,
              scrollSpec: ScrollSpec(physics: NeverScrollableScrollPhysics()),
              builder:add_subcategory_buildSheet));

  Widget add_subcategory_buildSheet(context, state) =>
      Material(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Add Sub-category",
                      style: TextStyle(
                          fontSize: 14,
                          color: darkFontGreyColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  10.heightBox,
                  Form(
                    key: _addSubcategory_formkey,
                    child: Column(
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

                                  subcategory_image_uint = (await FlutterImageCompress
                                      .compressWithFile(
                                      img!.path,
                                      quality: 20))!;

                                  setState(() {});
                                },
                                child: Ink(
                                  height: 50,
                                  width: 50,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: new DecorationImage(
                                      image: subcategory_image_uint.length > 1 ?
                                      MemoryImage(subcategory_image_uint) : AssetImage(add_icon)
                                      as ImageProvider,
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
                          ],
                        ),
                        10.heightBox,
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            contentPadding: EdgeInsets.all(8),
                            labelText: "Sub-category name",
                            prefixIcon: Icon(CupertinoIcons
                                .circle_grid_3x3_fill),
                          ),
                          maxLength: 20,
                          controller: SubcatNameController,
                          validator: (value) {
                            return  validateSubcategory(value!);
                          },
                        ),
                        10.heightBox,
                        DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              contentPadding: EdgeInsets.all(8),
                              labelText: "Sub-category season",
                            ),
                            value: selectedval,
                            items: seasons_list
                                .map((e) =>
                                DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                                .toList(),
                            onChanged: (val) {
                              selectedval = val.toString();
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
                        if (_addSubcategory_formkey.currentState!.validate() &&
                            subcategory_image_uint.length! > 1) {
                          Navigator.of(context).pop();
                          Reference reference = FirebaseStorage.instance
                              .ref()
                              .child("sub_category_icon")
                              .child(SubcatNameController.text);
                          try {
                            await reference.putData(subcategory_image_uint);
                            String img_url = await reference.getDownloadURL();
                            docSubCategoryReference.add({
                              'category_id': categoryController.allCategorylist
                              [categoryController.selected_category_index.value]
                              ["category_id"],
                              'sub_category_icon': img_url.toString(),
                              'sub_category_name': SubcatNameController.text,
                              'sub_category_season': selectedval,
                              'sub_category_offer': "0",
                              'sub_category_clicked': 0,
                              'sub_category_adding_time': new DateTime.now().microsecondsSinceEpoch.toString(),
                            });
                            categoryController.get_category_data();
                            show_snackbar(
                                context, sccs_cat_add_txt, yellowColor,
                                darkBlueColor);
                          } catch (e) {
                            show_snackbar(context, e.toString(), whiteColor,
                                Colors.red);
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
                              "Save",
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
              ).box.padding(EdgeInsets.all(10)).make();
            },
          )
      );

  Future edit_subcategory_sheet(context) =>
      showSlidingBottomSheet(context,
          builder: (context) => SlidingSheetDialog(
              duration: const Duration(milliseconds: 150),
              snapSpec: SnapSpec(initialSnap: 0.9, snappings: [0.9]),
              cornerRadius: 15,
              scrollSpec: ScrollSpec(physics: NeverScrollableScrollPhysics()),
              builder:edit_subcategory_buildSheet));

  Widget edit_subcategory_buildSheet(context, state) => Material(child: StatefulBuilder(
    builder: (context, setState) {
      return Obx(()=> Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "Edit Sub-category",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          10.heightBox,
          Form(
            key: _editSubcategory_formkey,
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
                            selected_subcategory_image_uint =
                            (await FlutterImageCompress.compressWithFile(
                              img!.path,
                              quality: 20,
                              format: CompressFormat.jpeg,
                            ))!;
                            subcategory_image.value="";
                            setState(() {});
                          },
                          child: Ink(
                            height: 50,
                            width: 50,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: new DecorationImage(
                                image: get_image2(),
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
                            color: darkFontGreyColor,
                            fontWeight: FontWeight.bold),
                      ).box.margin(EdgeInsets.only(left: 10)).make(),
                    ],),
                    Material(
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          delete_category_AlertDialog(context);
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
                  initialValue: subcategory_name.value,
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
                    subcategory_name.value=value;
                  },
                  validator: (value) {
                    return validateSubcategory2(value!);
                  },
                ),
                10.heightBox,
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      contentPadding: EdgeInsets.all(8),
                      labelText:"Sub-category season",
                    ),
                    value: selectedval2.value,
                    items: seasons_list
                        .map((e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    ))
                        .toList(),
                    onChanged: (val) {
                      selectedval2.value = val.toString();
                    }),
                30.heightBox,
                TextFormField(
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                    initialValue: subcategory_off_percent.value,
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
                      subcategory_off_percent.value = val.length == 0 ? "0" : val.toString();
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
                if (_editSubcategory_formkey.currentState!.validate() &&
                    (selected_subcategory_image_uint.length > 1 || subcategory_image.value.length > 1)) {
                  Reference reference = FirebaseStorage.instance
                      .ref()
                      .child("category_icon")
                      .child(subcategory_name.value);
                  try {
                    String img_url;
                    if(selected_subcategory_image_uint.length > 1){
                      await reference.putData(selected_subcategory_image_uint);
                      img_url = await reference.getDownloadURL();
                    }else{
                      img_url=subcategory_image.value;
                    }
                    await docSubCategoryReference.doc(subcategory_id.value)
                        .update({
                      'sub_category_icon': img_url.toString(),
                      'sub_category_name': subcategory_name.value,
                      'sub_category_season': selectedval2.value,
                      'sub_category_offer': subcategory_off_percent.value,
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
    if (value.length >25) {
      return "Category name can't be more than 25 character";
    }
    return null;
  }
  String? validatecategory2(String value) {
    if (value.length == 0) {
      return "Category name can't be empty";
    }
    return null;
  }
  String? validateSubcategory(String value) {
    if (value.length == 0) {
      return "Sub-category name can't be empty";
    }
    if (value.length >25) {
      return "Sub-category name can't be more than 25 character";
    }
    return null;
  }
  String? validateSubcategory2(String value) {
    if (value.length == 0) {
      return "Sub-category name can't be empty";
    }
    return null;
  }
  get_image() => category_image_url.value.length > 1 ? NetworkImage(category_image_url.value):MemoryImage(selected_category_image_uint);
  get_image2() => subcategory_image.value.length > 1 ? NetworkImage(subcategory_image.value):MemoryImage(selected_subcategory_image_uint);

  delete_category_AlertDialog(BuildContext context) async =>
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
                docCategoryReference.doc(category_id.value).delete(),
                firestore_storage_instance.refFromURL(category_image_url.value).delete(),
                show_snackbar(context, cat_dlt_sccs_txt, yellowColor, darkBlueColor),
                categoryController.get_category_data(),
              },
              child: new Text('Yes'),
            ),
          ],
        ),
      );
  delete_Subcategory_AlertDialog(BuildContext context) async =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: new Text(
            'Are you sure?',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
          ),
          content: new Text(
            "Do you really want to Delete this Sub-category ?",
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
                docSubCategoryReference.doc(subcategory_id.value).delete(),
                firestore_storage_instance.refFromURL(subcategory_image.value).delete(),
                show_snackbar(context, cat_dlt_sccs_txt, yellowColor, darkBlueColor),
                categoryController.get_category_data(),
              },
              child: new Text('Yes'),
            ),
          ],
        ),
      );
}
