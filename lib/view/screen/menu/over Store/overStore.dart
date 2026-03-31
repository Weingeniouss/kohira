
// ignore_for_file: file_names, prefer_const_constructors, must_call_super, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/overStore/overStore.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/screen/menu/over%20Store/overStoredetails.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/bottomNavigation/bottomNavigation.dart';
import 'package:http/http.dart' as http;

class Overstore extends StatefulWidget {
  const Overstore({super.key});

  @override
  State<Overstore> createState() => _OverstoreState();
}

class _OverstoreState extends State<Overstore> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final over = Get.put(Overstore_Conteroller());
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        final Bottamnavigation bottomSelectController = Get.find<Bottamnavigation>();
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
          height: Get.height, width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            if(over.store.isLoading.value){
              return Shimmer.fromColors(
                baseColor: AppColor.lodingcolor,
                highlightColor: AppColor.highlightColor,
                child: horizontalpadding(
                  child: Column(
                    children: [
                      SizedBox(height: Get.height / 50),
                      Container(
                        height: Get.height * 0.05,
                        decoration: BoxDecoration(
                          color: AppColor.white_color,
                          border: Border.all(color: AppColor.textfild_color),
                          borderRadius: BorderRadiusDirectional.circular(Get.width / 50),
                        ),
                      ),
                      SizedBox(height: Get.height / 50),
                      SizedBox(
                        height: Get.height / 10,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                             padding: EdgeInsets.all(40),
                              margin: EdgeInsets.only(right: Get.width / 50),
                              decoration: BoxDecoration(
                                color: AppColor.white_color,
                                borderRadius: BorderRadius.circular(Get.width / 50),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: Get.height / 50),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.white_color),
                                borderRadius: BorderRadius.circular(Get.width / 50),
                              ),
                              margin: EdgeInsets.only(bottom: Get.height / 80),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: Get.width,vertical: 90),
                                    decoration: BoxDecoration(
                                      color: AppColor.white_color,
                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                    ),
                                  ),
                                  SizedBox(height: Get.height / 80),
                                  Container(
                                    width: Get.width / 1.4,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppColor.white_color,
                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                    ),
                                  ),
                                  SizedBox(height: Get.height / 80),
                                  Container(
                                    width: Get.width / 1.7,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppColor.white_color,
                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                    ),
                                  ),
                                  SizedBox(height: Get.height / 80),
                                  Container(
                                    width: Get.width / 1.9,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppColor.white_color,
                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            final city = over.citylist.data['data'] ?? [];
            final stores = over.store.data['data'] ?? [];
            if(stores.isEmpty || city.isEmpty) return Center(child: Lottie.asset(AppJson.noData));
            return Column(
              children: [
                SizedBox(height: Get.height / 50),
                horizontalpadding(child: searchField(onSubmitted: (val) => over.submitval(val),textInputAction: TextInputAction.search)),
                SizedBox(height: Get.height / 150),
                SizedBox(
                  height: Get.height * 0.16,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: city.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return GestureDetector(
                          onTap: () => over.store.overStore(),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                SvgPicture.asset(AppIcon.allstore, fit: BoxFit.cover, height: 60),
                                Text(AppString.allStores),
                              ],
                            ),
                          ),
                        );
                      } else {
                        final cityIndex = index - 1;
                        if (cityIndex >= city.length) return const SizedBox.shrink();
                        final cityData = city[cityIndex];
                        final cityName = cityData['name']?.toString() ?? 'Unknown City';
                        final cityImage = cityData['city_image_path']?.toString() ?? cityData['city_image']?.toString() ?? '';
                        final cityId = cityData['id']?.toString();
                        return GestureDetector(
                          onTap: () {
                            if (cityId != null) {
                              over.store.overStore(store_city_id: cityId);
                            }},
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                buildCityImage(cityImage),
                                Text(cityName, maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        );
                      }},
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: stores['allstoreList']?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      final details =  stores['allstoreList'][index];
                      final cityname = details['store_city']['cityname'];
                      final image =  details['store_image_path'];

                      // Extract latitude and longitude from your data
                      // You'll need to adjust these based on your API response structure
                      final double lat = double.tryParse(details['latitude']?.toString() ?? '0') ?? 0;
                      final double lng = double.tryParse(details['longitude']?.toString() ?? '0') ?? 0;

                      // Safety: if seePeraList is not long enough, expand it
                      if (over.seePeraList.length < stores['allstoreList'].length) {
                        over.seePeraList = List.filled(stores['allstoreList'].length, false);
                      }

                      return horizontalpadding(
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(width: 80, height: 1, color: AppColor.pink_color),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(cityname['name'], style: TextStyle(color: AppColor.pink_color, fontWeight: FontWeight.w600)),
                                    ),
                                    Container(width: 80, height: 1, color: AppColor.pink_color),
                                  ],
                                ),
                                SizedBox(height: Get.height / 50),
                                GestureDetector(
                                  onTap: () => Get.to(() => OverstoredetailsScreen(slug: details['store_slug'])),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: kElevationToShadow[1],
                                      color: AppColor.white_color,
                                      borderRadius: BorderRadius.circular(Get.width / 70),
                                    ),
                                    width: Get.width,
                                    child: Column(
                                      children: [
                                        image != null && image.isNotEmpty ? ClipRRect(
                                          borderRadius: BorderRadius.circular(Get.width / 70),
                                          child: Image.network(
                                            image,
                                            fit: BoxFit.cover,
                                            width: Get.width,
                                            errorBuilder: (context, error, stackTrace) {
                                              return SizedBox();
                                              },
                                            ),
                                          ) : Image.network(image),
                                        Container(
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: Get.height / 50),
                                              Text(details['store_city']['state_name']['name'],style: TextStyle(color: AppColor.pink_color)),
                                              Text(details['store_name']),
                                              Row(
                                                children: [
                                                  Text(AppString.contact),
                                                  Text(details['contact_number']),
                                                ],
                                              ),
                                              SizedBox(height: Get.height / 50),
                                              GetBuilder<Overstore_Conteroller>(
                                                builder: (over) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () => over.persee(index),
                                                          child: Text(over.seePeraList[index] ? "See Less Info" : "See More Info",style: TextStyle(color: AppColor.pink_color)),
                                                        ),
                                                        Visibility(
                                                          visible: over.seePeraList[index],
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: Get.height / 180),
                                                              Text(details['address']),
                                                              SizedBox(height: Get.height / 50),
                                                              Row(
                                                                children: [
                                                                  Text('Timaing :- '),
                                                                  Row(
                                                                    children: [
                                                                      Text(details['opening_hours']), SizedBox(width: Get.width / 50),
                                                                      Text("To"),
                                                                      SizedBox(width: Get.width / 50), Text(details['closing_hours']),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => over.openMapDirections(lat, lng, details['store_name']),
                                            child: Padding(padding: EdgeInsets.all(15), child: button('Get Directions')),
                                          ),
                                        ],
                                      ),
                                    ),
                                 ),
                                  SizedBox(height: Get.height / 50),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );

          }),
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
    // For SVG we validate before showing
    return FutureBuilder<bool>(
      future: _isValidSvg(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _defaultCityIcon(); // show placeholder while loading
        }
        if (snapshot.hasData && snapshot.data == true) {
          return SvgPicture.network(
            url,
            height: 60,
            fit: BoxFit.cover,
            placeholderBuilder: (context) => _defaultCityIcon(),
          );
        } else {
          return _defaultCityIcon(); // fallback if invalid
        }
      },
    );
  }

  // Otherwise treat as normal image
  return Image.network(
    url,
    height: 60,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => _defaultCityIcon(),
  );
}

Widget _defaultCityIcon() {
  return Container(
    height: 60,
    width: 60,
    color: Colors.grey[300],
    child: const Icon(Icons.location_city),
  );
}

/// check if given URL returns a valid SVG response
Future<bool> _isValidSvg(String url) async {
  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final body = res.body.toLowerCase();
      // crude check: svg file should contain `<svg`
      return body.contains("<svg");
    }
  } catch (e) {
    return false;
  }
  return false;
}