// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/wishlist.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:lottie/lottie.dart' show Lottie;

import '../../../../utils/app_json.dart';
import '../../category/showproduct.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final fetchwishlist = Get.put(FetchWishtlist());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchwishlist.fechwishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        lefticon: AppIcon.left,
        hedingname: AppString.wishlist,
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Obx(() {
            if (fetchwishlist.isLoading.value) {
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
            }

            return Column(
              children: [
                SizedBox(height: Get.height / 50),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: fetchwishlist.data['wishlists'].length,
                    itemBuilder: (BuildContext context, int index) {
                      final fetch = fetchwishlist.data['wishlists'][index]['WishlistJewelryData'];
                      return GestureDetector(
                        onTap: (){
                          if (kDebugMode) {
                            print(fetch['slug']);
                          }
                          Get.to(() => Showproduct(slug: fetch['slug']));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                            child: Column(
                          children: [
                            Image.network(fetch['default']['path'],width: 150,height: 150,),
                            Text(fetch['itemcode']),
                            Text(fetch['jewelry_diamonds'][index]['price'].toString()),
                            Text(fetchwishlist.data['wishlists'][index]['ringsize'].toString()),
                          ],
                        )),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
