import 'package:get/get.dart';

import '../../../API/menu/account/wallet.dart';
import 'myCart.dart';

class BuynowController extends GetxController {
  final myCart = Get.put(MyCartValueChange());
  final wallet = Get.put(WalletController());

  late RxInt allTotalvalue = ((myCart.fetchcart.data['cart_gross'] ?? 0) as int).obs;
  late RxInt walletvalue = ((wallet.data['myWalletAmount'] ?? 0) as int).obs;
  late RxInt useWallet = (allTotalvalue.value).obs;

  var ischeack = false.obs;

  void ischack() {
    ischeack.value =! ischeack.value;
    if (ischeack.value == true) {
      useWallet.value = allTotalvalue.value - walletvalue.value;
       if(walletvalue.value >= allTotalvalue.value){
         useWallet.value = 0;
       }
    }else{
      useWallet.value = allTotalvalue.value;
    }
    update();
  }
}