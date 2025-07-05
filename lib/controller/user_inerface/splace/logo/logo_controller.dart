// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:kohira/view/utils/widget/bottomNavigation/bottomNavigation.dart';
import '../../../../view/screen/credentials/login.dart';
import '../../../../view/utils/appconstants.dart' show islogin;

class LogoController extends GetxController {
  bool navigated = false;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 2), () {
      if (!navigated) {
        navigated = true;
        Get.offAll(() => (islogin) ?  Bottom() : Login());
      }
    });
  }
}
