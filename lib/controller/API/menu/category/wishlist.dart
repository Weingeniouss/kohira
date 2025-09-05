// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable, avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/errorcode.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import 'package:lottie/lottie.dart';
import '../../../../view/utils/app_json.dart';

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
    required String tokan
  }) async {
    try {
      isLoading.value = true;
      Get.dialog(
        Center(child: Lottie.asset(AppJson.loading2)),
        barrierDismissible: false,
      );

      final url = Uri.parse(AppUrl.wishlist);
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

      final response = await http.post(
        url,
        headers: {
          ApiHeaders.heading: ApiHeaders.peramitters,
          ApiHeaders.authorization: tokan
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        data.value = jsonDecode(response.body);
        log('Add to wishlist response :- $data');
        ToastificationSuccess.Success(data['message']);
      } else {
        throw 'Add to wishlist Error :- ${response.body}, ${response.statusCode}';
      }
    } catch (e) {
      print('Add to wishlist Error :- $e');
      ToastificationSuccess.Success('$e');
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) Get.back();
    }
  }
}

//FetchWish List
class FetchWishtlist extends GetxController{
  var isLoading = false.obs;
  var data = {}.obs;

  Future fechwishlist()async{
    try{
      isLoading.value = true;
      final url = Uri.parse(AppUrl.wishlist);
      print("Sending Request To :- $url");
      final responce = await http.get(url,headers: {ApiHeaders.heading : ApiHeaders.peramitters, ApiHeaders.authorization : tokans});
      if(responce.statusCode == 200 || responce.statusCode == 201){
        data.value = jsonDecode(responce.body);
        log("Wishlist data :- ${data.value}");
      }else{
        throw{
          'Wishlist data Error :- ${responce.statusCode}, ${responce.body}',
          handleHttpError(responce.statusCode),
        };
      }
    }catch(e){
      print('Wishlist data Error :- $e');
    }finally{
      isLoading.value = false;
    }
  }
}

//Delet WishList
class DeletWishtlist extends GetxController{
  var isLoading = false.obs;
  var data = {}.obs;
  Future deletwishlist({required String id})async{
    try{
      isLoading.value = true;
      final url = Uri.parse(AppUrl.wishlistdelete);
      final body = {'id' : id};
      print("Sending Request To :- $url");
      print("Sending Request To delet Wishlist :- $body");
      final responce = await http.post(url,body: body, headers: {ApiHeaders.heading : ApiHeaders.peramitters, ApiHeaders.authorization : tokans});
      if(responce.statusCode == 200 || responce.statusCode == 201){
        data.value = jsonDecode(responce.body);
        log("Wishlist data :- ${data.value}");
      }else{
        throw{
          'Wishlist data Error :- ${responce.statusCode}, ${responce.body}',
          handleHttpError(responce.statusCode),
        };
      }
    }catch(e){
      print('Wishlist data Error :- $e');
    }finally{
      isLoading.value = false;
    }
  }
}
