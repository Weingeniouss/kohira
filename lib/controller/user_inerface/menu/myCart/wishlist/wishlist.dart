// ignore_for_file: dead_null_aware_expression, strict_top_level_inference, avoid_print

import 'package:get/get.dart';
import 'package:kohira/modal/menu/category/subcategory/addtowish.dart';
import '../../../../../view/utils/app_constants.dart';
import '../../../../../view/utils/app_string.dart';
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
  final wishlist = Get.put(Wishlist());

  var wishlistItems = <dynamic>[].obs;
  final bool isGuestUser = (tokans.isEmpty ?? true);
  RxList<JewelryItemWish> existingItemswish = <JewelryItemWish>[].obs;

  // Reactive set of wishlisted item IDs for INSTANT UI color change
  var wishlistedIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    if (isGuestUser) {
      final itemswish = await localdatabase.getJewelryItemsWish();
      existingItemswish.value = itemswish;
      wishlistedIds.assignAll(itemswish.map((item) => item.jewelryId.toString()));
      await withoutloginWish.withoutloginwishlist(itemswish);
    } else {
      await fetchwishlist.fechwishlist();
      await count.counting();
      _syncUserWishlistIds();
    }
  }

  void _syncUserWishlistIds() {
    final Set<String> ids = {};
    if (count.data['wishlist'] != null && count.data['wishlist']['jewelry_ids'] != null) {
      final rawIds = count.data['wishlist']['jewelry_ids'];
      if (rawIds is List) {
        ids.addAll(rawIds.map((e) => e.toString()));
      }
    }
    if (fetchwishlist.data['wishlists'] != null) {
      final rawList = fetchwishlist.data['wishlists'];
      if (rawList is List) {
        for (var w in rawList) {
          if (w['jewelryid'] != null) {
            ids.add(w['jewelryid'].toString());
          } else if (w['WishlistJewelryData'] != null && w['WishlistJewelryData']['id'] != null) {
            ids.add(w['WishlistJewelryData']['id'].toString());
          }
        }
      }
    }
    wishlistedIds.assignAll(ids);
  }

  bool isItemWishlisted(String id) {
    return wishlistedIds.contains(id.toString());
  }

  Future<void> toggleWishlist(dynamic item) async {
    final String id = item['id'].toString();
    final bool currentlyLiked = wishlistedIds.contains(id);

    // 1. INSTANT OPTIMISTIC COLOR & STATE TOGGLE (< 1ms)
    if (currentlyLiked) {
      wishlistedIds.remove(id);
      ToastificationSuccess.Success(AppString.removedFromWishlist);
    } else {
      wishlistedIds.add(id);
      ToastificationSuccess.Success(AppString.addedToWishlist);
    }
    wishlistedIds.refresh();

    // 2. BACKGROUND SYNC
    try {
      if (isGuestUser) {
        List<JewelryItemWish> currentItemswish = await localdatabase.getJewelryItemsWish();
        if (currentlyLiked) {
          currentItemswish.removeWhere((w) => w.jewelryId == id);
        } else {
          currentItemswish.add(JewelryItemWish(jewelryId: id, qty: 1));
        }
        await localdatabase.saveJewelryItemsWish(currentItemswish);
        existingItemswish.value = currentItemswish;
        withoutloginWish.withoutloginwishlist(currentItemswish);
      } else {
        await wishlist.wishlistservice(
          jewelryid: id,
          tokan: tokans,
          showDialog: false,
        );
        await count.counting();
        fetchwishlist.fechwishlist();
      }
    } catch (e) {
      // Revert state on error
      if (currentlyLiked) {
        wishlistedIds.add(id);
      } else {
        wishlistedIds.remove(id);
      }
      wishlistedIds.refresh();
      print('Wishlist toggle error: $e');
    }
  }

  Future<void> deleteItem(String id) async {
    wishlistedIds.remove(id.toString());
    wishlistedIds.refresh();
    await deletWishtlist.deletwishlist(id: id);
    if (deletWishtlist.data['type'] == 'success') {
      wishlistItems.removeWhere((item) => item['id'].toString() == id);
      count.counting();
      await fetchwishlist.fechwishlist();
    } else if (deletWishtlist.data['success'] == false) {
      final errors = deletWishtlist.data['errors'];
      if (errors != null && errors.containsKey('id')) {
        ToastificationError.Error(errors['id'][0]);
      }
    }
  }
}
