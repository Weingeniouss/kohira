// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../view/utils/app_color.dart';
import '../../../view/utils/widget/pop.dart';
import '../../service/credentials/forgetpassword.dart';

class ForgetpassswordCalling extends GetxController {
  var isLoading = false.obs;
  var data;

  Future<void> forgetpassworduser({String? email}) async {
    try {
      isLoading.value = true;
      print("Attempting login for $email");

       data = await ForgetpasswordService().forgetpassworduser(email: email);

      if (data != null) {
        ToastificationSuccess.Success("'Success', ${data?.message}");
        Container(decoration: BoxDecoration(color: AppColor.green_color), child: Text(data?.message));
      } else {
        ToastificationError.Error("'Error', ${data?.message ?? 'Is Your Empty Email'}");
      }
    } catch (e) {
      ToastificationError.Error("Error, Something went wrong");
      print("forgetpassword error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
