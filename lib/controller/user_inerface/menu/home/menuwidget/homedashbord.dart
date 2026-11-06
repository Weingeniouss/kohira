// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/controller/service/menu/home/homedashbord.dart';
import 'package:kohira/modal/menu/home/dashboard.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/dio_client.dart';

class Homedashbord extends GetxController {
  var isLoading = false.obs;
  var homeDashborData = {}.obs;
  var dashboardData = Rxn<HomeDashboardModel>();

  @override
  void onInit() {
    super.onInit();
    loadCachedData();
    homedashbord();
  }

  void loadCachedData() {
    try {
      final cachedJson = pref?.getString('cached_home_dashboard');
      if (cachedJson != null && cachedJson.isNotEmpty) {
        final decoded = jsonDecode(cachedJson);
        homeDashborData.assignAll(decoded);
        dashboardData.value = homeDashboardModelFromJson(cachedJson);
        log("Loaded home dashboard from local cache successfully");
      }
    } catch (e) {
      print('Cache load error: $e');
    }
  }

  Future<void> homedashbord() async {
    try {
      if (homeDashborData.isEmpty) {
        isLoading.value = true;
      }
      final model = await HomeDashboardService().fetchHomeDashboard();
      if (model != null) {
        dashboardData.value = model;
      }

      final url = AppUrl.homeDashbord;
      final response = await DioClient.dio.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final bodyString = response.data.toString();
        homeDashborData.assignAll(jsonDecode(bodyString));
        pref?.setString('cached_home_dashboard', bodyString);
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

  @override
  void onInit() {
    super.onInit();
    loadCachedData();
    homeJewelryList();
  }

  void loadCachedData() {
    try {
      final cachedJson = pref?.getString('cached_home_jewelry_list');
      if (cachedJson != null && cachedJson.isNotEmpty) {
        homeJewelryListData.assignAll(jsonDecode(cachedJson));
        log("Loaded jewelry list from local cache successfully");
      }
    } catch (e) {
      print('Jewelry list cache load error: $e');
    }
  }

  Future<void> homeJewelryList() async {
    try {
      if (homeJewelryListData.isEmpty) {
        isLoading.value = true;
      }
      final url = AppUrl.homepage_JewelryList;
      final response = await DioClient.dio.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final bodyString = response.data.toString();
        homeJewelryListData.assignAll(jsonDecode(bodyString));
        pref?.setString('cached_home_jewelry_list', bodyString);
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
