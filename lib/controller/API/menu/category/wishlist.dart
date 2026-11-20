// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable, avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_constants.dart';

import 'package:kohira/view/utils/app_url.dart';

import 'package:kohira/view/utils/errorcode.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import 'package:lottie/lottie.dart';
import '../../../../view/utils/app_json.dart';
import 'package:kohira/api/api_call.dart';

//Add WishList
class Wishlist extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  var savedWishlist = <String>[].obs;

  Future<void> wishlistservice({
    String? jewelryid,
    String? qty,
    String? ringsize,
    String? metal_type,
    String? metal_stamp,
    String? sideDiaGrpId,
    required String tokan,
    bool showDialog = true,
  }) async {
    try {
      isLoading.value = true;
      if (showDialog) {
        Get.dialog(
          Center(child: Lottie.asset(AppJson.loading2)),
          barrierDismissible: false,
        );
      }

      final url = AppUrl.wishlist;
      print("Sending request to: $url");

      final body = {
        'jewelryid': jewelryid,
        'qty': qty,
        'ringsize': ringsize,
        'metal_type': metal_type,
        'metal_stamp': metal_stamp,
        'sideDiaGrpId': sideDiaGrpId,
      }..removeWhere((key, value) => value == null);

      print('Wishlist body :- $body');

      final response =
          await ApiCall.postRequest(url, data: body, useAuth: false);

      if (response != null) {
        data.value = jsonDecode(jsonEncode(response));
        log('Add to wishlist response :- $data');
        if (data['message'] != null && data['message'].toString().isNotEmpty) {
          ToastificationSuccess.Success(data['message']);
        }
      } else {
        throw 'Add to wishlist Error :- $response, ${200}';
      }
    } catch (e) {
      print('Add to wishlist Error :- $e');
    } finally {
      isLoading.value = false;
      if (showDialog && Get.isDialogOpen == true) Get.back();
    }
  }
}

//FetchWish List
class FetchWishtlist extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future fechwishlist() async {
    if (!islogin || tokans.isEmpty) {
      isLoading.value = false;
      return;
    }
    try {
      isLoading.value = true;
      final url = AppUrl.wishlist;
      print("Sending Request To :- $url");
      final responce = await ApiCall.getRequest(url, useAuth: true);
      if (responce != null) {
        data.value = jsonDecode(jsonEncode(responce));
        log("Wishlist data :- ${data.value}");
      } else {
        throw {
          'Wishlist data Error :- ${200}, $responce',
        };
      }
    } catch (e) {
      print('Wishlist data Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}

//Delet WishList
class DeletWishtlist extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;
  Future deletwishlist({required String id}) async {
    try {
      isLoading.value = true;
      final url = AppUrl.wishlistdelete;
      final body = {'id': id};
      print("Sending Request To :- $url");
      print("Sending Request To delet Wishlist :- $body");
      final responce =
          await ApiCall.postRequest(url, data: body, useAuth: true);
      if (responce != null) {
        data.value = jsonDecode(jsonEncode(responce));
        log("Wishlist data :- ${data.value}");
      } else {
        throw {
          'Wishlist data Error :- ${200}, $responce',
          handleHttpError(200),
        };
      }
    } catch (e) {
      print('Wishlist data Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
