// ignore_for_file: avoid_print

import 'package:kohira/view/utils/app_url.dart';

import '../../../../modal/menu/home/offer_banner.dart';
import 'package:kohira/api/api_call.dart';
import 'dart:convert';

class OfferBannerService {
  final url = AppUrl.offerbanner;

  Future<OfferBannerModel?> fetchOfferBanner() async {
    try {
      print("Sending request to: $url");
      final response = await ApiCall.getRequest(url, useAuth: false);

      if (response != null) {
        final offerBanner = offerBannerModelFromJson(jsonEncode(response));
        print('Offer Banner Data :- $response');
        return offerBanner;
      } else {
        print('Offer Banner Error status :- ${200}');
      }
    } catch (e) {
      print('Offer Banner Error :- $e');
    }
    return null;
  }
}
