// ignore_for_file: file_names, camel_case_types

import 'dart:async';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../view/utils/app_url.dart';
import '../../../API/menu/overstore/citylist.dart';
import '../../../API/menu/overstore/overStore.dart';

class Overstore_Conteroller extends GetxController{
  final store =  Get.put(Overstore_Controller());
  final citylist =  Get.put(Citylist());

  List<bool> seePeraList = [];

  @override
  void onInit() {
    super.onInit();
    // Initialize when data is already present
    if (store.data['data']?['allstoreList'] != null) {
      final allStores = store.data['data']['allstoreList'] as List;
      seePeraList = List.filled(allStores.length, false);
    }

    // Whenever store updates, reset seePeraList length
    ever(store.isLoading, (_) {
      if (!store.isLoading.value && store.data['data']?['allstoreList'] != null) {
        final allStores = store.data['data']['allstoreList'] as List;
        seePeraList = List.filled(allStores.length, false);
      }
    });
  }

  void persee(int index) {
    seePeraList[index] = !seePeraList[index];
    update();
  }

  // Function to open Google Maps with directions
  Future<void> openMapDirections(double lat, double lng, String label) async {
    final String url = '${GoogleUrl.googlesarch}?api=1&query=$lat,$lng&query_place_id=$label';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Timer? debounce;
  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  void sarchVal(val){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(seconds: 6), () {
      store.overStore(search: val);
    });
  }

  void submitval(val){
    if (debounce?.isActive ?? false) debounce!.cancel();
    store.overStore(search: val);
  }
}
