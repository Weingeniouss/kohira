// ignore_for_file: avoid_print, invalid_use_of_protected_member, non_constant_identifier_names, duplicate_ignore

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import 'package:lottie/lottie.dart';

import '../../../../view/utils/app_json.dart';
import '../../../../view/utils/errorcode.dart';

class Addtocart extends GetxController{
  var isLoading = false.obs;
  var data ={}.obs;

  final url = Uri.parse(AppUrl.addtocart);

  // ignore: non_constant_identifier_names
  Future<void>addtocartservice({
    String? jewelryid,
    String? qty,
    String? ringsize,
    String? metal_type,
    String? metal_stamp,
    String? sideDiaGrpId,
    required String tokan
  })
  async{
    try{
      isLoading.value = true;
      Get.dialog(Center(child: Lottie.asset(AppJson.loading2)), barrierDismissible: false);

      print("Sending request to: $url");
      final body = {
        'jewelryid' : jewelryid,
        'qty' : qty,
        'ringsize' : ringsize,
        'metal_type' : metal_type,
        'metal_stamp' : metal_stamp,
        'sideDiaGrpId' : sideDiaGrpId,
      }..removeWhere((key,value) => value == null);

      print('Request body: $body');
      
      final responcse = await http.post(url,body : body,headers: {ApiHeaders.authorization : tokan});

      if(responcse.statusCode == 200 || responcse.statusCode == 201){
        data.value = jsonDecode(responcse.body);
        print('Addtocart to cart data :-  $data');
        ToastificationSuccess.Success(data.value['message']);

        if(data.value['success'] == false){
          // ToastificationError.Error(data.value['message']);
          print(data.value['message']);
        }

      }else{
        throw{
          'Addtocart to cart data Error :- ${responcse.statusCode}, ${responcse.body}',
          print('${responcse.statusCode}, ${data.value['message']}'),
          handleHttpError(responcse.statusCode),
        };
      }
    }catch(e){
      print('Addtocart to cart data Error this :- $e');
      ToastificationError.Error('$e');
    }finally{
      isLoading.value = false;
      if (Get.isDialogOpen == true) Get.back();
    }
  }
}