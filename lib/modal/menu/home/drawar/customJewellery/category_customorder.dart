// ignore_for_file: camel_case_types

class Category_Customorder {
  final int id;
  final String name;
  final String slug;
  final List<Category_Subcategory> subcategory;
  Category_Customorder({required this.id, required this.name, required this.slug, required this.subcategory});
  factory Category_Customorder.fromJson(Map<String, dynamic> json) {
    return Category_Customorder(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      subcategory: (json['subcategory'] as List? ?? []).map((item) => Category_Subcategory.fromJson(item)).toList(),
    );
  }
}

class Category_Subcategory {
  final int id;
  final String name;
  final String slug;
  Category_Subcategory({required this.id, required this.name, required this.slug});
  factory Category_Subcategory.fromJson(Map<String, dynamic> json) {
    return Category_Subcategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}
