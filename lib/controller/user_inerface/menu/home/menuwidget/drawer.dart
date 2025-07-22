import 'package:get/get.dart';

class DrawerInterface extends GetxController{
  var allJewellery = false.obs;


  void selectcategoryitem(item) {
    item.isExpanded.toggle(); // if RxBool
  }

  void selectedJewellery(){
    allJewellery.value =! allJewellery.value;
  }
}