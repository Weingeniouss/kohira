//counting items
// ignore_for_file: avoid_print, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../view/utils/API_headers.dart';
import '../../../../view/utils/app_url.dart';
import '../../../../view/utils/appconstants.dart';
import '../../../../view/utils/widget/pop.dart';

class CountCart extends GetxController{
  var isLoading = false.obs;
  var data = {}.obs;

  Future countcardcall({
    required String jewelryid,
    required String qty,
    String? ringsize,
    String? metal_type,
    String? metal_stamp,
    String? sideDiaGrpId
  })
  async{
    try{
      isLoading.value = true;

      final url = Uri.parse(AppUrl.countcart);
      final body = {
        if (jewelryid != null) 'jewelryid': jewelryid,
        if (qty != null) 'qty': qty.toString(),
        if (ringsize != null) 'ringsize': ringsize,
        if (metal_type != null) 'metal_type': metal_type,
        if (metal_stamp != null) 'metal_stamp': metal_stamp,
        if (sideDiaGrpId != null) 'sideDiaGrpId': sideDiaGrpId,
      }..removeWhere((key,value) => value == null);

      final responses = await http.post(url,body: body,headers: {ApiHeaders.heading: ApiHeaders.peramitters, ApiHeaders.authorization: tokans});
      print('Sending request to: $url');
      print('Countingcart body :- $body');

      if(responses.statusCode == 200 || responses.statusCode == 201){
        data.value = jsonDecode(responses.body);
        log("CountCart data :- $data");
        // ToastificationSuccess.Success(data['message']);
      }else{
        throw{
          'Fetchcart data Error This :- ${responses.statusCode}, ${responses.body}',
          print('CountCart data this :- ${responses.statusCode}, ${responses.body}'),
          ToastificationError.Error("CountCart data this :- ${responses.statusCode}, ${responses.body}"),
        };
      }
    }catch(e){
      print("Fetchcart data Error This :- $e");
      ToastificationError.Error("Fetchcart data Error This :- $e");
    }finally{
      isLoading.value = false;
    }
  }
}