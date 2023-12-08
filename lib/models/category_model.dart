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

  // Ajoutez une factory method pour créer une instance de Category à partir du Map
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? "", // Si 'id' est null, utilisez une chaîne vide
      idCategory: json['idCategory'] != null
          ? int.parse(json['idCategory'])
          : 0, // Si 'idCategory' est null, utilisez 0 comme valeur par défaut
      name: json['strCategory'] ??
          "", // Si 'strCategory' est null, utilisez une chaîne vide
      imageUrl: json['strCategoryThumb'] ??
          "", // Si 'strCategoryThumb' est null, utilisez une chaîne vide
      description: json['strCategoryDescription'] ??
          "", // Si 'strCategoryDescription' est null, utilisez une chaîne vide
    );
  }
}
