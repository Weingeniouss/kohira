// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as https;
import 'package:kohira/view/utils/app_url.dart';
import '../../../../modal/menu/category/subcategory/addtocart.dart';

class Withoutlogin extends GetxController{
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> withoutlogin(List<JewelryItem> cartData) async {
    try{
      isLoading(true);
      final url = Uri.parse(AppUrl.withoutlogin);
      print("Sending TO Url :- $url");

      final cartDataJson = jsonEncode(cartData.map((item) => item.toJson()).toList());

      final body = {'cartData': cartDataJson,};

      print("Request body: $body");

      final response = await https.post(url, body: body);

      if(response.statusCode == 200 || response.statusCode == 201){
        data.value = jsonDecode(response.body);
        log("WithoutCart To Add Success :- $data");
      }else{
        throw Exception('WithoutCart To Add Error: ${response.statusCode}, ${response.body}'
        );
      }
    } catch(e) {
      print('WithoutCart To Add Error: $e');
    } finally {
      isLoading(false);
    }
  }
}