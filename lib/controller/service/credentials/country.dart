// ignore_for_file: avoid_print


import '../../../modal/credentials/country.dart';
import '../../../view/utils/app_url.dart';
import 'package:http/http.dart' as http;

class CountryService {
  Future<Country?> countrypassworduser() async {
    final url = Uri.parse(AppUrl.country);
    print("Sending request to: $url");

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final country = countryFromJson(response.body);
        print('Full country data: ${country.toJson()}');
        print('country success: ${country.success}');
        return country;
      } else {
        print('country failed with status: ${response.statusCode}');
        print('country body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('forgetpassword error: $e');
      return null;
    }
  }
}
