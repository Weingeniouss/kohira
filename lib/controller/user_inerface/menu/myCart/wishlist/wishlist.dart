// ignore_for_file: strict_top_level_inference

import 'package:get/get.dart';
import 'package:kohira/modal/menu/category/subcategory/addtowish.dart';
import '../../../../../view/utils/app_constants.dart';
import '../../../../../view/utils/widget/pop.dart';
import '../../../../API/menu/category/wishlist.dart';
import '../../../../API/menu/myCart/withoutlogin.dart';
import '../../../../API/menu/others/count.dart';
import '../../../../database/local/localstore.dart';

class WishlistController extends GetxController {
  final fetchwishlist = Get.put(FetchWishtlist());
  final withoutloginWish = Get.put(WithoutloginWishList());
  final deletWishtlist = Get.put(DeletWishtlist());
  final count = Get.put(CountController());

  var wishlistItems = <dynamic>[].obs;
  final bool isGuestUser = (tokans?.isEmpty ?? true);
  RxList<JewelryItemWish> existingItemswish = <JewelryItemWish>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  loadWishlist() async{
    if (isGuestUser) {
      final itemswish = await localdatabase.getJewelryItemsWish();
      existingItemswish.value = itemswish;
      await withoutloginWish.withoutloginwishlist(itemswish);
    }else{
      fetchwishlist.fechwishlist();
      count.counting();
    }
  }

  Future<void> deleteItem(String id) async {
    await deletWishtlist.deletwishlist(id: id);
    if (deletWishtlist.data['type'] == 'success') {
      wishlistItems.removeWhere((item) => item['id'].toString() == id);
      count.counting();
      await fetchwishlist.fechwishlist();
    } else if (deletWishtlist.data['success'] == false) {
      final errors = deletWishtlist.data['errors'];
      if (errors != null && errors.containsKey('id')) {
        if (errors != null && errors.containsKey('id')) ToastificationError.Error(errors['id'][0]);
      }
    }
  }
}