// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import 'package:lottie/lottie.dart';

import '../../../../view/utils/app_json.dart';

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
   try{
     isLoading.value = true;
     Get.dialog(Center(child: Lottie.asset(AppJson.loading2)), barrierDismissible: false);

     final url = Uri.parse(AppUrl.wishlist);
     print("Sending request to: $url");
     final body = {
       'jewelryid': jewelryid,
       'qty': qty,
       'ringsize': ringsize,
       'metal_type': metal_type,
       'metal_stamp': metal_stamp,
       'sideDiaGrpId': sideDiaGrpId,
     }..removeWhere((key,value) => value == null);

     print('Whishlist body :- $body');
     final response = await http.post(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters , ApiHeaders.authorization : tokan}, body: body);

     if(response.statusCode == 200 || response.statusCode == 201){
       data.value = jsonDecode(response.body);
       log('Add to cart :- $data');
       ToastificationSuccess.Success(data['message']);

       if(data['success'] == false){
         // ToastificationError.Error(data.value['message']);
         print(data['message']);
       }

     }else{
       throw{
         'Add to cart Error this :-  ${response.body}, ${response.statusCode}'
       };
     }
   }catch(e){
     print('Add to cart Error this :- $e');
     ToastificationSuccess.Success('$e');
   }finally{
     isLoading.value = true;
     if (Get.isDialogOpen == true) Get.back();
   }
  }
}
