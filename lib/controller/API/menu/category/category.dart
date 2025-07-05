// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:kohira/controller/service/menu/category/categrory.dart';
import 'package:kohira/view/utils/widget/pop.dart';

import '../../../../modal/menu/category/category.dart';

class CategoryCalling extends GetxController {
  var isLoading = false.obs;
  var data = <Data>[].obs;

  @override
  void onInit() {
    super.onInit();
    categroryservice();
  }

  Future<void> categroryservice() async {
    try {
      isLoading.value = true;

      final categoryResponse = await CategroryModal().categroryservice();

      if (categoryResponse != null && categoryResponse.success == true) {
        data.value = categoryResponse.data ?? [];

        // Debug prints
        print('Category list fetched:');
        for (var category in data) {
          print('ID: ${category.id}, Name: ${category.name}, Image: ${category.image}');
          for (var sub in category.subcategory ?? []) {
            print('   Sub: ${sub.name}, Image: ${sub.image}');
          }
        }
      } else {
        ToastificationError.Error('Category API failed: ${categoryResponse?.message}');
        print('Category API failed: ${categoryResponse?.message}');
      }
    } catch (e) {
      print('Error fetching category: $e');
    } finally {
      isLoading.value = false;
    }
  }
}