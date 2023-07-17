import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izmir/Home.dart';
import 'package:izmir/pages/professional_login_page.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/colors.dart';
import '../consts/images.dart';
import '../consts/strings.dart';
import '../controllers/drawer_controller.dart';
import '../controllers/loading_dialogue_controller.dart';
import '../controllers/login_form_validate_controller.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/snack_bar.dart';
import 'create_account_page.dart';
import 'forgot_password_phone_page.dart';

class login_page extends StatefulWidget {
  login_page({Key? key}) : super(key: key);

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  final formvalidationController = Get.put(login_form_validate_controller());
  final loading_dialogue_controller loadingController = Get.find();
  drawer_controller drawerController = Get.find();

  @override
  void dispose(){
    formvalidationController.phoneController.text="";
    formvalidationController.passwordController.text="";
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    RxBool _isVisible = false.obs;
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            bar_with_back_button(context,login_txt),
            Flexible(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: formvalidationController.loginFormKey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: het > wdt ? het * 0.13 : wdt * 0.13,
                        child: Image.asset(izmir_icon_with_slogan),
                      ),
                      5.heightBox,
                      Text(
                        login_slogan,
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
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: "Phone",
                                prefixIcon: Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.number,
                              controller:
                              formvalidationController.phoneController,
                              onSaved: (value) {
                                formvalidationController.phone = value!;
                              },
                              validator: (value) {
                                return formvalidationController.validatePhone(value!);
                              },
                            ),
                            15.heightBox,
                            Obx(
                              () => TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                obscureText: !_isVisible.value,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _isVisible.value = !_isVisible.value;
                                    },
                                    icon: _isVisible.value
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
                            15.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Material(
                                  borderRadius: BorderRadius.circular(6),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>forgot_password_phone_page(comming_from:users)));
                                    },
                                    borderRadius: BorderRadius.circular(6),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: whiteColor,
                                      ),
                                      height: 20.0,
                                      width: 120,
                                      child: Text(
                                        forgot_pass_txt,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500),
                                      ).box.alignCenter.make(),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Material(
                                  borderRadius: BorderRadius.circular(6),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>professional_login_page()));
                                    },
                                    borderRadius: BorderRadius.circular(6),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: whiteColor,
                                      ),
                                      height: 20.0,
                                      width: 120,
                                      child: Text(
                                        pro_lgn,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            color: darkBlueColor,
                                            fontWeight: FontWeight.w500),
                                      ).box.alignCenter.make(),
                                    ),
                                  ),
                                ),
                              )
                            ],),
                            25.heightBox,
                          ],
                        ),
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(6),
                        child: InkWell(
                          onTap: () {
                            if (formvalidationController.checkLogin()) {
                              login(context);
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
                              login_txt,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: yellowColor,
                                  fontWeight: FontWeight.w500),
                            ).box.alignCenter.make(),
                          ),
                        ),
                      ),
                      25.heightBox,
                      Material(
                        borderRadius: BorderRadius.circular(6),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>create_account_page(comming_from:users)));
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: yellowColor,
                            ),
                            height: 40.0,
                            width: 200.0,
                            child: Text(
                              create_account,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: darkBlueColor,
                                  fontWeight: FontWeight.w500),
                            ).box.alignCenter.make(),
                          ),
                        ),
                      ),
                      25.heightBox,
                    ],
                  ).box.padding(EdgeInsets.only(right: 15, left: 15)).make(),
                ),
              ),
            )
          ],
        ),
      ).box.color(whiteColor).make(),
    );
  }

Future login(context) async {
  String phone_number='${"+88"+formvalidationController.phone}'.trim();
  loadingController.show_dialogue(context);
  final QuerySnapshot result = await FirebaseFirestore.instance.collection(users)
      .where("phone",isEqualTo: phone_number).get();
  final List < DocumentSnapshot > documents = result.docs;

  if (documents.length!=0) {
    for(var doc in documents){
      String pswd = doc.get('password');
      var info = new Map();
      if(pswd.compareTo(sha1.convert(utf8.encode(formvalidationController.password)).toString())==0){

        info["name"] = doc.get("name");
        info["profile_picture"] = doc.get("profile_picture");
        info["phone"] = doc.get("phone");
        info["email"] = doc.get("email");
        info["address"] = doc.get("address");
        info["account_type"] = doc.get("account_type");
        info["division"] =doc.get("division");
        info["district"] =doc.get("district");
        info["referral_code"]=doc.get("referral_code");
        info["level"] = doc.get("level");
        info["time"] = doc.get("time");

        drawerController.save_userId(doc.id);
        drawerController.saveProfileInfo(info);
        loadingController.close_dialogue(context);
        Navigator.popUntil(context,(route)=>route.isFirst);
      }else{
        loadingController.close_dialogue(context);
        show_snackbar(context,incrct_ps_txt,whiteColor,Colors.red);
      }
    }
  }else {
    loadingController.close_dialogue(context);
    show_snackbar(context,dont_have_account,whiteColor,Colors.red);
  }
  }
}
