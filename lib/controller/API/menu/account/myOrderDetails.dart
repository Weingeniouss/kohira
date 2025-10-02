// ignore_for_file: avoid_print, unused_local_variable, file_names, invalid_use_of_protected_member, strict_top_level_inference

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;
import '../../../../view/utils/app_constants.dart';

class Myorderdetails extends GetxController{
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> myorderdatails(id)async{
    try{
      isLoading.value = true;
      final url =  Uri.parse('${AppUrl.orderdetail}$id/myorder');
      print("Sending Request To :- $url");

      final response = await http.get(url,headers: {ApiHeaders.heading: ApiHeaders.peramitters, ApiHeaders.authorization : tokans});

      if(response.statusCode == 200 || response.statusCode == 201){
        data.value = jsonDecode(response.body);
        log('My Order Details :- ${data.value}');
      }else{
        throw{
          'My Order Details Error this :- ${response.body}, ${response.statusCode}'
        };
      }
    }catch(e){
      print("My Order Details Error this :- $e");
    }finally{
      isLoading.value = false;
    }
  }
}