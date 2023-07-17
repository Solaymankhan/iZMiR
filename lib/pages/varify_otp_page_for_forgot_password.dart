
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:izmir/pages/change_password_page.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/colors.dart';
import '../consts/images.dart';
import '../consts/strings.dart';
import '../controllers/change_password_controller.dart';
import '../controllers/loading_dialogue_controller.dart';
import '../controllers/phone_auth_controller.dart';
import '../shapes/back_alert_dialogu.dart';
import '../shapes/snack_bar.dart';

class varify_otp_page_for_forgot_password extends StatefulWidget {
  varify_otp_page_for_forgot_password({Key? key,this.comming_from}) : super(key: key);

  final String? comming_from;

  @override
  State<varify_otp_page_for_forgot_password> createState() => _varify_otp_page_for_forgot_passwordState();
}

class _varify_otp_page_for_forgot_passwordState extends State<varify_otp_page_for_forgot_password> {
  phone_auth_controller phn_auth_cntrlr=Get.find();
  change_password_controller cng_pswrdController=Get.find();
  final loading_dialogue_controller loadingController=Get.find();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late BuildContext context;

  @override
  void dispose(){
    phn_auth_cntrlr.input_otp.value="";
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery
        .of(context)
        .size
        .width);
    var het = (MediaQuery
        .of(context)
        .size
        .height);
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
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
                    verify_otp_first_txt+cng_pswrdController.phone.value+verify_otp_second_txt,
                    style: TextStyle(
                        fontSize: 13,
                        color: darkBlueColor,
                        fontWeight: FontWeight.w600),
                  ),
                  15.heightBox,
                  Obx(() => PinFieldAutoFill(
                          textInputAction: TextInputAction.done,
                          codeLength: 6,
                          decoration: UnderlineDecoration(
                            textStyle: const TextStyle(
                                fontSize: 16, color: darkBlueColor,fontWeight: FontWeight.bold),
                            colorBuilder: const FixedColorBuilder(
                              Colors.transparent,
                            ),
                            bgColorBuilder: FixedColorBuilder(
                              Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          currentCode:  phn_auth_cntrlr.input_otp.value,
                          onCodeChanged: (code) {
                            phn_auth_cntrlr.input_otp.value = code!;
                          },
                        ),
                  ),
                    15.heightBox,
                    Material(
                      borderRadius: BorderRadius.circular(6),
                      child: InkWell(
                        onTap: () async{
                          if(phn_auth_cntrlr.input_otp.value.length!=6){
                            show_snackbar(context,otp_6_char_txt,whiteColor,Colors.red);
                          }else{
                            loadingController.show_dialogue(context);
                            try{
                              await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(
                                  verificationId: phn_auth_cntrlr.verificationId.value, smsCode: phn_auth_cntrlr.input_otp.value));
                              loadingController.close_dialogue(context);
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>change_password_page(comming_from:widget.comming_from)));
                            }on FirebaseAuthException catch(e){
                              loadingController.close_dialogue(context);
                              show_snackbar(context,e.message,whiteColor,Colors.red);
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
}
