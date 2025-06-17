// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'package:get/get.dart';
import '../../../view/utils/widget/pop.dart';
import '../../service/credentials/forgetpassword.dart';

class ForgetpassswordCalling extends GetxController {
  var isLoading = false.obs;
  var data;

  Future<void> forgetpassworduser({String? email}) async {
    try {
      isLoading.value = true;
      print("Attempting login for $email");

      final forgetpassword = await ForgetpasswordService().forgetpassworduser(email: email);

      if (forgetpassword != null) {
        ToastificationSuccess.Success("'Success', ${forgetpassword.message}");
      } else {
        ToastificationError.Error("'Error', ${forgetpassword?.message}");
      }
    } catch (e) {
      ToastificationError.Error("Error, Something went wrong");
      print("forgetpassword error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
