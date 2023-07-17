import 'package:flutter/material.dart';
import 'package:get/get.dart';

class create_account_form_validation_controller extends GetxController {
  final GlobalKey<FormState> create_account_FormKey = GlobalKey<FormState>();

  late TextEditingController nameController,emailController,phoneController,addressController
  ,passwordController,passwordController_2;
  var divisionValue = "";
  var districtValue = "";
  var name = '';
  var email = '';
  var phone = '';
  var address = '';
  var password = '';
  var password_2 = '';
  var password_1_temp='';
  @override
  void onInit() {
    super.onInit();
    nameController=TextEditingController();
    phoneController=TextEditingController();
    emailController = TextEditingController();
    addressController=TextEditingController();
    passwordController = TextEditingController();
    passwordController_2=TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  String? validateName(String value) {
    if (value.length ==0) {
      return "Name can't be empty";
    }
    return null;
  }

  RegExp _numeric = RegExp(r'^\+?01[3456789][0-9]{8}\b');

  String? validatePhone(String value) {
    if (!_numeric.hasMatch(value)) {
      return "Provide valid number";
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
    if (value.length ==0) {
      return "Address can't be empty";
    }
    return null;
  }

  String? validatePassword(String value) {
    password_1_temp=value;
    if (value.length < 8) {
      return "Password must be of 8 characters";
    }
    return null;
  }
  String? validatePassword_2(String value) {
    if (password_1_temp != value) {
      return "Password doesn't match with previous one";
    }
    return null;
  }

  bool checkCreateAccount() {
    final isValid = create_account_FormKey.currentState!.validate();
    if (!isValid) {
      return false;
    }else{
      create_account_FormKey.currentState!.save();
      return true;
    }
  }

}