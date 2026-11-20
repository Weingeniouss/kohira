// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:kohira/modal/menu/category/subcategory/addtowish.dart';

import 'package:kohira/view/utils/app_url.dart';

import '../../../../modal/menu/category/subcategory/addtocart.dart';
import 'package:kohira/api/api_call.dart';

//Add and Show to Cart witoutLogin
class Withoutlogin extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> withoutlogin(List<JewelryItem> cartData,
      {String couponCode = ''}) async {
    try {
      isLoading(true);
      final url = '${AppUrl.withoutlogin}?coupon_code=$couponCode';
      print("Sending TO Url :- $url");

      final cartDataJson =
          jsonEncode(cartData.map((item) => item.toJson()).toList());

      final formData = FormData.fromMap({
        'cartData': cartDataJson,
        'testing': 'yes',
      });

      print("Request formData Cart: cartData=$cartDataJson, testing=yes");

      final response =
          await ApiCall.postRequest(url, data: formData, useAuth: false);

      if (response != null) {
        if (response is Map) {
          data.value = Map<String, dynamic>.from(response);
        } else if (response is String) {
          data.value = jsonDecode(jsonEncode(response));
        } else {
          data.value = jsonDecode(jsonEncode(response));
        }
        log("WithoutCart To Add Success :- $data");
      } else {
        throw Exception('WithoutCart To Add Error: ${200}, $response');
      }
    } catch (e) {
      print('WithoutCart To Add Error: $e');
    } finally {
      isLoading(false);
    }
  }
}

//Add and Show to Wishlist witoutLogin
class WithoutloginWishList extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> withoutloginwishlist(List<JewelryItemWish> wishData) async {
    try {
      isLoading(true);
      final url = AppUrl.wishlistwithoutlogin;
      print("Sending TO Url :- $url");

      final wishDataJson =
          jsonEncode(wishData.map((item) => item.toJson()).toList());

      final formData = FormData.fromMap({
        'wishData': wishDataJson,
        'testing': 'yes',
      });

      print("Request formData Wishlist: wishData=$wishDataJson, testing=yes");

      final response =
          await ApiCall.postRequest(url, data: formData, useAuth: false);

      if (response != null) {
        if (response is Map) {
          data.value = Map<String, dynamic>.from(response);
        } else if (response is String) {
          data.value = jsonDecode(jsonEncode(response));
        } else {
          data.value = jsonDecode(jsonEncode(response));
        }
        log("WithoutwishData To Add Success :- $data");
      } else {
        throw Exception('WithoutwishData To Add Error: ${200}, $response');
      }
    } catch (e) {
      print('WithoutwishData To Add Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
