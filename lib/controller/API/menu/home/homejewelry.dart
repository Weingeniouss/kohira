// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:kohira/view/utils/app_url.dart';
import '../../../../view/utils/app_constants.dart';


class Homejewelry extends GetxController{
  var isLoading = false.obs;
  var homejewelrydata = {}.obs;

  Future<void> getHomejewelry() async {
    try{
      isLoading.value = true;
      final url = Uri.parse(AppUrl.homecJewelry).toString();
      final responce = await dio.get(url);
      print('Sending to url :- $url');
      if(responce.statusCode == 200 || responce.statusCode == 201){
        homejewelrydata.assignAll(responce.data);
        print('home Jewellery data:- $homejewelrydata');
      }else{
        throw{
          'home Jewellery data ${responce.statusCode}, ${responce.data}',
        };
      }
    }catch(e){
      print('home Jewellery data Error :- $e');
    }finally{
      isLoading.value = false;
    }
  }
}