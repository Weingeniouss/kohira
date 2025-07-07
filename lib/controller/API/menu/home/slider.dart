// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:kohira/controller/service/menu/home/slider.dart';

import '../../../../modal/menu/home/slider.dart';
import '../../../../view/utils/widget/pop.dart';

class SliderCalling extends GetxController {
  var isLoading = false.obs;
  var data = <MainSliderDetail>[].obs;

  Future<void> slideruser() async {
    try {
      isLoading.value = true;

      final slider = await SliderModal().slider_service();

      if (slider != null && slider.success == true) {
        data.value = slider.mainSliderDetail ?? [];
        print('mainSliderDetail :- ${data.value}');

        // ToastificationSuccess.Success("'Success', ${slider.message}");
      } else {
        ToastificationError.Error("'Error', ${slider?.message}");
      }
    } catch (e) {
      print('Something When Wrong :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
