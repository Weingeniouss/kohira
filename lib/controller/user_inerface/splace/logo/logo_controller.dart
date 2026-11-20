// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:kohira/view/utils/widget/bottomNavigation/bottomNavigation.dart';
import '../../../../view/utils/app_constants.dart';

class LogoController extends GetxController {
  bool navigated = false;

  @override
  void onInit() {
    super.onInit();
    if (pref != null) {
      tokans = pref!.getString('tokan') ?? '';
      islogin = (pref!.getBool('login') ?? false) && tokans.isNotEmpty;
      Mobile = pref!.getString('mobile') ?? '';
    }

    Future.delayed(Duration(seconds: 2), () {
      if (!navigated) {
        navigated = true;
        Get.offAll(() => Bottom());
      }
    });
  }
}
