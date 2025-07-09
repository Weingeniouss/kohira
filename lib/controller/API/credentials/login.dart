// ignore_for_file: avoid_print, prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';

import 'package:get/get.dart';
import 'package:kohira/controller/service/credentials/login.dart';
import 'package:kohira/view/utils/appconstants.dart';
import 'package:kohira/view/utils/widget/bottomNavigation/bottomNavigation.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import '../../../modal/credentials/login.dart';

class LoginCalling extends GetxController {
  var isLoading = false.obs;
  var data = Rxn<Data>();
  var Tokans = ''.obs;

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      print("Attempting login for $email");

      final login = await LoginService().loginUser(email, password);

      if (login != null && login.success == true) {
        data.value = login.data;
        final Tokans = 'Bearer ${login.token!}';

        pref!.setString('tokan', Tokans);
        tokans = pref!.getString('tokan')!;

        print('Tokan ${login.token}');
        if (login.message == 'Validation failed') {
          final errorResponse = LoginService();
          final decoded = json.decode(errorResponse as String);
          ToastificationError.Error(decoded['errors'].toString());
        }

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
