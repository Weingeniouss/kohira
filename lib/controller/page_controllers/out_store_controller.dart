// ignore_for_file: unnecessary_import, unused_import, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/api/api_call.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

// API Controllers – OverStore
import '../API/menu/overstore/overStore.dart';
import '../API/menu/overstore/citylist.dart';
import '../API/menu/overstore/overstoredetails.dart';

// UI Controller – Store locations (home map widget)
import '../user_inerface/menu/overStore/store_locations_controller.dart';

/// OutStoreController  (Our Stores / Over Store)
/// Responsible for all APIs used on the OverStore / Our Stores screens:
///   - Store list (search + city filter)
///   - City list (filter dropdown)
///   - Store details by slug
///   - Store Locations (map / home widget)
class OutStorePageController extends GetxController {
  // =========================================================
  // STATE
  // =========================================================
  final _apiCallTracker = <String, bool>{}.obs;

  // =========================================================
  // CHILD API CONTROLLERS
  // =========================================================
  late final Overstore_Controller store;
  late final Citylist citylist;
  late final OverStoreDetails overStoreDetails;
  late final StoreLocationsController storeLocations;

  bool _initialized = false;

  // =========================================================
  // LIFECYCLE
  // =========================================================
  @override
  void onInit() {
    super.onInit();
    _initControllers();
    _loadAll();
  }

  void _initControllers() {
    if (_initialized) return;
    _initialized = true;

    store = Get.isRegistered<Overstore_Controller>()
        ? Get.find<Overstore_Controller>()
        : Get.put(Overstore_Controller());

    citylist = Get.isRegistered<Citylist>()
        ? Get.find<Citylist>()
        : Get.put(Citylist());

    overStoreDetails = Get.isRegistered<OverStoreDetails>()
        ? Get.find<OverStoreDetails>()
        : Get.put(OverStoreDetails());

    storeLocations = Get.isRegistered<StoreLocationsController>()
        ? Get.find<StoreLocationsController>()
        : Get.put(StoreLocationsController());
  }

  // =========================================================
  // LOAD ALL OVER-STORE APIs
  // =========================================================

  bool _isCitySelected = false;

  void _loadAll({bool forceRefresh = false}) {
    if (forceRefresh) _apiCallTracker.clear();

    _callIfNeeded('city_list', () => citylist.citylist());
    if (!_isCitySelected) {
      _callIfNeeded('over_store', () => store.overStore());
    }
    _callIfNeeded('storeLocations', () => storeLocations.fetchStoreLocations());
  }

  /// Public refresh
  @override
  void refresh() => _loadAll(forceRefresh: true);

  // =========================================================
  // INDIVIDUAL API WRAPPERS
  // =========================================================

  /// GET: City list for filter dropdown
  Future<dynamic> getCityList() async {
    try {
      return await ApiService.getApi(AppUrl.storecity, useAuth: false);
    } catch (e) {
      print('OutStoreController getCityList Error: $e');
      return null;
    }
  }

  /// POST: Store list with optional search and city filter
  Future<dynamic> getStoreList({
    String? page,
    String? search,
    String? storeCityId,
  }) async {
    try {
      await store.overStore(
        page: page,
        search: search,
        store_city_id: storeCityId,
      );
      return store.data;
    } catch (e) {
      print('OutStoreController getStoreList Error: $e');
      return null;
    }
  }

  /// POST: Store list – shortcut matching HomeController.postStoreData
  Future<dynamic> postStoreData({
    String? search,
    String? storeCityId,
  }) async {
    try {
      return await ApiCall.fetchStoreData(
          search: search, storeCityId: storeCityId);
    } catch (e) {
      print('OutStoreController postStoreData Error: $e');
      return null;
    }
  }

  /// GET: Store details by slug
  Future<dynamic> getStoreDetails(String slug) async {
    try {
      await overStoreDetails.getOverStoreDetails(slug);
      return overStoreDetails.overStoreDetailsData;
    } catch (e) {
      print('OutStoreController getStoreDetails Error: $e');
      return null;
    }
  }

  /// GET: Store locations (map widget)
  Future<dynamic> getStoreLocations() async {
    try {
      return await ApiCall.fetchStoreLocationsData();
    } catch (e) {
      print('OutStoreController getStoreLocations Error: $e');
      return null;
    }
  }

  List<bool> seePeraList = [];

  RxMap get cityListData => citylist.data;
  RxMap get storeData => store.data;
  RxBool get isLoading => store.isLoading;

  void _initializeSeePeraList() {
    final allStores = store.data['data']?['allstoreList'] as List?;
    seePeraList = List.filled(allStores?.length ?? 0, false);
    update();
  }

  void persee(int index) {
    if (index < seePeraList.length) {
      seePeraList[index] = !seePeraList[index];
      update();
    }
  }

  Future<void> openMapDirections(double lat, double lng, String label) async {
    final String url =
        '${GoogleUrl.googlesarch}?api=1&query=$lat,$lng&query_place_id=$label';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future submitval(dynamic val) async {
    await store.overStore(search: val);
    _initializeSeePeraList();
  }

  Future filterByCity(String cityId, {String? cityName}) async {
    _isCitySelected = true;
    await store.overStore(store_city_id: cityId, city: cityName);
    _initializeSeePeraList();
  }

  Future fetchStoreData({String? search, String? storeCityId}) async {
    if (storeCityId != null && storeCityId.isNotEmpty) {
      _isCitySelected = true;
    } else {
      _isCitySelected = false;
    }
    await store.overStore(search: search, store_city_id: storeCityId);
    _initializeSeePeraList();
  }

  // =========================================================
  // UTILS
  // =========================================================
  void _callIfNeeded(String key, Function call) {
    if (_apiCallTracker[key] == true) return;
    _apiCallTracker[key] = true;
    call();
  }

  @override
  void onClose() {
    _apiCallTracker.clear();
    super.onClose();
  }
}
