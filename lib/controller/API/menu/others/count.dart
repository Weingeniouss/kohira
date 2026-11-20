// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:kohira/api/api_call.dart';
import 'package:kohira/controller/database/local/localstore.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/app_url.dart';

class CountController extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  var cartCountRx = 0.obs;
  var wishCountRx = 0.obs;

  @override
  void onInit() {
    super.onInit();
    updateCounts();
  }

  Future<void> updateCounts() async {
    if (!islogin || tokans.isEmpty) {
      final cartItems = await localdatabase.getJewelryItems();
      final wishItems = await localdatabase.getJewelryItemsWish();

      int cCount = 0;
      for (var item in cartItems) {
        cCount += (item.qty ?? 1);
      }
      cartCountRx.value = cCount;
      wishCountRx.value = wishItems.length;

      cartCount = cartCountRx.value.toString();
      wishCount = wishCountRx.value.toString();
      pref?.setString('count', cartCount);
      pref?.setString('wishcount', wishCount);
    } else {
      await counting();
    }
  }

  Future counting() async {
    if (!islogin || tokans.isEmpty) {
      await updateCounts();
      return;
    }

    try {
      isLoading.value = true;
      final url = AppUrl.count;
      final responce = await ApiCall.getRequest(url, useAuth: true);
      if (responce != null) {
        data.value = jsonDecode(jsonEncode(responce));
        if (data['cart'] != null && data['cart']['count'] != null) {
          cartCountRx.value = int.tryParse(data['cart']['count'].toString()) ?? 0;
        }
        if (data['wishlist'] != null && data['wishlist']['count'] != null) {
          wishCountRx.value = int.tryParse(data['wishlist']['count'].toString()) ?? 0;
        }
        cartCount = cartCountRx.value.toString();
        wishCount = wishCountRx.value.toString();
      }
    } catch (e) {
      print("Counting Error :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
