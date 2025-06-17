// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../view/utils/widget/pop.dart';

class SingupController extends GetxController {
  var firstname_type = false.obs;
  var lastname_type = false.obs;
  var email_type = false.obs;
  var password_type = false.obs;
  var mobile_type = false.obs;
  var confirmpassword_type = false.obs;

  var value = false.obs;

   void selectedcheak(bool? val) => value.value = val ?? false;

  List<String> Contycode = ['+91', '+261', '+326', '+521', '+852'];
  var selectedValue = RxnString();

  void selectedvalue(val) => selectedValue.value = val;

  TextEditingController frist_controller = TextEditingController();
  TextEditingController last_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController mobile_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController confiim_password_controller = TextEditingController();

  void SignupnTab(Function widget) {
    email_type.value = email_controller.text.isEmpty;
    password_type.value = password_controller.text.isEmpty;
    mobile_type.value = mobile_controller.text.isEmpty;
    firstname_type.value = frist_controller.text.isEmpty;
    lastname_type.value = last_controller.text.isEmpty;
    confirmpassword_type.value = confiim_password_controller.text.isEmpty;

    if (email_type.value ||
        password_type.value ||
        mobile_type.value ||
        firstname_type.value ||
        lastname_type.value ||
        confirmpassword_type.value) {
      ToastificationError.Error("Error, Please fill all fields");
      return;
    }

    widget();
  }
}