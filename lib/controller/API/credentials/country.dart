// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../modal/credentials/country.dart';
import '../../../view/utils/widget/pop.dart';
import '../../service/credentials/country.dart';

class CountryCalling extends GetxController {
  var isLoading = false.obs;
  var countries = <Data>[].obs;
  var selectedCountry = Rxn<Data>();

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCountryList();
  }

  Future<void> fetchCountryList() async {
    isLoading.value = true;
    final result = await CountryService().countrypassworduser();
    if (result != null && result.success == true) {
      countries.assignAll(result.data ?? []);
    } else {
      ToastificationError.Error("Failed to load countries");
    }
    isLoading.value = false;
  }

  void selectCountry(Data? value) {
    selectedCountry.value = value;
  }
}
