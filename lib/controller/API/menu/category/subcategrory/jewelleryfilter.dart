// ignore_for_file: avoid_print

import 'package:get/get.dart';
import '../../../../../modal/menu/category/subcategory/jewelleryfilter.dart';
import '../../../../service/menu/category/subcategory/jewelleryfilter.dart';

class Jewelleryfilter extends GetxController {
  var isLoading = false.obs;
  var data = Rxn<JewelleryFilterModel>();

  final _service = JewelleryFilterService();

  @override
  void onInit() {
    super.onInit();
    fetchJewelleryFilter();
  }

  Future<void> fetchJewelleryFilter() async {
    isLoading.value = true;
    try {
      final result = await _service.fetchFilter();
      if (result != null) {
        data.value = result;
      } else {
        // ToastificationError.Error('Failed to fetch jewellery filter data');
        print('Failed to fetch jewellery filter data');
      }
    } catch (e) {
      // ToastificationError.Error('Something went wrong: $e');
      print('Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}