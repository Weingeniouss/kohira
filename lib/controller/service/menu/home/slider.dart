// ignore_for_file: avoid_print, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';

import '../../../../modal/menu/home/slider.dart';

class SliderModal {
  final url = Uri.parse(AppUrl.slider);
  Future<Slider?> slider_service() async {
    try {
      final responce = await http.get(
          url,
          headers: {
           ApiHeaders.heading: ApiHeaders.peramitters,
           ApiHeaders.contect: ApiHeaders.peramitters
         });

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        final slider = sliderFromJson(responce.body);
        print('Slider data :-  ${slider}');
        return slider;
      } else {
        throw {'Slider data Error :- ${responce.body}, ${responce.statusCode}'};
      }
    } catch (e) {
      print('Slider Data is Error :-  $e');
    }
    return null;
  }
}
