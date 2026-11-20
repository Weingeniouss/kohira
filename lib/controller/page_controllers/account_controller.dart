// ignore_for_file: unnecessary_import, unused_import, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/api/api_call.dart';
import 'package:kohira/view/utils/app_url.dart';

// API Controllers – Account
import '../API/menu/account/profiledetails.dart';
import '../API/menu/account/profile.dart';
import '../API/menu/account/wallet.dart';
import '../API/menu/account/myOrder.dart';
import '../API/menu/account/myOrderDetails.dart';
import '../API/menu/account/addresses.dart';

// Credentials APIs (logout + country/state used in address forms)
import '../API/credentials/logout.dart';
import '../API/credentials/country.dart';

// UI / other controllers
import '../user_inerface/menu/account/account.dart';
import '../user_inerface/menu/account/orderhistory.dart';

/// AccountPageController
/// Responsible for all APIs used on the Account screens:
///   - Profile details (view)
///   - Profile edit (update)
///   - Wallet balance
///   - My Orders list
///   - Order details by ID
///   - Addresses (fetch / add / edit / set default / delete)
///   - Country / State list (address form dropdowns)
///   - Logout
class AccountPageController extends GetxController {
  // =========================================================
  // STATE
  // =========================================================
  final _apiCallTracker = <String, bool>{}.obs;

  // =========================================================
  // CHILD API CONTROLLERS
  // =========================================================
  late final ProfiledetailsController profileDetails;
  late final ProfileEdit profileEdit;
  late final WalletController wallet;
  late final MyOrderController myOrder;
  late final Myorderdetails myOrderDetails;

  // Addresses
  late final Fechaddresses fechAddresses;
  late final EditFechaddresses editFechAddresses;
  late final Addaddresses addAddresses;
  late final SetDeflutAddress setDefaultAddress;
  late final DeletAddress deletAddress;

  // Credentials
  late final Logout logout;
  late final CountryCalling countryCalling;
  late final StateCalling stateCalling;

  // UI controllers
  late final AccountController account;
  late final OrderhistoryControll orderHistory;

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

    profileDetails = Get.isRegistered<ProfiledetailsController>()
        ? Get.find<ProfiledetailsController>()
        : Get.put(ProfiledetailsController());

    profileEdit = Get.isRegistered<ProfileEdit>()
        ? Get.find<ProfileEdit>()
        : Get.put(ProfileEdit());

    wallet = Get.isRegistered<WalletController>()
        ? Get.find<WalletController>()
        : Get.put(WalletController());

    myOrder = Get.isRegistered<MyOrderController>()
        ? Get.find<MyOrderController>()
        : Get.put(MyOrderController());

    myOrderDetails = Get.isRegistered<Myorderdetails>()
        ? Get.find<Myorderdetails>()
        : Get.put(Myorderdetails());

    fechAddresses = Get.isRegistered<Fechaddresses>()
        ? Get.find<Fechaddresses>()
        : Get.put(Fechaddresses());

    editFechAddresses = Get.isRegistered<EditFechaddresses>()
        ? Get.find<EditFechaddresses>()
        : Get.put(EditFechaddresses());

    addAddresses = Get.isRegistered<Addaddresses>()
        ? Get.find<Addaddresses>()
        : Get.put(Addaddresses());

    setDefaultAddress = Get.isRegistered<SetDeflutAddress>()
        ? Get.find<SetDeflutAddress>()
        : Get.put(SetDeflutAddress());

    deletAddress = Get.isRegistered<DeletAddress>()
        ? Get.find<DeletAddress>()
        : Get.put(DeletAddress());

    logout = Get.isRegistered<Logout>()
        ? Get.find<Logout>()
        : Get.put(Logout());

    countryCalling = Get.isRegistered<CountryCalling>()
        ? Get.find<CountryCalling>()
        : Get.put(CountryCalling());

    stateCalling = Get.isRegistered<StateCalling>()
        ? Get.find<StateCalling>()
        : Get.put(StateCalling());

    account = Get.isRegistered<AccountController>()
        ? Get.find<AccountController>()
        : Get.put(AccountController());

