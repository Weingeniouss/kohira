// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import '../../../../modal/menu/home/offer_banner.dart';

class OfferBannerService {
  final url = Uri.parse(AppUrl.offerbanner);

  Future<OfferBannerModel?> fetchOfferBanner() async {
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
        final offerBanner = offerBannerModelFromJson(response.body);
        print('Offer Banner Data :- ${response.body}');
        return offerBanner;
      } else {
        print('Offer Banner Error status :- ${response.statusCode}');
      }
    } catch (e) {
      print('Offer Banner Error :- $e');
    }
    return null;
  }
}
