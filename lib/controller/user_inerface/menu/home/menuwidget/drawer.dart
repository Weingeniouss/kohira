import 'package:get/get.dart';

class DrawerInterface extends GetxController{
  var allJewellery = false.obs;
  var collection = false.obs;
  var metaltype = false.obs;
  var price = false.obs;

  void selectcategoryitem(categoryItem,filteredCategories) {
    for (var item in filteredCategories) {
      if (item != categoryItem) {
        item.isExpanded = false;
      }
    }
    categoryItem.isExpanded = !categoryItem.isExpanded;
    metaltype.value = false;
    price.value = false;
    collection.value = false;
  }

  void selectedJewellery() {
    allJewellery.value =! allJewellery.value;
    metaltype.value = false;
    price.value = false;
    collection.value = false;
  }

  void collectionTab() {
    collection.value =! collection.value;
    metaltype.value = false;
    price.value = false;
    allJewellery.value = false;
  }

  void metaltypeTab() {
    metaltype.value =! metaltype.value;
    collection.value = false;
    price.value = false;
    allJewellery.value = false;
  }

  void priceTab() {
    price.value =! price.value;
    metaltype.value = false;
    collection.value = false;
    allJewellery.value = false;
  }
}