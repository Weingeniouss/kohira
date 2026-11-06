// ignore_for_file: avoid_print

import 'package:get/state_manager.dart';

class FilterController extends GetxController {
  var selectedCategorySlug = ''.obs;
  var selectedCategoryName = ''.obs;
  var selectedSubcategorySlug = ''.obs;
  var selectedSubcategoryName = ''.obs;
  var metalstapid = ''.obs;
  var diamondtype = ''.obs;
  var colortype = ''.obs;
  var selectedWeight = ''.obs;
  var selectedMetalType = ''.obs;
  var selectedShapeId = ''.obs;
  var weightMin = RxnDouble();
  var weightMax = RxnDouble();
  var selectedPrice = ''.obs;
  var priceMin = RxnDouble();
  var priceMax = RxnDouble();

  List<String> weightlist = [
    'Less Then 2 Grams',
    '2 Grams To 4 Grams',
    '4 Grams To 8 Grams',
    '8 Grams To 15 Grams',
    '15 Grams To 18 Grams',
  ];

  List<String> price = [
    'Below ₹10,000',
    '₹10,000 To ₹20,000',
    '₹20,000 To ₹30,000',
    '₹30,000 To ₹40,000',
    '₹40,000 To ₹50,000',
  ];

  void setCategorySlug(String slug, [String name = '']) {
    if (selectedCategorySlug.value == slug) {
      selectedCategorySlug.value = '';
      selectedCategoryName.value = '';
    } else {
      selectedCategorySlug.value = slug;
      selectedCategoryName.value = name;
    }
  }

  void setSubcategorySlug(String slug, [String name = '']) {
    if (selectedSubcategorySlug.value == slug) {
      selectedSubcategorySlug.value = '';
      selectedSubcategoryName.value = '';
    } else {
      selectedSubcategorySlug.value = slug;
      selectedSubcategoryName.value = name;
    }
  }

  void setMetalStamp(String slug) {
    if (metalstapid.value == slug) {
      metalstapid.value = '';
    } else {
      metalstapid.value = slug;
    }
  }

  void setDiamondType(String slug, String id) {
    if (diamondtype.value == slug) {
      diamondtype.value = '';
      selectedShapeId.value = '';
    } else {
      diamondtype.value = slug;
      selectedShapeId.value = id;
    }
  }

  void setColoeType(String slug, String id) {
    if (colortype.value == slug) {
      colortype.value = '';
    } else {
      colortype.value = slug;
    }
  }

  void setMetalType(String? id) {
    if (id == null || selectedMetalType.value == id) {
      selectedMetalType.value = '';
    } else {
      selectedMetalType.value = id;
    }
  }

  void setWeight(String value) {
    if (selectedWeight.value == value) {
      selectedWeight.value = '';
      weightMin.value = null;
      weightMax.value = null;
    } else {
      selectedWeight.value = value;
      if (value.contains('Less Then')) {
        weightMin.value = null;
        weightMax.value = 2.0;
      } else {
        final parts = value.replaceAll(' Grams', '').split(' To ');
        if (parts.length == 2) {
          final min = double.tryParse(parts[0].trim());
          final max = double.tryParse(parts[1].trim());
          weightMin.value = min;
          weightMax.value = max;
        } else {
          weightMin.value = null;
          weightMax.value = null;
        }
      }
    }
  }

  void setPrice(String value) {
    if (selectedPrice.value == value) {
      selectedPrice.value = '';
      priceMin.value = null;
      priceMax.value = null;
    } else {
      selectedPrice.value = value;
      if (value.contains('Below')) {
        priceMin.value = null;
        priceMax.value = 10000.0;
      } else {
        final parts =
            value.replaceAll('₹', '').replaceAll(',', '').split(' To ');
        if (parts.length == 2) {
          final min = double.tryParse(parts[0].trim());
          final max = double.tryParse(parts[1].trim());
          priceMin.value = min;
          priceMax.value = max;
        } else {
          priceMin.value = null;
          priceMax.value = null;
        }
      }
    }
  }

  //All Value Clear - ONLY called when Reset button is clicked!
  void clearFilters() {
    selectedCategorySlug.value = '';
    selectedCategoryName.value = '';
    selectedSubcategorySlug.value = '';
    selectedSubcategoryName.value = '';
    metalstapid.value = '';
    diamondtype.value = '';
    colortype.value = '';
    selectedWeight.value = '';
    selectedMetalType.value = '';
    weightMin.value = null;
    weightMax.value = null;
    selectedPrice.value = '';
    priceMin.value = null;
    priceMax.value = null;
  }
}
