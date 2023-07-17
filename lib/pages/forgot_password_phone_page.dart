import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:izmir/pages/varify_otp_page.dart';
import 'package:izmir/pages/varify_otp_page_for_forgot_password.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/images.dart';
import '../consts/strings.dart';
import '../controllers/change_password_controller.dart';
import '../controllers/drawer_controller.dart';
import '../controllers/loading_dialogue_controller.dart';
import '../controllers/phone_auth_controller.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/snack_bar.dart';

class forgot_password_phone_page extends StatelessWidget {
  forgot_password_phone_page({Key? key,this.comming_from}) : super(key: key);

  final drawer_controller drwrController = Get.find();
  final cng_pswrdController = Get.put(change_password_controller());
  final phone_auth_cntrlr = Get.put(phone_auth_controller());
  var phone_controller = TextEditingController();
  final loading_dialogue_controller loadingController=Get.find();

  final formkey = GlobalKey<FormState>();
  final String? comming_from;

  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            bar_with_back_button(context,""),
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
                        cng_pswrd_icon,
                        width: 100,
                      ),
                    ),
                    15.heightBox,
                    Text(
                      enter_phone,
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
                          Form(
                            key: formkey,
                            child: TextFormField(
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
                              controller: phone_controller,
                              validator: (value) {
                                return validatePhone(value!);
                              },
                            ),
                          ),
                          25.heightBox,
                        ],
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(6),
                      child: InkWell(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            have_account(context, phone_controller.text.trim());
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
                            send_txt,
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
              ).box.alignCenter.make(),
            )
          ],
        ),
      ).box.color(whiteColor).make(),
    );
  }

  RegExp _numeric = RegExp(r'^\+?01[3456789][0-9]{8}\b');

  String? validatePhone(String value) {
    if (!_numeric.hasMatch(value)) {
      return "Provide valid number";
    }
    return null;
  }

  Future have_account(context, phone) async {
    String phone_number = '${"+88" + phone}';
    String status = "";
    loadingController.show_dialogue(context);
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(comming_from!)
        .where("phone", isEqualTo: phone_number)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    for (var value in documents) {
      drwrController.user_doc_id.value = value.id;
      status = value.get("account_status");
    }
    if (status == deactivated) {
      loadingController.close_dialogue(context);
      show_snackbar(context, acnt_dacvtd, whiteColor, Colors.red);
    } else if (documents.length != 0) {
      phone_auth_cntrlr.phone_auth(phone_number);
      cng_pswrdController.phone.value = phone_number;
      loadingController.close_dialogue(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>varify_otp_page_for_forgot_password(comming_from:comming_from)));
    } else {
      loadingController.close_dialogue(context);
      show_snackbar(context, dont_have_account, whiteColor, Colors.red);
    }
  }
}
