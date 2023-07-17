import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/colors.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/lists.dart';
import '../consts/strings.dart';
import '../controllers/drawer_controller.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/snack_bar.dart';

class profile_setting_page extends StatefulWidget {
  profile_setting_page({Key? key}) : super(key: key);

  @override
  State<profile_setting_page> createState() => _profile_setting_pageState();
}

class _profile_setting_pageState extends State<profile_setting_page> {
  final drawer_controller drawerController = Get.find();

  final _name_formkey = GlobalKey<FormState>();
  final _email_formkey = GlobalKey<FormState>();
  final _password_formkey = GlobalKey<FormState>();
  final _address_formkey = GlobalKey<FormState>();
  var name_controller, email_controller, address_controller;
  var prevPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var newPasswordController_2 = TextEditingController();
  var get_password = "";

  late BuildContext new_contex;
  var newPassword_temp = "".obs;
  RxBool _isVisible_1 = false.obs;
  RxBool _isVisible_2 = false.obs;
  RxBool _isVisible_3 = false.obs;
  var sheet_list;
  String selecteddistrict = "", selecteddivision = "";
  List dstrct_lst = [];

  @override
  initState() {
    sheet_list = [
      buildSheet_0,
      buildSheet_1,
      buildSheet_2,
      buildSheet_3,
      buildSheet_4
    ];
    name_controller =
        TextEditingController(text: drawerController.pref_info["name"]);
    email_controller =
        TextEditingController(text: drawerController.pref_info["email"]);
    address_controller =
        TextEditingController(text: drawerController.pref_info["address"]);
    selecteddivision = drawerController.pref_info["division"];
    change_district((division_list.indexOf(selecteddivision) + 1).toString());
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

  @override
  void dispose() {
    name_controller.text = drawerController.pref_info["name"];
    email_controller.text = drawerController.pref_info["email"];
    address_controller.text = drawerController.pref_info["address"];
    prevPasswordController.text = "";
    newPasswordController.text = "";
    newPasswordController_2.text = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    new_contex = context;
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          bar_with_back_button(context,profile_setting),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () {
                        profile_settigs_sheet(context, 0, sheet_list);
                      },
                      child: Ink(
                        height: 50,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: lightGreyColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.profile_circled),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Name",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: BlackColor),
                                )
                              ],
                            ),
                            Text(
                              drawerController
                                          .pref_info.value["name"].length >
                                      15
                                  ? drawerController.pref_info.value["name"]
                                          .substring(0, 15) +
                                      "..."
                                  : drawerController.pref_info.value["name"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 14, color: BlackColor),
                            ).box.margin(EdgeInsets.only(right: 10)).make()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: textFieldGreyColor,
                    height: 1,
                    margin: EdgeInsets.only(left: 10, right: 10),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () {
                        profile_settigs_sheet(context, 1, sheet_list);
                      },
                      child: Ink(
                        height: 50,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: lightGreyColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.mail),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Email",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: BlackColor),
                                )
                              ],
                            ),
                            Text(
                              drawerController
                                          .pref_info.value["email"].length >
                                      15
                                  ? drawerController.pref_info.value["email"]
                                          .substring(0, 15) +
                                      "..."
                                  : drawerController.pref_info.value["email"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 14, color: BlackColor),
                            ).box.margin(EdgeInsets.only(right: 10)).make()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: textFieldGreyColor,
                    height: 1,
                    margin: EdgeInsets.only(left: 10, right: 10),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () {
                        profile_settigs_sheet(context, 2, sheet_list);
                      },
                      child: Ink(
                        height: 50,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: lightGreyColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.placemark),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Address",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: BlackColor),
                                )
                              ],
                            ),
                            Text(
                              "${drawerController.pref_info["district"]}, "
                                              "${drawerController.pref_info["division"]}, "
                                              "Bangladesh"
                                          .length >
                                      15
                                  ? "${drawerController.pref_info["district"]}, "
                                              "${drawerController.pref_info["division"]}, "
                                              "Bangladesh"
                                          .substring(0, 15) +
                                      "..."
                                  : "${drawerController.pref_info["district"]}, "
                                      "${drawerController.pref_info["division"]}, "
                                      "Bangladesh",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 14, color: BlackColor),
                            ).box.margin(EdgeInsets.only(right: 10)).make()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: textFieldGreyColor,
                    height: 1,
                    margin: EdgeInsets.only(left: 10, right: 10),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () {
                        profile_settigs_sheet(context, 3, sheet_list);
                      },
                      child: Ink(
                        height: 50,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: lightGreyColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.placemark),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Full address",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: BlackColor),
                                )
                              ],
                            ),
                            Text(
                              drawerController.pref_info["address"].length >
                                      15
                                  ? drawerController.pref_info["address"]
                                          .substring(0, 15) +
                                      "..."
                                  : drawerController.pref_info["address"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 14, color: BlackColor),
                            ).box.margin(EdgeInsets.only(right: 10)).make()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: textFieldGreyColor,
                    height: 1,
                    margin: EdgeInsets.only(left: 10, right: 10),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () {
                        profile_settigs_sheet(context, 4, sheet_list);
                      },
                      child: Ink(
                        height: 50,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: lightGreyColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.lock),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Password",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: BlackColor),
                                )
                              ],
                            ),
                            Icon(CupertinoIcons.eye_slash)
                                .box
                                .margin(EdgeInsets.only(right: 20))
                                .make()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ).box.margin(EdgeInsets.only(left: 15,right: 15)).make(),
            ),
          ),
        ]).color(whiteColor),
      ),
    );
  }

  Future profile_settigs_sheet(context, index, sheet_list) =>
      showSlidingBottomSheet(context,
          builder: (context) => SlidingSheetDialog(
              duration: const Duration(milliseconds: 150),
              snapSpec: SnapSpec(initialSnap: 0.9, snappings: [0.9]),
              cornerRadius: 15,
              scrollSpec: ScrollSpec(physics: NeverScrollableScrollPhysics()),
              builder: sheet_list[index]));

  Widget buildSheet_0(context, state) => Material(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                "Name",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            10.heightBox,
            Form(
              key: _name_formkey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  labelText: "Name",
                  prefixIcon: Icon(CupertinoIcons.profile_circled),
                ),
                maxLength: 20,
                controller: name_controller,
                validator: (value) {
                  return validateName(value!);
                },
              ),
            ),
            10.heightBox,
            Material(
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  if (_name_formkey.currentState!.validate()) {
                    Navigator.of(context).pop();
                    save_to_database("name", name_controller.text.trim());
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
            30.heightBox
          ],
        ).box.padding(EdgeInsets.all(10)).make(),
      );

  Widget buildSheet_1(context, state) => Material(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                "Email",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            10.heightBox,
            Form(
              key: _email_formkey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  labelText: "Email",
                  prefixIcon: Icon(CupertinoIcons.mail),
                ),
                maxLength: 40,
                controller: email_controller,
                validator: (value) {
                  return validateEmail(value!);
                },
              ),
            ),
            10.heightBox,
            Material(
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  if (_email_formkey.currentState!.validate()) {
                    Navigator.of(context).pop();
                    save_to_database("email", email_controller.text.trim());
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
            30.heightBox
          ],
        ).box.padding(EdgeInsets.all(10)).make(),
      );

  Widget buildSheet_2(context, state) => Material(
        child: StatefulBuilder(builder: (BuildContext context, setState) {
          return Column(
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
                    value: selecteddivision,
                    items: division_list
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      selecteddivision = val.toString();
                      change_district(
                          (division_list.indexOf(selecteddivision) + 1)
                              .toString());
                      setState(() {});
                    },
                  ),
                  10.heightBox,
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
                ],
              ),
              10.heightBox,
              Material(
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () async {
                    Navigator.of(context).pop();
                    save_to_database("division", selecteddivision);
                    save_to_database("district", selecteddistrict);
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
              30.heightBox
            ],
          ).box.padding(EdgeInsets.all(10)).make();
        }),
      );

  Widget buildSheet_3(context, state) => Material(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                "Full address",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            10.heightBox,
            Form(
              key: _address_formkey,
              child: TextFormField(
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
                controller: address_controller,
                validator: (value) {
                  return validateaddress(value!);
                },
              ),
            ),
            10.heightBox,
            Material(
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  if (_address_formkey.currentState!.validate()) {
                    Navigator.of(context).pop();
                    save_to_database("address", address_controller.text.trim());
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
            30.heightBox
          ],
        ).box.padding(EdgeInsets.all(10)).make(),
      );

  Widget buildSheet_4(context, state) => Material(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                "Password",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            10.heightBox,
            Form(
              key: _password_formkey,
              child: Column(
                children: [
                  Obx(
                    () => TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: !_isVisible_1.value,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            _isVisible_1.value = !_isVisible_1.value;
                          },
                          icon: _isVisible_1.value
                              ? Icon(
                                  Icons.visibility,
                                  color: darkBlueColor,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                        ),
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        labelText: "Previous password",
                        prefixIcon: Icon(CupertinoIcons.lock),
                      ),
                      maxLength: 20,
                      controller: prevPasswordController,
                      validator: (value) {
                        return validatePrevPassword(value!);
                      },
                    ),
                  ),
                  10.heightBox,
                  Obx(
                    () => TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: !_isVisible_2.value,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            _isVisible_2.value = !_isVisible_2.value;
                          },
                          icon: _isVisible_2.value
                              ? Icon(
                                  Icons.visibility,
                                  color: darkBlueColor,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                        ),
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        labelText: "New password",
                        prefixIcon: Icon(CupertinoIcons.lock),
                      ),
                      maxLength: 20,
                      controller: newPasswordController,
                      validator: (value) {
                        return validateNewPassword(value!);
                      },
                    ),
                  ),
                  10.heightBox,
                  Obx(
                    () => TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: !_isVisible_3.value,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            _isVisible_3.value = !_isVisible_3.value;
                          },
                          icon: _isVisible_3.value
                              ? Icon(
                                  Icons.visibility,
                                  color: darkBlueColor,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                        ),
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        labelText: "Re-enter New password",
                        prefixIcon: Icon(CupertinoIcons.lock),
                      ),
                      maxLength: 20,
                      controller: newPasswordController_2,
                      validator: (value) {
                        return validateNewPassword_2(value!);
                      },
                    ),
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
                  if (_password_formkey.currentState!.validate()) {
                    Navigator.of(context).pop();
                    DocumentReference documentReference =
                        await FirebaseFirestore.instance
                            .collection(drawerController.pref_info["account_type"])
                            .doc(drawerController.pref_userId.value);
                    await documentReference.get().then((value){
                      if (value.get("password").compareTo(sha1
                          .convert(utf8.encode(prevPasswordController.text))
                          .toString()) == 0) {
                        documentReference.update({
                          "password": sha1
                              .convert(utf8.encode(newPasswordController_2.text))
                              .toString()
                        });
                        show_snackbar(
                            context, sccs_cngd_pas, yellowColor, darkBlueColor);
                      } else {
                        show_snackbar(
                            context, prv_pswrd_incrct, whiteColor, Colors.red);
                      }
                    });
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
            30.heightBox
          ],
        ).box.padding(EdgeInsets.all(10)).make(),
      );

  save_to_database(field_name, field_value) async {
    await FirebaseFirestore.instance
        .collection(drawerController.pref_info["account_type"])
        .doc(drawerController.pref_userId.value)
        .update({field_name: field_value}).then((value) {
      drawerController.pref_info[field_name] = field_value;
      drawerController.saveProfileInfo(drawerController.pref_info.value);
      print(drawerController.pref_info[field_name]);
      show_snackbar(new_contex, sccs_edtt, yellowColor, darkBlueColor);
    }).onError((e, stackTrace) =>
            show_snackbar(new_contex, e.toString(), whiteColor, Colors.red));
  }

  String? validateName(String value) {
    if (value.length == 0) {
      return "Name can't be empty";
    }
    return null;
  }

  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Provide valid email";
    }
    return null;
  }

  String? validateaddress(String value) {
    if (value.length == 0) {
      return "Address can't be empty";
    }
    return null;
  }

  String? validatePrevPassword(String value) {
    if (value.length < 8) {
      return "Password must be of 8 characters";
    }
    return null;
  }

  String? validateNewPassword(String value) {
    newPassword_temp.value = value;
    if (value.length < 8) {
      return "Password must be of 8 characters";
    }
    return null;
  }

  String? validateNewPassword_2(String value) {
    if (newPassword_temp.value != value) {
      return "Password doesn't match with previous one";
    }
    return null;
  }
}
