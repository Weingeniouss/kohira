// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:get/get.dart';
import 'package:kohira/controller/service/credentials/login.dart';
import 'package:kohira/view/utils/widget/bottomNavigation/bottomNavigation.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import '../../../modal/credentials/login.dart';

class LoginCalling extends GetxController {
  var isLoading = false.obs;
  var data = Rxn<Data>();

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      print("Attempting login for $email");

      final login = await LoginService().loginUser(email, password);

      if (login != null && login.success == true) {
        data.value = login.data;
        ToastificationSuccess.Success("'Success', ${login.message}");
        Get.offAll(() => Bottom());
      } else {
        ToastificationError.Error("'Error', ${login?.message}");
      }
    } catch (e) {
      ToastificationError.Error("Error, Something went wrong");
      print("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
