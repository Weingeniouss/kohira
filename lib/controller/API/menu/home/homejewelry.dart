// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:kohira/controller/service/menu/home/home_jewelry_sections.dart';
import 'package:kohira/modal/menu/home/home_jewelry_sections.dart';
import 'package:kohira/view/utils/app_url.dart';
import '../../../../view/utils/app_constants.dart';

class Homejewelry extends GetxController {
  var isLoading = false.obs;
  var homejewelrydata = {}.obs;
  var sectionsData = Rxn<HomeJewelrySectionsModel>();

  @override
  void onInit() {
    super.onInit();
    getHomejewelry();
  }

  Future<void> getHomejewelry() async {
    try {
      isLoading.value = true;
      final model = await HomeJewelrySectionsService().fetchHomeJewelrySections();
      if (model != null) {
        sectionsData.value = model;
      }

      final url = Uri.parse(AppUrl.homepage_JewelryList).toString();
      final responce = await dio.get(url);
      print('Sending to url :- $url');
      if (responce.statusCode == 200 || responce.statusCode == 201) {
        homejewelrydata.assignAll(responce.data);
        print('home Jewellery data:- $homejewelrydata');
      }
    } catch (e) {
      print('home Jewellery data Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}