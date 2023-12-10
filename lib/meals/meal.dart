import 'package:flutter/material.dart';
import 'package:restaurant/meals/mealService.dart';
import 'package:restaurant/models/meals_model.dart';

class MealsScreen extends StatefulWidget {
  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<Meal> meals = [];
  final ApiService mealService = ApiService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController youtubeLinkController = TextEditingController();
  final TextEditingController ingredient1Controller = TextEditingController();
  final TextEditingController ingredient2Controller = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String? selectedImage;

  bool isLargeScreen = false;

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    try {
      List<Meal> fetchedMeals = await ApiService.fetchMeals();
      setState(() {
        meals = fetchedMeals;
      });
    } catch (e) {
      print('Error fetching meals: $e');
    }
  }

  Future<void> addMeal() async {
    try {
      Meal newMeal = Meal(
        id: null,
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

      await ApiService.addMeal(newMeal);
      clearControllers();
      fetchMeals();
      Navigator.pop(context); // Fermer la fenêtre de dialogue après l'ajout
      showSuccessSnackBar('Meal added successfully!');
    } catch (e) {
      print('Error adding meal: $e');
      showErrorSnackBar('Error adding meal');
    }
  }

  Future<void> updateMeal(Meal meal) async {
    try {
      await ApiService.updateMeal(meal);
      fetchMeals();
      Navigator.pop(
          context); // Fermer la fenêtre de dialogue après la mise à jour
      showSuccessSnackBar('Meal updated successfully!');
    } catch (e) {
      print('Error updating meal: $e');
      showErrorSnackBar('Error updating meal');
    }
  }

  Future<void> deleteMealConfirmation(String mealId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer ce repas ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                deleteMeal(mealId);
                Navigator.of(context)
                    .pop(); // Fermer la boîte de dialogue après la suppression
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteMeal(String mealId) async {
    try {
      await ApiService.deleteMeal(mealId);
      fetchMeals();
      showSuccessSnackBar('Meal deleted successfully!');
    } catch (e) {
      print('Error deleting meal: $e');
      showErrorSnackBar('Error deleting meal');
    }
  }

  void clearControllers() {
    nameController.clear();
    areaController.clear();
    instructionsController.clear();
    tagsController.clear();
    youtubeLinkController.clear();
    ingredient1Controller.clear();
    ingredient2Controller.clear();
    priceController.clear();
    selectedImage = null;
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Meals'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isLargeScreen ? 2 : 2,
          childAspectRatio: isLargeScreen ? 0.7 : 0.8,
        ),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          Meal meal = meals[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                meal.thumbnail.isNotEmpty
                    ? Image.network(
                        meal.thumbnail,
                        width: double.infinity,
                        height: isLargeScreen ? 420 : 190,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: isLargeScreen ? 80 : 60,
                        color: Colors.grey[300],
                        child: Icon(Icons.image),
                      ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.0),
                      Text('Area: ${meal.area}'),
                      Text('Price: \$${meal.price ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                          'Ingredients: ${meal.ingredients.values.join(', ')}'),
                      if (isLargeScreen) ...[
                        SizedBox(height: 4.0),
                        Text('YouTube Link: ${meal.youtubeLink}'),
                        SizedBox(height: 4.0),
                        Text('Description: ${meal.instructions}'),
                      ],
                    ],
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => updateMeal(meal),
                      icon: Icon(Icons.edit, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () => deleteMealConfirmation(meal.id!),
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: isLargeScreen
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add Meal'),
                      content: SingleChildScrollView(
                        child: Column(
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
                              decoration:
                                  InputDecoration(labelText: 'Instructions'),
                            ),
                            TextField(
                              controller: tagsController,
                              decoration: InputDecoration(labelText: 'Tags'),
                            ),
                            TextField(
                              controller: youtubeLinkController,
                              decoration:
                                  InputDecoration(labelText: 'YouTube Link'),
                            ),
                            TextField(
                              controller: ingredient1Controller,
                              decoration:
                                  InputDecoration(labelText: 'Ingredient 1'),
                            ),
                            TextField(
                              controller: ingredient2Controller,
                              decoration:
                                  InputDecoration(labelText: 'Ingredient 2'),
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
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            addMeal();
                          },
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
