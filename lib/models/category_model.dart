class Category {
  late String id;
  late int idCategory; // Maintenant, utilisez le type int
  late String name;
  late String imageUrl;
  late String description;

  Category({
    required this.id,
    required this.idCategory,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? "",
      idCategory:
          json['idCategory'] != null ? int.parse(json['idCategory']) : 0,
      name: json['strCategory'] ?? "",
      imageUrl: json['strCategoryThumb'] ?? "",
      description: json['strCategoryDescription'] ?? "",
    );
  }
}
