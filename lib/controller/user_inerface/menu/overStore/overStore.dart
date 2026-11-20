// ignore_for_file: file_names, camel_case_types, strict_top_level_inference

import 'dart:async';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kohira/api/api_call.dart';
import 'package:kohira/view/utils/app_url.dart';

class Overstore_Conteroller extends GetxController {
  var isLoading = false.obs;
  var storeData = {}.obs;
  var cityListData = {}.obs;

  List<bool> seePeraList = [];

  @override
  void onInit() {
    super.onInit();
    fetchStoreData();
  }

  Future<void> fetchStoreData({String? search, String? storeCityId}) async {
    try {
      isLoading.value = true;

      if (cityListData.isEmpty) {
        final cityResponse = await ApiCall.fetchStoreCityData();
        cityListData.value = cityResponse;
      }

      final storeResponse = await ApiCall.fetchStoreData(search: search, storeCityId: storeCityId);
      storeData.value = storeResponse;


      _initializeSeePeraList();
    } finally {
      isLoading.value = false;
    }
  }

  void _initializeSeePeraList() {
    final allStores = storeData['data']?['allstoreList'] as List?;
    seePeraList = List.filled(allStores?.length ?? 0, false);
    update();
  }

  void persee(int index) {
    if (index < seePeraList.length) {
      seePeraList[index] = !seePeraList[index];
      update();
    }
  }

  Future<void> openMapDirections(double lat, double lng, String label) async {
    final String url =
        '${GoogleUrl.googlesarch}?api=1&query=$lat,$lng&query_place_id=$label';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future submitval(val) async {
    await fetchStoreData(search: val);
  }

  Future filterByCity(String cityId) async {
    await fetchStoreData(storeCityId: cityId);
  }
}
