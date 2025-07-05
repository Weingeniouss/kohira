// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:kohira/controller/service/menu/home/categories.dart';
import '../../../../modal/menu/home/categories.dart';
import '../../../../view/utils/widget/pop.dart';

class CategoriesCalling extends GetxController {
  var isLoading = false.obs;
  var data = <Category>[].obs;

  Future<void> categoriesuser() async {
    try {
      isLoading.value = true;

      final categories = await CategoriesModal().categories_Service();

      if (categories != null && categories.success == true) {
        data.value = categories.category ?? [];
        print('category :- ${data.value}');

         for (var category in data) {
         print('ID: ${category.id}, Name: ${category.name}, Image: ${category.image}');
        }

        // Or print as JSON
       print('JSON format: ${data.map((e) => e.toJson()).toList()}');

        // ToastificationSuccess.Success("'Success', ${categories.message}");
      } else {
        ToastificationError.Error("'Error', ${categories?.message}");
      }
    } catch (e) {
      print('Something When Wrong :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
