
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/colors.dart';
import '../consts/images.dart';
import '../consts/strings.dart';
import '../controllers/create_account_form_validation_controller.dart';
import '../controllers/drawer_controller.dart';
import '../controllers/loading_dialogue_controller.dart';
import '../controllers/phone_auth_controller.dart';
import '../model/user_model.dart';
import '../shapes/back_alert_dialogu.dart';
import '../shapes/snack_bar.dart';

class varify_otp_page extends StatefulWidget {
  varify_otp_page({Key? key,this.comming_from}) : super(key: key);

  final String? comming_from;

  @override
  State<varify_otp_page> createState() => _varify_otp_pageState();
}

class _varify_otp_pageState extends State<varify_otp_page> {
  final create_account_form_validation_controller crt_acnt_cntrlr = Get.find();
  final loading_dialogue_controller loadingController=Get.find();
  final phone_auth_controller phn_auth_cntrlr = Get.find();
  final drawer_controller drawerController = Get.find();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late BuildContext context;

  @override
  void dispose(){
    crt_acnt_cntrlr.nameController.text="";
    crt_acnt_cntrlr.phoneController.text="";
    crt_acnt_cntrlr.emailController.text="";
    crt_acnt_cntrlr.addressController.text="";
    crt_acnt_cntrlr.passwordController.text="";
    crt_acnt_cntrlr.passwordController_2.text="";
    phn_auth_cntrlr.input_otp.value="";
    super.dispose();
  }
  Widget build(BuildContext context) {

  @override
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return WillPopScope(
      onWillPop: ()async{
        return await showAlertDialog(context) ?? false;
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
                            if(await showAlertDialog(context)==true) Get.back();
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
                    varify_otp_txt,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ).box.margin(EdgeInsets.only(bottom: 3)).make(),
                ],
              ).box.padding(EdgeInsets.only(top: 5)).make(),
              Flexible(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: het > wdt ? het * 0.13 : wdt * 0.13,
                        child: SvgPicture.asset(
                          verif_otp_icon,
                          width: 150,
                        ),
                      ),
                      15.heightBox,
                      Text(
                        verify_otp_first_txt+crt_acnt_cntrlr.phone+verify_otp_second_txt,
                        style: TextStyle(
                            fontSize: 13,
                            color: darkBlueColor,
                            fontWeight: FontWeight.w600),
                      ),
                      15.heightBox,
                      Obx(
                        () => PinFieldAutoFill(
                          textInputAction: TextInputAction.done,
                          codeLength: 6,
                          decoration: UnderlineDecoration(
                            textStyle: const TextStyle(
                                fontSize: 16,
                                color: darkBlueColor,
                                fontWeight: FontWeight.bold),
                            colorBuilder: const FixedColorBuilder(
                              Colors.transparent,
                            ),
                            bgColorBuilder: FixedColorBuilder(
                              Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          currentCode: phn_auth_cntrlr.input_otp.value,
                          onCodeChanged: (code) {
                            phn_auth_cntrlr.input_otp.value = code!;
                          },
                        ),
                      ),
                      15.heightBox,
                      Material(
                        borderRadius: BorderRadius.circular(6),
                        child: InkWell(
                          onTap: () async {

                            if (phn_auth_cntrlr.input_otp.value.length != 6) {
                              show_snackbar(context, otp_6_char_txt, whiteColor,
                                  Colors.red);
                            } else {
                              loadingController.show_dialogue(context);
                              try {
                                await FirebaseAuth.instance.signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId:
                                            phn_auth_cntrlr.verificationId.value,
                                        smsCode:
                                            phn_auth_cntrlr.input_otp.value));
                                save_user_in_database();
                                loadingController.close_dialogue(context);
                                Navigator.popUntil(context,(route)=>route.isFirst);
                              } on FirebaseAuthException catch (e) {
                                loadingController.close_dialogue(context);
                                show_snackbar(
                                    context, e.message, whiteColor, Colors.red);
                              }
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
                              vrfy_txt,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: yellowColor,
                                  fontWeight: FontWeight.w500),
                            ).box.alignCenter.make(),
                          ),
                        ),
                      )
                    ],
                  ).box.padding(EdgeInsets.only(right: 15, left: 15)).make(),
                ).box.alignCenter.make(),
              )
            ],
          ),
        ).box.color(whiteColor).make(),
      ),
    );
  }

  save_user_in_database() async {
    String referral_code=create_Referal_code(crt_acnt_cntrlr.name.trim());
    var info = new Map();

    info["name"] =(crt_acnt_cntrlr.name.trim());
    info["profile_picture"] =("");
    info["phone"] =("+88" + crt_acnt_cntrlr.phone.trim());
    info["email"] =(crt_acnt_cntrlr.email.trim());
    info["address"] =(crt_acnt_cntrlr.address.trim());
    info["account_type"] =(widget.comming_from!);
    info["division"] =(crt_acnt_cntrlr.divisionValue);
    info["district"] =(crt_acnt_cntrlr.districtValue);
    info["buying_ammount"] =("0");
    info["balance"] =("0");
    info["referral_code"] =(referral_code);
    info["level"] =(widget.comming_from==users?"":"1");
    info["time"] =(new DateTime.now().microsecondsSinceEpoch.toString());

    DocumentReference documentReference =
        await firestore.collection(widget.comming_from!).doc();
    documentReference.set({
      "name": info["name"],
      "name_lowercase": info["name"].toLowerCase(),
      "profile_picture": info["profile_picture"],
      "phone": info["phone"],
      "email": info["email"],
      "password": sha1.convert(utf8.encode(crt_acnt_cntrlr.password_2)).toString(),
      "address": info["address"],
      "account_type": info["account_type"],
      "account_status": widget.comming_from==users?activated:deactivated,
      "division": info["division"],
      "district": info["district"],
      "liked_brands": [],
      "buying_ammount": info["buying_ammount"],
      "referral_code" :info["referral_code"],
      "balance": info["balance"],
      "level": info["level"],
      "time": info["time"]
    }).then((doc){
        if (widget.comming_from == users) {
          drawerController.save_userId(documentReference.id);
          drawerController.saveProfileInfo(info);
          show_snackbar(context, sccs_acnt, yellowColor, darkBlueColor);
        } else {
          show_snackbar(context, sccs_aply, yellowColor, darkBlueColor);
        }
    }).catchError((e) {
      show_snackbar(context, e.toString(), whiteColor, Colors.red);
    });
  }

String create_Referal_code(name){
    var splt_nm=name.split(' ');
    name="";
    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;
    for(String s in splt_nm) name=name+s;
    String ref_code="${name+code.toString()}".toUpperCase();
    return ref_code;
  }

}
