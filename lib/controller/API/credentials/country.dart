// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_constants.dart';
import '../../../modal/credentials/country.dart';
import '../../../view/utils/app_url.dart';
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


class StateCalling extends GetxController {
  var isLoading = false.obs;
  var states = <dynamic>[].obs;
  var selectedState = Rxn();

  Future<void> stateList(String countryid) async {
    try {
      isLoading.value = true;
      final url = Uri.parse(AppUrl.state);
      final body = {'countryid': countryid};

      final response = await http.post(
        url,
        body: body,
        headers: {
          ApiHeaders.heading: ApiHeaders.peramitters,
          ApiHeaders.authorization: tokans,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        log("Raw State API Response: $data");

        if (data != null && data["states"] != null) {
          states.value = List<Map<String, dynamic>>.from(data["states"]);
        } else if (data != null && data["data"] != null) {
          states.value = List<Map<String, dynamic>>.from(data["data"]);
        } else {
          states.clear();
          log("No states found in response");
        }

        log("State List :- ${states.value}");
      } else {
        throw 'State Value Error :- ${response.statusCode}, ${response.body}';
      }
    } catch (e) {
      print('State Value Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
