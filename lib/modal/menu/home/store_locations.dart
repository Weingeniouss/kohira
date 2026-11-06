import 'dart:convert';

StoreLocationResponse storeLocationResponseFromJson(String str) =>
    StoreLocationResponse.fromJson(json.decode(str));

class StoreLocationResponse {
  bool? success;
  String? message;
  List<StoreState>? data;

  StoreLocationResponse({
    this.success,
    this.message,
    this.data,
  });

  factory StoreLocationResponse.fromJson(Map<String, dynamic> json) {
    return StoreLocationResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((e) => StoreState.fromJson(e)).toList()
          : null,
    );
  }
}

class StoreState {
  num? stateId;
  String? stateName;
  List<StoreCity>? cities;

  StoreState({
    this.stateId,
    this.stateName,
    this.cities,
  });

  factory StoreState.fromJson(Map<String, dynamic> json) {
    return StoreState(
      stateId: json['state_id'],
      stateName: json['state_name'],
      cities: json['cities'] != null
          ? (json['cities'] as List).map((e) => StoreCity.fromJson(e)).toList()
          : null,
    );
  }
}

class StoreCity {
  num? cityId;
  String? cityName;
  List<StoreItem>? stores;

  StoreCity({
    this.cityId,
    this.cityName,
    this.stores,
  });

  factory StoreCity.fromJson(Map<String, dynamic> json) {
    return StoreCity(
      cityId: json['city_id'],
      cityName: json['city_name'],
      stores: json['stores'] != null
          ? (json['stores'] as List).map((e) => StoreItem.fromJson(e)).toList()
          : null,
    );
  }
}

class StoreItem {
  num? id;
  String? name;
  String? slug;
  String? pincode;

  StoreItem({
    this.id,
    this.name,
    this.slug,
    this.pincode,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      pincode: json['pincode'],
    );
  }
}
