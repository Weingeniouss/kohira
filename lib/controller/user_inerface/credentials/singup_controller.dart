// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SingupController extends GetxController {
  var firstname_type = false.obs;
  var lastname_type = false.obs;
  var email_type = false.obs;
  var password_type = false.obs;
  var mobile_type = false.obs;
  var confirmpassword_type = false.obs;

  var value = false.obs;

  void selectedcheak(bool? val) => value.value = val ?? false;

  List<String> Contycode = [
    '+91',
    '+261',
    '+326',
    '+521',
    '+852',
  ];
  var selectedValue = RxnString();

  void selectedvalue(val) => selectedValue.value = val;

  TextEditingController frist_controller = TextEditingController();
  TextEditingController last_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController mobile_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController confiim_password_controller = TextEditingController();

  void SignupnTab() {
    if (
        email_controller.text.isEmpty &&
        password_controller.text.isEmpty && mobile_controller.text.isEmpty && frist_controller.text.isEmpty &&
        frist_controller.text.isEmpty && last_controller.text.isEmpty
    ) {
      email_type.value = true;
      password_type.value = true; mobile_type.value = true;
      firstname_type.value = true; lastname_type.value = true;
    }

    if (email_controller.text.isEmpty) {email_type.value = true;} else {email_type.value = false;}
    if (password_controller.text.isEmpty) {password_type.value = true;} else {password_type.value = false;}
    if (mobile_controller.text.isEmpty) {mobile_type.value = true;} else {mobile_type.value = false;}
    if (frist_controller.text.isEmpty) {firstname_type.value = true;} else {firstname_type.value = false;}
    if (last_controller.text.isEmpty) {lastname_type.value = true;} else {lastname_type.value = false;}
  }
}
