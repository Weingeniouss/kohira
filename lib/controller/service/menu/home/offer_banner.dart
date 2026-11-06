// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../../modal/menu/home/offer_banner.dart';

class OfferBannerService {
  final url = AppUrl.offerbanner;

  Future<OfferBannerModel?> fetchOfferBanner() async {
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
        final offerBanner = offerBannerModelFromJson(response.data.toString());
        print('Offer Banner Data :- ${response.data}');
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
