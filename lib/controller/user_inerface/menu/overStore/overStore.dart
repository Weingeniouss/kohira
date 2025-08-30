// ignore_for_file: file_names, camel_case_types

import 'dart:async';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../view/utils/app_url.dart';
import '../../../API/menu/overstore/citylist.dart';
import '../../../API/menu/overstore/overStore.dart';

class Overstore_Conteroller extends GetxController {
  final store = Get.put(Overstore_Controller());
  final citylist = Get.put(Citylist());
  List<bool> seePeraList = [];
  @override
  void onInit() {
    super.onInit();
    _initializeSeePeraList();

    ever(store.isLoading, (_) {
      if (!store.isLoading.value) {
        _initializeSeePeraList();
      }
    });
  }

  void _initializeSeePeraList() {
    final allStores = store.data['data']?['allstoreList'] as List?;
    seePeraList = List.filled(allStores?.length ?? 0, false);
  }

  void persee(int index) {
    seePeraList[index] = !seePeraList[index];
    update();
  }

  Future<void> openMapDirections(double lat, double lng, String label) async {
    final String url = '${GoogleUrl.googlesarch}?api=1&query=$lat,$lng&query_place_id=$label';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future submitval(val) async{
   await store.overStore(search: val);
    update();
  }
}
