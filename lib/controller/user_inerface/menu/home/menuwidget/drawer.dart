import 'package:get/get.dart';

class DrawerInterface extends GetxController{
  var allJewellery = false.obs;
  var collection = false.obs;
  var metaltype = false.obs;

  void selectcategoryitem(categoryItem) => categoryItem.isExpanded = !(categoryItem.isExpanded);
  void selectedJewellery() => allJewellery.value =! allJewellery.value;
  void collectionTab() => collection.value =! collection.value;
  void metaltypeTab() => metaltype.value =! metaltype.value;
}