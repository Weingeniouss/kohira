// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var email_type = false.obs;
  var password_type = false.obs;

  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  void SiginTab() {
    if (email_controller.text.isEmpty && password_controller.text.isEmpty) {email_type.value = true; password_type.value = true;}
    if (email_controller.text.isEmpty) {email_type.value = true;} else {email_type.value = false;}
    if (password_controller.text.isEmpty) {password_type.value = true;} else {password_type.value = false;}
  }
}
