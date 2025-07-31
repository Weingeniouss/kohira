import 'package:get/get.dart';
import '../../../../../view/utils/widget/pop.dart';
import '../../../../API/menu/category/wishlist.dart';
import '../../../../API/menu/others/count.dart';

class WishlistController extends GetxController {
  final fetchwishlist = Get.put(FetchWishtlist());
  final deletWishtlist = Get.put(DeletWishtlist());
  final count = Get.put(CountController());

  var wishlistItems = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  loadWishlist(){
    fetchwishlist.fechwishlist();
    count.counting();
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