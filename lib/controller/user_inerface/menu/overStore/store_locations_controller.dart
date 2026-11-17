// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:kohira/modal/menu/home/store_locations.dart';
import 'package:kohira/api/api_call.dart';
import 'dart:convert';

class StoreLocationsController extends GetxController {
  var isLoading = false.obs;
  var storeLocations = <StoreState>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStoreLocations();
  }

  Future<void> fetchStoreLocations() async {
    try {
      isLoading.value = true;
      final response = await ApiCall.fetchStoreLocationsData();
      
      final model = storeLocationResponseFromJson(jsonEncode(response));
      if (model.data != null) {
         storeLocations.assignAll(model.data!);
      }
      print("Store locations fetched successfully");
    } catch (e) {
      print("Store locations error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

