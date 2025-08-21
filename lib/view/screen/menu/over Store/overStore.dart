
// ignore_for_file: file_names, prefer_const_constructors, must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/overstore/citylist.dart';
import 'package:kohira/controller/API/menu/overstore/overStore.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/app_json.dart';

class Overstore extends StatefulWidget {
  const Overstore({super.key});

  @override
  State<Overstore> createState() => _OverstoreState();
}

class _OverstoreState extends State<Overstore> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final store =  Get.put(Overstore_Controller());
  final citylist =  Get.put(Citylist());
  @override
  void initState() {
    super.initState();
    citylist.citylist();
    store.overStore();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                horizontalpadding(child: searchField(onChanged: (val) => ())),
                SizedBox(height: Get.height / 50),
                SizedBox(
                  height: Get.height / 7,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: city.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SvgPicture.asset(AppIcon.allstore, fit: BoxFit.cover, height: 60),
                              Text(AppString.allStores),
                            ],
                          ),
                        );
                      } else {
                        final name = city[index - 1];
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SvgPicture.network(name['city_image'], fit: BoxFit.cover, height: 60),
                              Text(name['name']),
                            ],
                          ),
                        );
                      }},
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: stores.length,
                    itemBuilder: (BuildContext context, int index) {
                      final details =  stores['allstoreList'][index];
                      final cityname = details['store_city']['cityname'];
                      final image =  details['store_image_path'];
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
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                                Text('Contact :- '),
                                                Text(details['contact_number']),
                                              ],
                                            ),
                                            SizedBox(height: Get.height / 50),
                                            Text('See less info',style: TextStyle(color: AppColor.pink_color)),
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
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        child: button('Get Directions'),
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
    );
  }
}
