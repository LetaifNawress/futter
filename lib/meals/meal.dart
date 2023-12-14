import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/Orders/orders.dart';
import 'package:restaurant/auth/sign_in.dart';
import 'package:restaurant/category/category.dart';
import 'package:restaurant/meals/mealService.dart';
import 'package:restaurant/models/meals_model.dart';

class MealsScreen extends StatefulWidget {
  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late List<Meal> meals;
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

  List<String> mealImages = [
    'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
    'https://www.themealdb.com/images/media/meals/tkxquw1628771028.jpg',
    'https://www.themealdb.com/images/media/meals/mlchx21564916997.jpg',
    'https://www.themealdb.com/images/media/meals/n3xxd91598732796.jpg',
  ];

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

  Widget buildMealCard(Meal meal) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: meal.thumbnail.isNotEmpty
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
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  meal.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Area: ${meal.area}',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Price: \$${meal.price ?? 'N/A'}',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showUpdateMealDialog(meal);
                      },
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteMealDialog(meal.id!);
                      },
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMealDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Meal'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: areaController,
                      decoration: InputDecoration(labelText: 'Area'),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: instructionsController,
                      decoration: InputDecoration(labelText: 'Instructions'),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: tagsController,
                      decoration: InputDecoration(labelText: 'Tags'),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: youtubeLinkController,
                      decoration: InputDecoration(labelText: 'YouTube Link'),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: ingredient1Controller,
                      decoration: InputDecoration(labelText: 'Ingredient 1'),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: ingredient2Controller,
                      decoration: InputDecoration(labelText: 'Ingredient 2'),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(labelText: 'Price'),
                    ),
                    SizedBox(height: 8.0),
                    DropdownButtonFormField<String>(
                      value: selectedImage,
                      items: [
                        'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
                        'https://www.themealdb.com/images/media/meals/tkxquw1628771028.jpg',
                        'https://www.themealdb.com/images/media/meals/mlchx21564916997.jpg',
                        'https://www.themealdb.com/images/media/meals/n3xxd91598732796.jpg',
                      ].map((String imageUrl) {
                        return DropdownMenuItem<String>(
                          value: imageUrl,
                          child: Image.network(
                            imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedImage = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Image',
                      ),
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
                    _addMeal();
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addMeal() async {
    if (nameController.text.isNotEmpty &&
        areaController.text.isNotEmpty &&
        instructionsController.text.isNotEmpty &&
        tagsController.text.isNotEmpty &&
        youtubeLinkController.text.isNotEmpty &&
        ingredient1Controller.text.isNotEmpty &&
        ingredient2Controller.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        selectedImage != null) {
      try {
        Meal newMeal = Meal(
          id: null,
          name: nameController.text,
          area: areaController.text,
          instructions: instructionsController.text,
          thumbnail: selectedImage!,
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
        fetchMeals();
        Navigator.pop(context);
        showSuccessSnackBar('Meal added successfully!');
      } catch (e) {
        print('Error adding meal: $e');
        showErrorSnackBar('Error adding meal');
      }
    } else {
      showErrorSnackBar('Please fill in all fields.');
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showUpdateMealDialog(Meal meal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Meal'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: nameController..text = meal.name,
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(labelText: 'Area'),
                    controller: areaController..text = meal.area,
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(labelText: 'Instructions'),
                    controller: instructionsController
                      ..text = meal.instructions,
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(labelText: 'Tags'),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(labelText: 'YouTube Link'),
                    controller: youtubeLinkController..text = meal.youtubeLink,
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(labelText: 'Ingredient 1'),
                    controller: ingredient1Controller
                      ..text = meal.ingredients['strIngredient1'] ?? '',
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(labelText: 'Ingredient 2'),
                    controller: ingredient2Controller
                      ..text = meal.ingredients['strIngredient2'] ?? '',
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(labelText: 'Price'),
                    controller: priceController..text = meal.price ?? '',
                  ),
                  SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    value: selectedImage ?? meal.thumbnail,
                    items: mealImages.map((url) {
                      return DropdownMenuItem<String>(
                        value: url,
                        child: Text(url),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedImage = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Image',
                    ),
                  ),
                ],
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
                    _updateMeal(meal);
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateMeal(Meal meal) async {
    if (nameController.text.isNotEmpty &&
        areaController.text.isNotEmpty &&
        instructionsController.text.isNotEmpty &&
        selectedImage != null) {
      try {
        Meal updatedMeal = Meal(
          id: meal.id,
          name: nameController.text,
          area: areaController.text,
          instructions: instructionsController.text,
          thumbnail: selectedImage!,
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
        fetchMeals();
        Navigator.pop(context);
      } catch (e) {
        print('Error updating meal: $e');
      }
    }
  }

  void _showDeleteMealDialog(String mealId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Meal'),
          content: Text('Are you sure you want to delete this meal?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ApiService.deleteMeal(mealId);
                  fetchMeals();
                  Navigator.pop(context);
                } catch (e) {
                  print('Error deleting meal: $e');
                }
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Meals'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddMealDialog();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 196, 214, 230),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.fastfood),
              title: Text('Category'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Orders'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.local_dining),
              title: Text('Meals'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
            ),
          ],
        ),
      ),
      body: meals != null && meals.isNotEmpty
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLargeScreen ? 2 : 2,
                childAspectRatio: isLargeScreen ? 0.7 : 0.8,
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print('Meal tapped: ${meals[index].name}');
                  },
                  child: buildMealCard(meals[index]),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
