// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/modal/menu/home/store_locations.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';

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
      final url = Uri.parse(AppUrl.store_locations);
      print("Fetching store locations from: $url");
      final response = await http.get(
        url,
        headers: {
          ApiHeaders.heading: ApiHeaders.peramitters,
          ApiHeaders.contect: ApiHeaders.peramitters,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = storeLocationResponseFromJson(response.body);
        if (model.data != null) {
          storeLocations.assignAll(model.data!);
        }
        print("Store locations fetched successfully");
      } else {
        print("Store locations error status: ${response.statusCode}");
      }
    } catch (e) {
      print("Store locations error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
