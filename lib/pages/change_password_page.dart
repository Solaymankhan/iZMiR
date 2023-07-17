import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/strings.dart';
import '../controllers/change_password_controller.dart';
import '../controllers/drawer_controller.dart';
import '../controllers/loading_dialogue_controller.dart';
import '../controllers/phone_auth_controller.dart';
import '../shapes/back_alert_dialogu.dart';
import '../shapes/snack_bar.dart';


class change_password_page extends StatefulWidget {
  change_password_page({Key? key,this.comming_from}) : super(key: key);

  final String? comming_from;

  @override
  State<change_password_page> createState() => _change_password_pageState();
}

class _change_password_pageState extends State<change_password_page> {
  change_password_controller cng_pswrdController=Get.find();
  phone_auth_controller phn_auth_cntrlr=Get.find();
  drawer_controller drawerController=Get.find();
  final loading_dialogue_controller loadingController=Get.find();
  int count=0;

  @override
  void dispose(){
    cng_pswrdController.passwordController.text="";
    cng_pswrdController.passwordController_2.text="";
    phn_auth_cntrlr.input_otp.value="";
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    RxBool _isVisiblepassword_1 = false.obs;
    RxBool _isVisiblepassword_2 = false.obs;
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return WillPopScope(
        onWillPop: ()async{
          if(await showAlertDialog(context)==true){
            Navigator.popUntil(context, (route) => count++==2);
          }
          return false;
        },
      child: Scaffold(
        body: SafeArea(
          child: Column(
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
                          onTap: () async{
                            if(await showAlertDialog(context)==true) Navigator.popUntil(context, (route) => count++==2);
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
                    chng_pswrd_txt,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ).box.margin(EdgeInsets.only(bottom: 3)).make(),
                ],
              ).box.padding(EdgeInsets.only(top: 5)).make(),
              Flexible(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: cng_pswrdController.change_password_FormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          use_nw_pswrd_txt,
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
                              Obx(() => TextFormField(
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  obscureText: !_isVisiblepassword_1.value,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _isVisiblepassword_1.value = !_isVisiblepassword_1.value;
                                      },
                                      icon: _isVisiblepassword_1.value
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
                                    labelText: "Password",
                                    prefixIcon: Icon(Icons.lock),
                                  ),
                                   maxLength: 20,
                                  controller:
                                  cng_pswrdController.passwordController,
                                  onSaved: (value) {
                                    cng_pswrdController.password_1 = value!;
                                  },
                                  validator: (value) {
                                    return cng_pswrdController
                                        .validatePassword(value!);
                                  },
                                ),
                              ),
                              15.heightBox,
                              Obx(()=> TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: !_isVisiblepassword_2.value,
                                decoration: InputDecoration(
                                  suffixIcon:
                                  IconButton(
                                    onPressed: () {
                                      _isVisiblepassword_2.value = !_isVisiblepassword_2.value;
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
                                  contentPadding: EdgeInsets.all(8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  labelText: "Re-enter password",
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                maxLength: 20,
                                controller:
                                cng_pswrdController.passwordController_2,
                                onSaved: (value) {
                                  cng_pswrdController.password_2 = value!;
                                },
                                validator: (value) {
                                  return cng_pswrdController.validatePassword_2(value!);
                                },
                              ),),
                              25.heightBox,
                            ],
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(6),
                          child: InkWell(
                            onTap: () {
                              if (cng_pswrdController.checkvalidation()) {
                                update_password(context);
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
                      ],
                    ).box.padding(EdgeInsets.only(right: 15, left: 15)).make(),
                  ),
                ).box.alignCenter.make(),
              )
            ],
          ),
        ).box.color(whiteColor).make(),
      ),
    );
  }

  void update_password(context){
    loadingController.show_dialogue(context);

    var info = new Map();
    DocumentReference documentReference= FirebaseFirestore
        .instance.collection(widget.comming_from!)
        .doc(drawerController.user_doc_id.value);
    documentReference.update({
      "password": sha1.convert(utf8.encode(cng_pswrdController.password_2)).toString(),
    }).then((_) => {
    show_snackbar(context, sccs_cng_pswrd, yellowColor, darkBlueColor),
    documentReference.snapshots().listen((doc) {
    info["name"] = doc.get("name");
    info["profile_picture"] = doc.get("profile_picture");
    info["phone"] = doc.get("phone");
    info["email"] = doc.get("email");
    info["address"] = doc.get("address");
    info["account_type"] = doc.get("account_type");
    info["division"] =doc.get("division");
    info["district"] =doc.get("district");
    info["buying_ammount"] =doc.get("buying_ammount");
    info["balance"]==doc.get("balance");
    info["referral_code"]==doc.get("referral_code");
    info["level"] = doc.get("level");
    info["time"] = doc.get("time");

    }),
      drawerController.saveProfileInfo(info),
      drawerController.save_userId(drawerController.user_doc_id.value),
      loadingController.close_dialogue(context),
      Navigator.popUntil(context,(route)=>route.isFirst)
    }
    ).catchError((e)=>{
      loadingController.close_dialogue(context),
      show_snackbar(context,e.message,whiteColor,Colors.red)
    });
  }
}
