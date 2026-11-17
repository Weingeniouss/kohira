// ignore_for_file: avoid_print, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'package:kohira/view/utils/app_url.dart';

import '../../../../modal/menu/home/slider.dart';
import 'package:kohira/api/api_call.dart';
import 'dart:convert';

class SliderModal {
  final url = AppUrl.slider;
  Future<Slider?> slider_service() async {
    try {
      final responce = await ApiCall.getRequest(url, useAuth: false);

      print("Sending request to: $url");

      if (responce != null) {
        final slider = sliderFromJson(jsonEncode(responce));
        print('Slider data :-  ${slider}');
        return slider;
      } else {
        throw {'Slider data Error :- ${responce}, ${200}'};
      }
    } catch (e) {
      print('Slider Data is Error :-  $e');
    }
    return null;
  }
}
