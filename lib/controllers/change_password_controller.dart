import 'package:flutter/material.dart';
import 'package:get/get.dart';

class change_password_controller extends GetxController {
  final GlobalKey<FormState> change_password_FormKey = GlobalKey<FormState>();

  late TextEditingController passwordController,passwordController_2;
  var phone = ''.obs;
  var password_1 = '';
  var password_2 = '';
  var password_1_temp='';
  @override
  void onInit() {
    super.onInit();
    passwordController = TextEditingController();
    passwordController_2=TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    passwordController.dispose();
    passwordController_2.dispose();
  }

  String? validatePassword(String value) {
    password_1_temp=value;
    if (value.length < 8) {
      return "Password must be more than 7 characters";
    }
    return null;
  }
  String? validatePassword_2(String value) {
    if (password_1_temp != value) {
      return "Password doesn't match with previous one";
    }
    return null;
  }

  bool checkvalidation() {
    final isValid = change_password_FormKey.currentState!.validate();
    if (!isValid) {
      return false;
    }else{
      change_password_FormKey.currentState!.save();
      return true;
    }
  }
}