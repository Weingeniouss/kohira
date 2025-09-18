import 'package:get/get.dart';

import '../../../API/menu/account/wallet.dart';
import 'myCart.dart';

class BuynowController extends GetxController {
  final myCart = Get.put(MyCartValueChange());
  final wallet = Get.put(WalletController());

  var allTotalvalue = 0.obs;
  var walletvalue = 0.obs;
  var useWallet = 0.obs;

  var ischeack = false.obs;

  @override
  void onInit() {
    super.onInit();

    /// Keep wallet amount
    walletvalue.value = (wallet.data['myWalletAmount'] ?? 0) as int;

    /// Whenever subtotal changes in MyCart, recalc values
    ever(myCart.subTotal, (_) => updateValues());

    /// Initialize first time
    updateValues();
  }

  void updateValues() {
    allTotalvalue.value = (myCart.subTotal.value).toInt();
    if (ischeack.value) {
      useWallet.value = allTotalvalue.value - walletvalue.value;
      if (walletvalue.value >= allTotalvalue.value) {
        useWallet.value = 0;
      }
    } else {
      useWallet.value = allTotalvalue.value;
    }
  }

  void ischack() {
    ischeack.value = !ischeack.value;
    updateValues();
  }
}