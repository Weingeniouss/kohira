// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../modal/credentials/country.dart';
import '../../../view/utils/app_url.dart';

class CountryService {
  Future<Country?> countrypassworduser() async {
    final url = AppUrl.country;
    print("Sending request to: $url");

    try {
      final response = await DioClient.dio.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final country = countryFromJson(response.data.toString());
        print('Full country data: ${country.toJson()}');
        print('country success: ${country.success}');
        return country;
      } else {
        print('country failed with status: ${response.statusCode}');
        print('country body: ${response.data}');
        return null;
      }
    } catch (e) {
      print('forgetpassword error: $e');
      return null;
    }
  }
}
