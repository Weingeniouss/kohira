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
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    count: json["count"] ?? 0,
    success: json["success"] ?? false,
    message: json["message"] ?? "",
  );
}

class Datum {
  final int id;
  final String name;
  final String slug;
  final String image;
  final int sort;
  final List<Datum> subcategory;

  Datum({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.sort,
    required this.subcategory,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    slug: json["slug"] ?? "",
    image: json["image"] ?? "",
    sort: json["sort"] ?? 0,
    subcategory: json["subcategory"] != null
        ? List<Datum>.from(json["subcategory"].map((x) => Datum.fromJson(x)))
        : [],
  );
}