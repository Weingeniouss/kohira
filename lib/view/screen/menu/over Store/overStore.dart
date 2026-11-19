// ignore_for_file: file_names, prefer_const_constructors, must_call_super, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/page_controllers/out_store_controller.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/screen/menu/over%20Store/overStoredetails.dart';
import 'package:kohira/view/utils/app_string.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/dio_client.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/bottomNavigation/bottomNavigation.dart';

class Overstore extends StatelessWidget {
  Overstore({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final OutStorePageController outPageStore = Get.put(OutStorePageController());

  OutStorePageController get over => outPageStore;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        final Bottamnavigation bottomSelectController =
            Get.find<Bottamnavigation>();
        Bottom();
        bottomSelectController.indexOne();
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: Appbar(
          prefixicon: AppIcon.menu,
          prefixonTap: () => scaffoldKey.currentState?.openDrawer(),
          hedingname: AppString.Our,
          suffixicon_1: AppIcon.like,
          suffixicon_2: AppIcon.shop,
        ),
        drawer: Drawers(),
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            if (outPageStore.store.isLoading.value) {
              return _buildSkeletonLoading();
            }

            final city = outPageStore.cityListData['data'] ?? [];
            final stores = outPageStore.storeData['data'] ?? [];

            if (stores.isEmpty || city.isEmpty) {
              return Center(child: Lottie.asset(AppJson.noData));
            }

            return Column(
              children: [
                _buildWelcomeBanner(),
                _buildCityHorizontalList(city),
                SizedBox(height: 10),
                Expanded(child: _buildStoresVerticalList(stores)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.promoCardBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            AppString.welcomeToKohira,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.pink_color,
            ),
          ),
          SizedBox(height: 6),
          Text(
            AppString.stepIntoKohiraStores,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColor.grey_color,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityHorizontalList(List city) {
    return SizedBox(
      height: 175,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: city.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return _buildCityItemTile(city, index);
        },
      ),
    );
  }

  Widget _buildCityItemTile(List city, int index) {
    if (index == 0) {
      return GestureDetector(
        onTap: () => over.fetchStoreData(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 115,
                width: 115,
                decoration: BoxDecoration(
                  color: AppColor.containerBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.borderGrey),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppIcon.allstore,
                    fit: BoxFit.cover,
                    height: 115,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppString.allStores,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    } else {
      final cityIndex = index - 1;
      if (cityIndex >= city.length) return const SizedBox.shrink();
      final cityData = city[cityIndex];
      final cityName = cityData['name']?.toString() ?? 'Unknown City';
      final cityImage = cityData['city_image_path']?.toString() ??
          cityData['city_image']?.toString() ??
          '';
      final cityId = cityData['id']?.toString() ??
          cityData['city_id']?.toString() ??
          cityData['store_city_id']?.toString() ??
          cityData['state_id']?.toString();
      final storeCount = cityData['stores_count']?.toString() ??
          cityData['store_count']?.toString() ??
          '1';

      return GestureDetector(
        onTap: () {
          if (cityId != null || cityName.isNotEmpty) {
            over.fetchStoreData(storeCityId: cityId);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 115,
                height: 115,
                decoration: BoxDecoration(
                  color: AppColor.containerBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.borderGrey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: buildCityImage(cityImage),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                cityName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "($storeCount Stores)",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColor.grey_color,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildStoresVerticalList(dynamic stores) {
    final List storeList = stores['allstoreList'] ?? [];

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: storeList.length,
      itemBuilder: (BuildContext context, int index) {
        final details = storeList[index] ?? {};
        return _buildStoreCard(details, index, storeList.length);
      },
    );
  }

  Widget _buildStoreCard(dynamic details, int index, int totalStores) {
    final storeCity = details['store_city'] is Map ? details['store_city'] : {};
    final String cityNameStr = storeCity['name']?.toString() ??
        storeCity['cityname']?.toString() ??
        '';
    final String storeNameStr = details['store_name']?.toString() ?? '';
    final String addressStr = details['address']?.toString() ?? '';
    final String contactStr = details['contact_number']?.toString() ?? '';
    final String openingHoursStr = details['opening_hours']?.toString() ?? '';
    final String closingHoursStr = details['closing_hours']?.toString() ?? '';
    final String imagePath = details['store_image_path']?.toString() ??
        details['store_image']?.toString() ??
        '';

    final double lat =
        double.tryParse(details['latitude']?.toString() ?? '0') ?? 0;
    final double lng =
        double.tryParse(details['longitude']?.toString() ?? '0') ?? 0;

    return horizontalpadding(
      child: Column(
        children: [
          SizedBox(height: 6),
          Text(
            "${AppString.kohiraStoresIn}${cityNameStr.isNotEmpty ? cityNameStr : 'Surat'}",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColor.black_color,
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColor.white_color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.borderGrey),
              boxShadow: [
                BoxShadow(
                  color: AppColor.shadowBlack05,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imagePath.isNotEmpty)
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          height: 180,
                          child: Center(
                            child: Icon(
                              AppIcon.storeIcon,
                              size: 40,
                              color: AppColor.grey_color,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        storeNameStr,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black_color,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        addressStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.grey_color,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 12),
                      if (contactStr.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(
                              AppIcon.phoneOutlined,
                              size: 16,
                              color: AppColor.grey_color,
                            ),
                            SizedBox(width: 8),
                            Text(
                              contactStr,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black_color,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                      if (openingHoursStr.isNotEmpty ||
                          closingHoursStr.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(
                              AppIcon.accessTimeOutlined,
                              size: 16,
                              color: AppColor.grey_color,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "$openingHoursStr To $closingHoursStr",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black_color,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (details['store_slug'] != null) {
                                    Get.to(
                                      () => OverstoredetailsScreen(
                                        slug: details['store_slug'].toString(),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.pink_color,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  AppString.viewStoresDetails,
                                  style: TextStyle(
                                    color: AppColor.white_color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: OutlinedButton(
                                onPressed: () => over.openMapDirections(
                                    lat, lng, storeNameStr),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: AppColor.pink_color),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  AppString.getDirection,
                                  style: TextStyle(
                                    color: AppColor.pink_color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.lodingcolor,
      highlightColor: AppColor.highlightColor,
      child: horizontalpadding(
        child: Column(
          children: [
            SizedBox(height: Get.height / 50),
            Container(
              height: Get.height * 0.08,
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: Get.height / 50),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 65,
                    height: 65,
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: AppColor.white_color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: Get.height / 50),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColor.white_color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 300,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildCityImage(String url) {
  if (url.isEmpty) {
    return _defaultCityIcon();
  }

  if (url.toLowerCase().endsWith(".svg")) {
    return FutureBuilder<bool>(
      future: _isValidSvg(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _defaultCityIcon();
        }
        if (snapshot.hasData && snapshot.data == true) {
          return SvgPicture.network(
            url,
            height: 65,
            width: 65,
            fit: BoxFit.cover,
            placeholderBuilder: (context) => _defaultCityIcon(),
          );
        } else {
          return _defaultCityIcon();
        }
      },
    );
  }

  return Image.network(
    url,
    height: 65,
    width: 65,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => _defaultCityIcon(),
  );
}

Widget _defaultCityIcon() {
  return Container(
    height: 65,
    width: 65,
    color: AppColor.lodingcolor,
    child: const Icon(AppIcon.locationCity, size: 30),
  );
}

Future<bool> _isValidSvg(String url) async {
  try {
    final res = await DioClient.dio.get(url);
    if (res.statusCode == 200) {
      final body = res.data.toString().toLowerCase();
      return body.contains("<svg");
    }
  } catch (e) {
    return false;
  }
  return false;
}
