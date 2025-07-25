import 'package:get/get.dart';

import '../../../API/menu/account/myOrder.dart';

class OrderhistoryControll extends GetxController {
  final order = Get.put(MyOrderController());

  @override
  void onInit() {
    super.onInit();
    order.myOrder();
  }
}
