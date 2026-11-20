// ignore_for_file: avoid_print

import 'package:kohira/view/utils/app_url.dart';

import '../../../../modal/menu/home/home_jewelry_sections.dart';
import 'package:kohira/api/api_call.dart';
import 'dart:convert';

class HomeJewelrySectionsService {
  final url = AppUrl.homepage_JewelryList;

  Future<HomeJewelrySectionsModel?> fetchHomeJewelrySections() async {
    try {
      print("Sending request to: $url");
      final response = await ApiCall.getRequest(url, useAuth: false);

      if (response != null) {
        final model = homeJewelrySectionsModelFromJson(jsonEncode(response));
        print('Home Jewelry Sections fetched successfully');
        return model;
      } else {
        print('Home Jewelry Sections Error status: ${200}');
      }
    } catch (e) {
      print('Home Jewelry Sections Error: $e');
    }
    return null;
  }
}
