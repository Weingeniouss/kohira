// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import '../../../../modal/menu/home/home_jewelry_sections.dart';

class HomeJewelrySectionsService {
  final url = Uri.parse(AppUrl.homepage_JewelryList);

  Future<HomeJewelrySectionsModel?> fetchHomeJewelrySections() async {
    try {
      print("Sending request to: $url");
      final response = await http.get(
        url,
        headers: {
          ApiHeaders.heading: ApiHeaders.peramitters,
          ApiHeaders.contect: ApiHeaders.peramitters,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = homeJewelrySectionsModelFromJson(response.body);
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
