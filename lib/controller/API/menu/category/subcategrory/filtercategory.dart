// ignore_for_file: avoid_print

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../../../modal/menu/category/subcategory/filtercategory.dart';
import '../../../../service/menu/category/subcategory/filtercategory.dart';

class JewelleryFilterCategory extends GetxController {
  var isLoading = false.obs;
  var filterData = Rxn<Filtercategory>();
  var selectedSlug = "".obs;

  final _service = FilterCategoryService();

  @override
  void onInit() {
    super.onInit();
    fetchFilter();
  }

  void fetchFilter() async {
    isLoading.value = true;
    final result = await _service.fetchFilter();
    if (result != null) {
      filterData.value = result;
    }
    isLoading.value = false;
  }

  void selectCategorySlug(String slug) {
    selectedSlug.value = slug;
    print("Selected category slug: $slug");
  }
}