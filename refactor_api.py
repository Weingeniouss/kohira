import os
import re

lib_dir = r"C:\Users\soni\StudioProjects\kohira\lib"
api_dir = os.path.join(lib_dir, "controller", "API")
target_api_call_path = os.path.join(lib_dir, "api", "api_call.dart")

os.makedirs(os.path.dirname(target_api_call_path), exist_ok=True)

# 1. Parse all API controller files
methods = []
for root, _, files in os.walk(api_dir):
    for file in files:
        if file.endswith(".dart"):
            file_path = os.path.join(root, file)
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()

            # Find methods like: Future<void> fetchSomething(...) async {
            # or Future something(...) async {
            matches = re.finditer(r"Future(?:<.*?>)?\s+(\w+)\s*\((.*?)\)\s*async\s*\{", content)
            for m in matches:
                method_name = m.group(1)
                params = m.group(2)
                methods.append({
                    'file': file_path,
                    'method_name': method_name,
                    'params': params,
                    'content': content
                })

# Wait, replacing everything automatically via script might break things if not careful.
# Let's just generate a comprehensive ApiCall class based on the AppUrl endpoints for now.
# And provide the methods explicitly requested: fetchStoreData, fetchProductData, etc.

import textwrap
api_call_content = textwrap.dedent("""\
    import 'dart:convert';
    import 'package:kohira/services/api_service.dart';
    import 'package:kohira/view/utils/app_url.dart';

    class ApiCall {
      // OVER STORE
      static Future<dynamic> fetchStoreData({String? search, String? storeCityId}) async {
        final body = {
          if (search != null) 'search': search,
          if (storeCityId != null) 'store_city_id': storeCityId,
        };
        return await ApiService.postApi(AppUrl.store, data: body, useAuth: false);
      }

      static Future<dynamic> fetchStoreCityData() async {
        return await ApiService.getApi(AppUrl.storecity, useAuth: false);
      }

      static Future<dynamic> fetchStoreDetailsData(String slug) async {
        return await ApiService.getApi('${AppUrl.storedetails}/$slug', useAuth: false);
      }

      static Future<dynamic> fetchStoreLocationsData() async {
        return await ApiService.getApi(AppUrl.store_locations, useAuth: false);
      }

      // HOME
      static Future<dynamic> fetchCategoryData() async {
        return await ApiService.getApi(AppUrl.categories, useAuth: false);
      }

      static Future<dynamic> fetchDashboardData() async {
        return await ApiService.getApi(AppUrl.homeDashbord, useAuth: false);
      }

      static Future<dynamic> fetchBannerData() async {
        return await ApiService.getApi(AppUrl.offerbanner, useAuth: false);
      }

      static Future<dynamic> fetchSliderData() async {
        return await ApiService.getApi(AppUrl.slider, useAuth: false);
      }

      static Future<dynamic> fetchHomeJewelryData() async {
        return await ApiService.getApi(AppUrl.homecJewelry, useAuth: false);
      }

      static Future<dynamic> fetchHomeCollectionData() async {
        return await ApiService.getApi(AppUrl.homecollcation, useAuth: false);
      }

      static Future<dynamic> fetchNewsListData() async {
        return await ApiService.getApi(AppUrl.homenewslist, useAuth: false);
      }

      static Future<dynamic> searchApi(String query) async {
        return await ApiService.getApi('${AppUrl.search}?search=$query', useAuth: false);
      }

      // CATEGORY & PRODUCTS
      static Future<dynamic> fetchProductData({String? categoryId, String? search}) async {
        final params = <String, dynamic>{};
        if (categoryId != null) params['category'] = categoryId;
        if (search != null) params['search'] = search;
        return await ApiService.getApi(AppUrl.product, queryParameters: params, useAuth: false);
      }

      static Future<dynamic> fetchFilterCategory() async {
        return await ApiService.getApi(AppUrl.filtercategory, useAuth: false);
      }

      static Future<dynamic> fetchJewelleryDetail(String slug) async {
        return await ApiService.getApi('${AppUrl.jewelleryDetail}/$slug', useAuth: false);
      }

      static Future<dynamic> fetchRecommendedJewellery(String slug) async {
        return await ApiService.getApi('${AppUrl.recommendedJewelleryList}/$slug', useAuth: false);
      }

      // AUTHENTICATION & PROFILE
      static Future<dynamic> login(dynamic data) async {
        return await ApiService.postApi(AppUrl.login, data: data, useAuth: false);
      }

      static Future<dynamic> signup(dynamic data) async {
        return await ApiService.postApi(AppUrl.sinup, data: data, useAuth: false);
      }

      static Future<dynamic> sendOtp(dynamic data) async {
        return await ApiService.postApi(AppUrl.otp, data: data, useAuth: false);
      }

      static Future<dynamic> verifyOtp(dynamic data) async {
        return await ApiService.postApi(AppUrl.verifyotp, data: data, useAuth: false);
      }

      static Future<dynamic> fetchProfileData() async {
        return await ApiService.getApi(AppUrl.profile, useAuth: true);
      }

      static Future<dynamic> fetchProfileDetails() async {
        return await ApiService.getApi(AppUrl.profileDetail, useAuth: true);
      }

      static Future<dynamic> fetchWalletData() async {
        return await ApiService.getApi(AppUrl.wallet, useAuth: true);
      }

      // CART & WISHLIST
      static Future<dynamic> fetchCartData({String? flag, String? qty, String? cart, String? type}) async {
        final query = '?flag=${flag ?? ''}&qty=${qty ?? ''}&cart=${cart ?? ''}&type=${type ?? ''}';
        return await ApiService.getApi('${AppUrl.cart}$query', useAuth: true);
      }

      static Future<dynamic> countCartWishlist() async {
        return await ApiService.getApi(AppUrl.count, useAuth: true);
      }

      static Future<dynamic> addToCart(dynamic data) async {
        return await ApiService.postApi(AppUrl.addtocart, data: data, useAuth: true);
      }

      static Future<dynamic> fetchWishlist() async {
        return await ApiService.getApi(AppUrl.wishlist, useAuth: true);
      }

      // ADDRESS & ORDERS
      static Future<dynamic> fetchAddresses() async {
        return await ApiService.getApi(AppUrl.addressesfeach, useAuth: true);
      }

      static Future<dynamic> fetchOrderList() async {
        return await ApiService.getApi(AppUrl.order, useAuth: true);
      }

      static Future<dynamic> fetchOrderDetails(String id) async {
        return await ApiService.getApi('${AppUrl.orderdetail}$id/myorder', useAuth: true);
      }

      // FALLBACK GENERIC REQUESTS
      static Future<dynamic> getRequest(String url, {Map<String, dynamic>? queryParameters, bool useAuth = true}) async {
        return await ApiService.getApi(url, queryParameters: queryParameters, useAuth: useAuth);
      }

      static Future<dynamic> postRequest(String url, {dynamic data, bool useAuth = true}) async {
        return await ApiService.postApi(url, data: data, useAuth: useAuth);
      }
    }
""")

with open(target_api_call_path, 'w', encoding='utf-8') as f:
    f.write(api_call_content)

print("Generated lib/api/api_call.dart")
