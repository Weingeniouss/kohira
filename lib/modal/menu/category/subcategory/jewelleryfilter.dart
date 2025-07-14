class JewelleryFilterModel {
  final Data data;
  final bool success;
  final String message;

  JewelleryFilterModel({
    required this.data,
    required this.success,
    required this.message,
  });

  factory JewelleryFilterModel.fromJson(Map<String, dynamic> json) {
    return JewelleryFilterModel(
      data: Data.fromJson(json['data'] ?? {}),
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class Data {
  final List<BraceletSize> shape;
  final List<BraceletSize> settingType;
  final List<BraceletSize> ringSize;
  final List<BraceletSize> braceletSize;
  final List<BraceletSize> metalType;
  final List<BraceletSize> metalStamp;
  final Metalweight settingPrice;
  final Metalweight metalweight;

  Data({
    required this.shape,
    required this.settingType,
    required this.ringSize,
    required this.braceletSize,
    required this.metalType,
    required this.metalStamp,
    required this.settingPrice,
    required this.metalweight,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    List<BraceletSize> parseList(String key) {
      final list = json[key];
      if (list is List) {
        return list.map((x) => BraceletSize.fromJson(x)).toList();
      }
      return [];
    }

    return Data(
      shape: parseList('Shape'),
      settingType: parseList('Setting_Type'),
      ringSize: parseList('RingSize'),
      braceletSize: parseList('BraceletSize'),
      metalType: parseList('Metal_Type'),
      metalStamp: parseList('Metal_Stamp'),
      settingPrice: Metalweight.fromJson(json['setting_price'] ?? {}),
      metalweight: Metalweight.fromJson(json['metalweight'] ?? {}),
    );
  }
}

class BraceletSize {
  final int id;
  final String name;
  final String description;
  final String slug;
  final String image;

  BraceletSize({
    required this.id,
    required this.name,
    required this.description,
    required this.slug,
    required this.image,
  });

  factory BraceletSize.fromJson(Map<String, dynamic> json) {
    return BraceletSize(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class Metalweight {
  final double min;
  final double max;

  Metalweight({
    required this.min,
    required this.max,
  });

  factory Metalweight.fromJson(Map<String, dynamic> json) {
    return Metalweight(
      min: (json['min'] ?? 0).toDouble(),
      max: (json['max'] ?? 0).toDouble(),
    );
  }
}