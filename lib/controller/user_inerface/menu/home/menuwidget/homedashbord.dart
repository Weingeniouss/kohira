// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/app_url.dart';

class Homedashbord extends GetxController {
  var isLoading = false.obs;
  var homeDashborData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    homedashbord();
  }

  Future<void> homedashbord() async {
    try {
      isLoading.value = true;
      final uri = Uri.parse(AppUrl.homeDashbord);
      final response = await http.get(uri,headers: {});
      if (response.statusCode == 200 || response.statusCode == 201) {
        homeDashborData.assignAll(jsonDecode(response.body));
        log("homeDashbord :- $homeDashborData");
      } else {
        throw {
          'status': false,
          'message': 'Something went wrong',
        };
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class HomepageJewelryList extends GetxController {
  var isLoading = false.obs;
  var homeJewelryListData = {}.obs;

  Future<void> homeJewelryList() async {
    try {
      isLoading.value = true;
      final uri = Uri.parse(AppUrl.homepage_JewelryList);
      final response = await http.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        homeJewelryListData.assignAll(jsonDecode(response.body));
        log("homeJewelryListData :- $homeJewelryListData");
      } else {
        throw {
          'status': false,
          'message': 'Something went wrong',
        };
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
