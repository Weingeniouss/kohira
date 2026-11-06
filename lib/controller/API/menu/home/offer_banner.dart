// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:kohira/controller/service/menu/home/offer_banner.dart';
import '../../../../modal/menu/home/offer_banner.dart';

class OfferBannerCalling extends GetxController {
  var isLoading = false.obs;
  var offerBanners = <OfferBannerItem>[].obs;
  var topBarSliders = <TopBarSliderItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    getOfferBanners();
  }

  Future<void> getOfferBanners() async {
    try {
      isLoading.value = true;
      final result = await OfferBannerService().fetchOfferBanner();

      if (result != null && result.success == true && result.data != null) {
        offerBanners.value = result.data?.offerbanner ?? [];
        topBarSliders.value = result.data?.topbarslider ?? [];
        print('Offer Banners count :- ${offerBanners.length}');
      } else {
        print('Failed to fetch Offer Banners: ${result?.message}');
      }
    } catch (e) {
      print('OfferBannerCalling Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
