// ignore_for_file: avoid_print

import 'package:get/state_manager.dart';

class FilterController extends GetxController {
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

  //Select 14k  or 18K
  void setMetalStamp(String slug) => metalstapid.value = slug;

  //Select Diamond Shap
  void setDiamondType(String slug, String id) {
    diamondtype.value = slug;
    selectedShapeId.value = id;
  }

  //Select Color Type - FIXED: Added toggle functionality
  void setColoeType(String slug, String id) {
    if (colortype.value == slug) {
      colortype.value = ''; // Deselect if same color is clicked again
    } else {
      colortype.value = id;
      colortype.value = slug; // Select new color
    }
    print('Selected color type: ${colortype.value}');
  }

  //Select Metal Type - IMPROVED: Fixed the logic
  void setMetalType(String? id) {
    if (selectedMetalType.value == id) {
      selectedMetalType.value = ''; // Deselect if same metal type is clicked
    } else {
      selectedMetalType.value = id ?? ''; // Select new metal type
    }
    print('Selected metal type: ${selectedMetalType.value}');
  }

  //Select Weight
  void setWeight(String value) {
    if (selectedWeight.value == value) {
      selectedWeight.value = ''; // Deselect if same weight is clicked
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
          print('Selected weight range: min=$min, max=$max');
        } else {
          weightMin.value = null;
          weightMax.value = null;
        }
      }
    }
  }

  //Select Price
  void setPrice(String value) {
    if (selectedPrice.value == value) {
      selectedPrice.value = ''; // Deselect if same price is clicked
      priceMin.value = null;
      priceMax.value = null;
    } else {
      selectedPrice.value = value;

      if (value.contains('Below')) {
        priceMin.value = null;
        priceMax.value = 10000.0;
      } else {
        final parts = value.replaceAll('₹', '').replaceAll(',', '').split(' To ');
        if (parts.length == 2) {
          final min = double.tryParse(parts[0].trim());
          final max = double.tryParse(parts[1].trim());
          priceMin.value = min;
          priceMax.value = max;
          print('Selected price range: min=$min, max=$max');
        } else {
          priceMin.value = null;
          priceMax.value = null;
        }
      }
    }
  }

  //All Value Clear
  void clearFilters() {
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
