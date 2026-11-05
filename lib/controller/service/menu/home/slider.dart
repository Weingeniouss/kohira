// ignore_for_file: avoid_print, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'package:dio/dio.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';

import '../../../../modal/menu/home/slider.dart';

class SliderModal {
  final url = AppUrl.slider;
  Future<Slider?> slider_service() async {
    try {
      final responce = await DioClient.dio.get(
        url,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.peramitters,
            ApiHeaders.contect: ApiHeaders.peramitters,
          },
        ),
      );

      print("Sending request to: $url");

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        final slider = sliderFromJson(responce.data.toString());
        print('Slider data :-  ${slider}');
        return slider;
      } else {
        throw {'Slider data Error :- ${responce.data}, ${responce.statusCode}'};
      }
    } catch (e) {
      print('Slider Data is Error :-  $e');
    }
    return null;
  }
}
