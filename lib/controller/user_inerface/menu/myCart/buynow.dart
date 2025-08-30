import 'package:get/get.dart';

class BuynowController extends GetxController{
  var ischeack = false.obs;

  void ischack(){
    ischeack.value =! ischeack.value;
    update();
  }
}