    orderHistory = Get.isRegistered<OrderhistoryControll>()
        ? Get.find<OrderhistoryControll>()
        : Get.put(OrderhistoryControll());
  }

  // =========================================================
  // LOAD ALL ACCOUNT APIs
  // =========================================================

  void _loadAll({bool forceRefresh = false}) {
    if (forceRefresh) _apiCallTracker.clear();

    _callIfNeeded('profile', () => profileDetails.profiledetailscall());
    _callIfNeeded('wallet', () => wallet.wallet());
    _callIfNeeded('addresses', () => fechAddresses.fechaddresses());
    _callIfNeeded('order_history', () => orderHistory.order.myOrder());
  }

  /// Public refresh
  @override
  void refresh() => _loadAll(forceRefresh: true);

  // =========================================================
  // INDIVIDUAL API WRAPPERS
  // =========================================================

  // ---- Profile ----

  /// GET: Profile details
  Future<dynamic> getProfileDetails() async {
    try {
      return await ApiCall.fetchProfileDetails();
    } catch (e) {
      print('AccountPageController getProfileDetails Error: $e');
      return null;
    }
  }

  /// POST: Edit / update profile
  Future<Map<String, dynamic>> postEditProfile({
    String? firstname,
    String? lastname,
    String? email,
    String? mobileno,
    required String change_password,
    String? old_password,
    String? password,
    String? confirm_password,
  }) async {
    try {
      return await profileEdit.profileedit(
        firstname: firstname,
        lastname: lastname,
        email: email,
        mobileno: mobileno,
        change_password: change_password,
        old_password: old_password,
        password: password,
        confirm_password: confirm_password,
      );
    } catch (e) {
      print('AccountPageController postEditProfile Error: $e');
      return {'success': false, 'message': '$e'};
    }
  }

  // ---- Wallet ----

  /// GET: Wallet balance
  Future<dynamic> getWallet() async {
    try {
      return await ApiCall.fetchWalletData();
    } catch (e) {
      print('AccountPageController getWallet Error: $e');
      return null;
    }
  }

  // ---- Orders ----

  /// GET: My orders list
  Future<dynamic> getOrders() async {
    try {
      return await ApiCall.fetchOrderList();
    } catch (e) {
      print('AccountPageController getOrders Error: $e');
      return null;
    }
  }

  /// GET: Order details by ID
  Future<dynamic> getOrderDetails(String id) async {
    try {
      return await ApiCall.fetchOrderDetails(id);
    } catch (e) {
      print('AccountPageController getOrderDetails Error: $e');
      return null;
    }
  }

  // ---- Addresses ----

  /// GET: All saved addresses
  Future<dynamic> getAddresses() async {
    try {
      return await ApiCall.fetchAddresses();
    } catch (e) {
      print('AccountPageController getAddresses Error: $e');
      return null;
    }
  }

  /// GET: Single address by ID
  Future<dynamic> getAddressById(String id) async {
    try {
      return await ApiCall.getRequest('${AppUrl.addressesfeach}/$id',
          useAuth: true);
    } catch (e) {
      print('AccountPageController getAddressById Error: $e');
      return null;
    }
  }

  /// POST: Add / update address
  Future<dynamic> postAddAddress({
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? companyname,
    String? address,
    String? city,
    String? state,
    String? country,
    String? countrycode,
    String? zip,
    String? mobileno,
    String? ip_address,
    String? isdefault,
  }) async {
    try {
      await addAddresses.addfechaddresses(
        id: id,
        firstname: firstname,
        lastname: lastname,
        email: email,
        companyname: companyname,
        address: address,
        city: city,
        state: state,
        country: country,
        countrycode: countrycode,
        zip: zip,
        mobileno: mobileno,
        ip_address: ip_address,
        isdefault: isdefault,
      );
    } catch (e) {
      print('AccountPageController postAddAddress Error: $e');
    }
  }

  /// GET: Set address as default
  Future<dynamic> setDefaultAddr(String id) async {
    try {
      await setDefaultAddress.setDefult(id: id);
    } catch (e) {
      print('AccountPageController setDefaultAddr Error: $e');
    }
  }

  /// POST: Delete address by ID
  Future<dynamic> deleteAddress(String id) async {
    try {
      await deletAddress.deletaddress(id: id);
    } catch (e) {
      print('AccountPageController deleteAddress Error: $e');
    }
  }

  // ---- Country / State ----

  /// GET: Country list (for address form)
  Future<dynamic> getCountries() async {
    try {
      await countryCalling.fetchCountryList();
      return countryCalling.countries;
    } catch (e) {
      print('AccountPageController getCountries Error: $e');
      return null;
    }
  }

  /// POST: State list by country ID
  Future<dynamic> getStates(String countryId) async {
    try {
      await stateCalling.stateList(countryId);
      return stateCalling.states;
    } catch (e) {
      print('AccountPageController getStates Error: $e');
      return null;
    }
  }

  // ---- Logout ----

  /// POST: Logout user
  Future<dynamic> postLogout() async {
    try {
      await logout.logout();
      return logout.logoutData;
    } catch (e) {
      print('AccountPageController postLogout Error: $e');
      return null;
    }
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
