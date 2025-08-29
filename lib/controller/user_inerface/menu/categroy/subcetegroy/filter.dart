// ignore_for_file: avoid_print

import 'package:get/state_manager.dart';

class FilterController extends GetxController {
  var metalstapid = ''.obs;
  var diamondtype = ''.obs;
  var selectedWeight = ''.obs;
  var selectedMetalType = ''.obs;
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
  void setMetalStamp(String id) => metalstapid.value = id;

  //Select Diamond Shap
  void setDiamondType(String id) => diamondtype.value = id;

  //Select Color
  void setMetalType(String? slug) {
    if (selectedMetalType.value == slug) {
      selectedMetalType.value; // real null, not "null"
    } else {
      selectedMetalType.value = slug!;
    }

    print('Selected metal type: ${selectedMetalType.value}');
  }

  //Select Weight
  void setWeight(String value) {
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

        // Optional debug print
        print('Selected weight range: min=$min, max=$max');
      } else {
        weightMin.value = null;
        weightMax.value = null;
      }
    }
  }

  //Select Price
  void setPrice(String value) {
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

        // Optional debug print
        print('Selected price range: min=$min, max=$max');
      } else {
        priceMin.value = null;
        priceMax.value = null;
      }
    }
  }

  //All Value Clear
  void clearFilters() {
    metalstapid.value = '';
    diamondtype.value = '';
    selectedWeight.value = '';
    weightMin.value = null;
    weightMax.value = null;
    selectedPrice.value = '';
    priceMin.value = null;
    priceMax.value = null;
  }
}
