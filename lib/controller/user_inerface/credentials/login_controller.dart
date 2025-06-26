// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../view/utils/app_String.dart';
import '../../../view/utils/widget/pop.dart';

class LoginController extends GetxController {
  var email_type = false.obs;
  var password_type = false.obs;

  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  void SiginTab(widget) {
    if (email_controller.text.isEmpty && password_controller.text.isEmpty)
    {
      ToastificationError.Error(AppString.fild);
      email_type.value = true;
      password_type.value = true;
    }
      if (email_controller.text.isEmpty) {email_type.value = true;} else {email_type.value = false;}
      if (password_controller.text.isEmpty) {password_type.value = true;} else {password_type.value = false;
    }
     isdone(widget);
  }

  void isdone(widget){
    if(!email_type.value && !password_type.value){
      widget;
    }
  }
}
