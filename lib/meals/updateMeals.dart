import 'package:flutter/material.dart';
import 'package:restaurant/models/meals_model.dart';
import 'package:restaurant/meals/mealService.dart';

class UpdateMealPage extends StatefulWidget {
  final Meal meal;

  UpdateMealPage({required this.meal});

  @override
  _UpdateMealPageState createState() => _UpdateMealPageState();
}

class _UpdateMealPageState extends State<UpdateMealPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController youtubeLinkController = TextEditingController();
  final TextEditingController ingredient1Controller = TextEditingController();
  final TextEditingController ingredient2Controller = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String? selectedImage;

  @override
  void initState() {
    super.initState();
    // Initialisez les contrôleurs avec les valeurs existantes du repas
    nameController.text = widget.meal.name;
    areaController.text = widget.meal.area;
    instructionsController.text = widget.meal.instructions;
    youtubeLinkController.text = widget.meal.youtubeLink ?? '';
    ingredient1Controller.text =
        widget.meal.ingredients['strIngredient1'] ?? '';
    ingredient2Controller.text =
        widget.meal.ingredients['strIngredient2'] ?? '';
    priceController.text = widget.meal.price ?? '';
    selectedImage = widget.meal.thumbnail;
  }

  Future<void> updateMeal() async {
    try {
      Meal updatedMeal = Meal(
        id: widget.meal.id,
        name: nameController.text,
        area: areaController.text,
        instructions: instructionsController.text,
        thumbnail: selectedImage ?? '',
        tags: tagsController.text,
        youtubeLink: youtubeLinkController.text,
        ingredients: {
          'strIngredient1': ingredient1Controller.text,
          'strIngredient2': ingredient2Controller.text,
        },
        sourceLink: null,
        imageSource: null,
        price: priceController.text,
      );

      await ApiService.updateMeal(updatedMeal);
      // Vous pouvez également ajouter une logique de navigation ici
      Navigator.pop(context);
    } catch (e) {
      print('Error updating meal: $e');
      // Gérer les erreurs ici
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Meal'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: areaController,
              decoration: InputDecoration(labelText: 'Area'),
            ),
            TextField(
              controller: instructionsController,
              decoration: InputDecoration(labelText: 'Instructions'),
            ),
            TextField(
              controller: tagsController,
              decoration: InputDecoration(labelText: 'Tags'),
            ),
            TextField(
              controller: youtubeLinkController,
              decoration: InputDecoration(labelText: 'YouTube Link'),
            ),
            TextField(
              controller: ingredient1Controller,
              decoration: InputDecoration(labelText: 'Ingredient 1'),
            ),
            TextField(
              controller: ingredient2Controller,
              decoration: InputDecoration(labelText: 'Ingredient 2'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            DropdownButton<String>(
              hint: Text('Select Image'),
              value: selectedImage,
              items: [
                'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
                'https://www.themealdb.com/images/media/meals/tkxquw1628771028.jpg',
                'https://www.themealdb.com/images/media/meals/mlchx21564916997.jpg',
                'https://www.themealdb.com/images/media/meals/n3xxd91598732796.jpg',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: Image.network(
                      value,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedImage = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: updateMeal,
              child: Text('Update Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
