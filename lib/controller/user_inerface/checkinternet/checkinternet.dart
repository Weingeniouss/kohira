import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetCheckerController extends GetxController {
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkConnection();

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      isConnected.value = result.any((r) => r != ConnectivityResult.none);
    });
  }

  Future<void> _checkConnection() async {
    var result = await Connectivity().checkConnectivity();
    isConnected.value = result.isNotEmpty && result.any((r) => r != ConnectivityResult.none);
  }

  void retryConnection() => _checkConnection();
}