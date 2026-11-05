// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../../modal/menu/home/home_jewelry_sections.dart';

class HomeJewelrySectionsService {
  final url = AppUrl.homepage_JewelryList;

  Future<HomeJewelrySectionsModel?> fetchHomeJewelrySections() async {
    try {
      print("Sending request to: $url");
      final response = await DioClient.dio.get(
        url,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.peramitters,
            ApiHeaders.contect: ApiHeaders.peramitters,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = homeJewelrySectionsModelFromJson(response.data.toString());
        print('Home Jewelry Sections fetched successfully');
        return model;
      } else {
        print('Home Jewelry Sections Error status: ${response.statusCode}');
      }
    } catch (e) {
      print('Home Jewelry Sections Error: $e');
    }
    return null;
  }
}
