
// ignore_for_file: file_names, prefer_const_constructors, must_call_super, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kohira/controller/API/menu/overstore/citylist.dart';
import 'package:kohira/controller/API/menu/overstore/overStore.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/screen/menu/over%20Store/direction.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/bottomNavigation/bottomNavigation.dart';

class Overstore extends StatefulWidget {
  const Overstore({super.key});

  @override
  State<Overstore> createState() => _OverstoreState();
}

class _OverstoreState extends State<Overstore> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final store =  Get.put(Overstore_Controller());
  final citylist =  Get.put(Citylist());

  // Function to open Google Maps with directions
  Future<void> _openMapDirections(double lat, double lng, String label) async {
    final String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$label';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

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
          hedingname: AppString.Over,
          suffixicon_1: AppIcon.like,
          suffixicon_2: AppIcon.shop,
        ),
        drawer: Drawers(),
        body: Container(
          height: Get.height, width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            if(store.isLoading.value){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Get.isDialogOpen != true) {
                  Get.dialog(
                    Center(child: Lottie.asset(AppJson.loading2)),
                    barrierDismissible: false,
                  );
                }
              });
              return Scaffold(backgroundColor: Colors.transparent);
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Get.isDialogOpen == true) {
                  Get.back();
                }
              });

              final city = citylist.data['data'];
              final stores = store.data['data'];

              return Column(
                children: [
                  SizedBox(height: Get.height / 50),
                  horizontalpadding(
                    child: searchField(
                      onChanged: (val) {
                        if (debounce?.isActive ?? false) debounce!.cancel();
                        debounce = Timer(const Duration(seconds: 6), () {
                          setState(() {
                            store.overStore(search: val);
                          });
                        });
                      },
                      onSubmitted: (val) {
                        if (debounce?.isActive ?? false) debounce!.cancel();
                        setState(() {
                          store.overStore(search: val);
                        });
                      },
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  SizedBox(height: Get.height / 150),
                  SizedBox(
                    height: Get.height / 7,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: city.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () => store.overStore(),
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
                                store.overStore(store_city_id: cityId);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  cityImage.isNotEmpty ? SvgPicture.network(cityImage, fit: BoxFit.cover, height: 60,
                                    placeholderBuilder: (context) => Container(
                                      height: 60,
                                      width: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.location_city),
                                    ),
                                  ) : Container(height: 60, width: 60, color: Colors.grey[300], child: const Icon(Icons.location_city),
                                  ),
                                  Text(cityName, maxLines: 1, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          );
                        }
                      },
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
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: kElevationToShadow[1],
                                      color: AppColor.white_color,
                                      borderRadius: BorderRadius.circular(Get.width / 70),
                                    ),
                                    width: Get.width,
                                    child: Column(
                                      children: [
                                        Image.network(image),
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
                                              Text(AppString.seelessinfo,style: TextStyle(color: AppColor.pink_color)),
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
                                        GestureDetector(
                                          onTap: () {
                                            _openMapDirections(lat, lng, details['store_name']);
                                            print("Google map");
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: button('Get Directions'),
                                          ),
                                        ),
                                      ],
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
            }
          }),
        ),
      ),
    );
  }
}
