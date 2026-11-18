// ignore_for_file: avoid_print

import '../../../modal/credentials/country.dart';
import '../../../view/utils/app_url.dart';
import 'package:kohira/api/api_call.dart';
import 'dart:convert';

class CountryService {
  Future<Country?> countrypassworduser() async {
    final url = AppUrl.country;
    print("Sending request to: $url");

    try {
      final response = await ApiCall.getRequest(url, useAuth: false);

      if (response != null) {
        final country = countryFromJson(jsonEncode(response));
        print('Full country data: ${country.toJson()}');
        print('country success: ${country.success}');
        return country;
      } else {
        print('country failed with status: ${200}');
        print('country body: $response');
        return null;
      }
    } catch (e) {
      print('forgetpassword error: $e');
      return null;
    }
  }
}
