import 'package:get/get.dart';

class DrawerInterface extends GetxController{
  var allJewellery = false.obs;


  void selectcategoryitem(categoryItem) {
    categoryItem.isExpanded = !(categoryItem.isExpanded);
    update();
  }

  void selectedJewellery(){
    allJewellery.value =! allJewellery.value;
  }
}