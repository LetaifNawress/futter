import 'dart:io';

class Meal {
  final String? id;
  final String name;
  final String area;
  final String instructions;
  final String thumbnail;
  final String? tags;
  final String youtubeLink;
  final Map<String, String> ingredients;
  final String? sourceLink;
  final String? imageSource;
  final String? price;

  Meal({
    required this.id,
    required this.name,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    this.tags,
    required this.youtubeLink,
    required this.ingredients,
    this.sourceLink,
    this.imageSource,
    this.price,
    File? selectedImage,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['strMeal'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      tags: json['strTags'],
      youtubeLink: json['strYoutube'] ?? '',
      ingredients: {
        'strIngredient1': json['strIngredient1'] ?? '',
        'strIngredient2': json['strIngredient2'] ?? '',
      },
      sourceLink: json['strSource'],
      imageSource: json['strImageSource'],
      price: json['price']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': thumbnail,
      'strTags': tags,
      'strYoutube': youtubeLink,
      'strIngredient1': ingredients['strIngredient1'],
      'strIngredient2': ingredients['strIngredient2'],
      'strSource': sourceLink,
      'strImageSource': imageSource,
      'price': price,
    };
  }
}
