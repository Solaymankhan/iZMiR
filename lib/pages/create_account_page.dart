
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/lists.dart';
import '../controllers/create_account_form_validation_controller.dart';
import '../controllers/loading_dialogue_controller.dart';
import '../controllers/phone_auth_controller.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/loading_page.dart';
import '../shapes/snack_bar.dart';
import 'varify_otp_page.dart';

class create_account_page extends StatefulWidget {
  create_account_page({Key? key, this.comming_from}) : super(key: key);
  final String? comming_from;

  @override
  State<create_account_page> createState() => _create_account_pageState();
}

class _create_account_pageState extends State<create_account_page> {
  final formvalidationController =
      Get.put(create_account_form_validation_controller());
  final phone_auth_cntrlr = Get.put(phone_auth_controller());
  final loading_dialogue_controller loadingController = Get.find();
  bool sh_hvant = false;
  List dstrct_lst = [];
  String selecteddistrict="",selecteddivision = "";

  @override
  void dispose() {
    formvalidationController.nameController.text = "";
    formvalidationController.phoneController.text = "";
    formvalidationController.emailController.text = "";
    formvalidationController.addressController.text = "";
    formvalidationController.passwordController.text = "";
    formvalidationController.passwordController_2.text = "";
    super.dispose();
  }
  @override
  initState() {
    selecteddivision = division_list[0];
    formvalidationController.divisionValue=selecteddivision;
    change_district("1");
  }

  @override
  Widget build(BuildContext context) {
    RxBool _isVisiblepassword = false.obs;
    RxBool _isVisiblepassword_2 = false.obs;
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus=FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              bar_with_back_button(context,widget.comming_from == users
                  ? create_account
                  : aply_fr_acnt_txt),
              Flexible(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: formvalidationController.create_account_FormKey,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: het > wdt ? het * 0.13 : wdt * 0.13,
                          child: Image.asset(widget.comming_from == users
                              ? izmir_icon_with_slogan
                              : professional_icon),
                        ),
                        5.heightBox,
                        Text(
                          widget.comming_from == users
                              ? create_account_slogan
                              : apply_slogan,
                          style: TextStyle(
                              fontSize: 13,
                              color: darkBlueColor,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          width: wdt < 800 ? double.infinity : wdt * 0.5,
                          child: Column(
                            children: [
                              20.heightBox,
                              place_picker(),
                              30.heightBox,
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  labelText: "Full Name",
                                  prefixIcon: Icon(Icons.account_circle),
                                ),
                                maxLength: 20,
                                controller:
                                    formvalidationController.nameController,
                                onSaved: (value) {
                                  formvalidationController.name = value!;
                                },
                                validator: (value) {
                                  return formvalidationController
                                      .validateName(value!);
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
                                  labelText: "Phone",
                                  prefixIcon: Icon(Icons.phone),
                                ),
                                maxLength: 11,
                                keyboardType: TextInputType.number,
                                controller:
                                    formvalidationController.phoneController,
                                onSaved: (value) {
                                  formvalidationController.phone = value!;
                                },
                                validator: (value) {
                                  return formvalidationController
                                      .validatePhone(value!);
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
                                  labelText: "Email",
                                  prefixIcon: Icon(Icons.email),
                                ),
                                maxLength: 40,
                                controller:
                                    formvalidationController.emailController,
                                onSaved: (value) {
                                  formvalidationController.email = value!;
                                },
                                validator: (value) {
                                  return formvalidationController
                                      .validateEmail(value!);
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
                                  labelText: "Full address (Comma separated)",
                                  prefixIcon: Icon(Icons.location_on),
                                ),
                                maxLength: 40,
                                controller:
                                    formvalidationController.addressController,
                                onSaved: (value) {
                                  formvalidationController.address = value!;
                                },
                                validator: (value) {
                                  return formvalidationController
                                      .validateaddress(value!);
                                },
                              ),
                              10.heightBox,
                              Obx(
                                () => TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  obscureText: !_isVisiblepassword.value,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _isVisiblepassword.value =
                                            !_isVisiblepassword.value;
                                      },
                                      icon: _isVisiblepassword.value
                                          ? Icon(
                                              Icons.visibility,
                                              color: darkBlueColor,
                                            )
                                          : Icon(
                                              Icons.visibility_off,
                                              color: Colors.grey,
                                            ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    labelText: "Password",
                                    prefixIcon: Icon(Icons.lock),
                                  ),
                                  maxLength: 20,
                                  controller:
                                      formvalidationController.passwordController,
                                  onSaved: (value) {
                                    formvalidationController.password = value!;
                                  },
                                  validator: (value) {
                                    return formvalidationController
                                        .validatePassword(value!);
                                  },
                                ),
                              ),
                              10.heightBox,
                              Obx(
                                () => TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  obscureText: !_isVisiblepassword_2.value,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _isVisiblepassword_2.value =
                                            !_isVisiblepassword_2.value;
                                      },
                                      icon: _isVisiblepassword_2.value
                                          ? Icon(
                                              Icons.visibility,
                                              color: darkBlueColor,
                                            )
                                          : Icon(
                                              Icons.visibility_off,
                                              color: Colors.grey,
                                            ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    labelText: "Re-enter password",
                                    prefixIcon: Icon(Icons.lock),
                                  ),
                                  maxLength: 20,
                                  controller: formvalidationController
                                      .passwordController_2,
                                  onSaved: (value) {
                                    formvalidationController.password_2 = value!;
                                  },
                                  validator: (value) {
                                    return formvalidationController
                                        .validatePassword_2(value!);
                                  },
                                ),
                              ),
                              30.heightBox,
                            ],
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(6),
                          child: InkWell(
                            onTap: () async {
                              if (formvalidationController.checkCreateAccount()) {
                                  have_account(context);
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: darkBlueColor,
                              ),
                              height: 40.0,
                              width: 200.0,
                              child: Text(
                                widget.comming_from == users
                                    ? register_txt
                                    : apply_txt,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: yellowColor,
                                    fontWeight: FontWeight.w500),
                              ).box.alignCenter.make(),
                            ),
                          ),
                        ),
                        30.heightBox,
                      ],
                    ).box.padding(EdgeInsets.only(right: 15, left: 15)).make(),
                  ),
                ),
              )
            ],
          ),
        ).box.color(whiteColor).make(),
      ),
    );
  }

  Future have_account(context) async {
    String phone_number = '${"+88" + formvalidationController.phone}'.trim();
    loadingController.show_dialogue(context);
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(widget.comming_from!)
        .where("phone", isEqualTo: phone_number)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length != 0) {
      loadingController.close_dialogue(context);
      show_snackbar(context, have_account_txt, whiteColor, Colors.red);
    } else {
      phone_auth_cntrlr.phone_auth(phone_number);
      loadingController.close_dialogue(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  varify_otp_page(comming_from: widget.comming_from)));
    }
  }

  change_district(indx) {
    dstrct_lst = [];
    district_list.forEach((key, value) {
      if (indx == value) {
        dstrct_lst.add(key);
      }
    });
    selecteddistrict = dstrct_lst[0];
    formvalidationController.districtValue=selecteddistrict;
  }

  Widget place_picker(){
    return Column(children: [
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
          change_district((division_list.indexOf(selecteddivision) + 1).toString());
          formvalidationController.divisionValue=selecteddivision;
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
          formvalidationController.districtValue=selecteddistrict;
        },
        validator: (value) {
          if (value.toString().length == 0)
            return "District can't be empty";
        },
      ),
    ],);
  }

}

