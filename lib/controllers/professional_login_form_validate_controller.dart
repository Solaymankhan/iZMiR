import 'package:flutter/material.dart';
import 'package:get/get.dart';

class professional_login_form_validate_controller extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  late TextEditingController phoneController,passwordController;
  var phone = '';
  var password = '';
  @override
  void onInit() {
    super.onInit();
    phoneController= TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  RegExp _numeric = RegExp(r'^\+?01[3456789][0-9]{8}\b');

  String? validatePhone(String value) {
    if (!_numeric.hasMatch(value)) {
      return "Provide valid number";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.length < 8) {
      return "Password must be of 8 characters";
    }
    return null;
  }

  bool checkLogin() {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return false;
    }else{
      loginFormKey.currentState!.save();
      return true;
    }
  }
}