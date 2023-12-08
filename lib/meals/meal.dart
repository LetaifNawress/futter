import 'package:flutter/material.dart';
import 'package:restaurant/meals/mealService.dart';
import 'package:restaurant/models/meals_model.dart';

class MealsScreen extends StatefulWidget {
  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late List<Recipe> meals;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fetchedMeals = await MealService.fetchMeals();
      setState(() {
        meals = fetchedMeals;
      });
    } catch (e) {
      print('Error fetching meals: $e');
      // Handle errors here, for example, display a SnackBar to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Repas'),
      ),
      body: meals != null
          ? ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                Recipe meal = meals[index];
                return ListTile(
                  title: Text(meal.strMeal),
                  // Add other meal information here if necessary
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
