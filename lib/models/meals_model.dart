class Recipe {
  dynamic idMeal;
  String strMeal;
  String? strDrinkAlternate;
  dynamic idCategory;
  String strArea;
  String strInstructions;
  String strMealThumb;
  String strTags;
  String strYoutube;
  String strIngredient1;
  String strIngredient2;
  String strIngredient3;
  String strIngredient4;
  String strIngredient5;

  Recipe({
    required this.idMeal,
    required this.strMeal,
    this.strDrinkAlternate,
    required this.idCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    required this.strTags,
    required this.strYoutube,
    required this.strIngredient1,
    required this.strIngredient2,
    required this.strIngredient3,
    required this.strIngredient4,
    required this.strIngredient5,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      idMeal: int.parse(json['idMeal']),
      strMeal: json['strMeal'].toString(),
      strDrinkAlternate: json['strDrinkAlternate']?.toString(),
      idCategory: json['idCategory'] != null
          ? int.tryParse(json['idCategory']) ?? 0
          : 0,
      strArea: json['strArea'].toString(),
      strInstructions: json['strInstructions'].toString(),
      strMealThumb: json['strMealThumb'].toString(),
      strTags: json['strTags']?.toString() ?? "",
      strYoutube: json['strYoutube'].toString(),
      strIngredient1: json['strIngredient1'].toString(),
      strIngredient2: json['strIngredient2'].toString(),
      strIngredient3: json['strIngredient3'].toString(),
      strIngredient4: json['strIngredient4'].toString(),
      strIngredient5: json['strIngredient5'].toString(),
    );
  }
}
