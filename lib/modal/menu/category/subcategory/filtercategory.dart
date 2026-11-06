class Filtercategory {
  final List<Datum> data;
  final int count;
  final bool success;
  final String message;

  Filtercategory({
    required this.data,
    required this.count,
    required this.success,
    required this.message,
  });

  factory Filtercategory.fromJson(Map<String, dynamic> json) => Filtercategory(
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [],
        count: json["count"] ?? 0,
        success: json["success"] ?? false,
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "count": count,
        "success": success,
        "message": message,
      };
}

class Datum {
  final int id;
  final String name;
  final String slug;
  final String image;
  final String customOrderImage;
  final dynamic sort;
  final String iscustom;
  final String ismenu;
  final String ishome;
  final List<Datum> subcategory;
  bool isExpanded;

  Datum({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    this.customOrderImage = "",
    this.sort,
    this.iscustom = "",
    this.ismenu = "",
    this.ishome = "",
    required this.subcategory,
    this.isExpanded = false,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        slug: json["slug"] ?? "",
        image: json["image"] ?? "",
        customOrderImage: json["custom_order_image"] ?? "",
        sort: json["sort"],
        iscustom: json["iscustom"] ?? "",
        ismenu: json["ismenu"] ?? "",
        ishome: json["ishome"] ?? "",
        subcategory: json["subcategory"] != null
            ? List<Datum>.from(
                json["subcategory"].map((x) => Datum.fromJson(x)))
            : [],
        isExpanded: false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "image": image,
        "custom_order_image": customOrderImage,
        "sort": sort,
        "iscustom": iscustom,
        "ismenu": ismenu,
        "ishome": ishome,
        "subcategory": List<dynamic>.from(subcategory.map((x) => x.toJson())),
      };
}
