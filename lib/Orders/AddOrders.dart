import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurant/category/catService.dart';
import 'package:restaurant/models/category_model.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  _AddOrderScreenState createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  List<Category> categories = [];
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      List<Category> fetchedCategories = await ApiService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Order'),
      ),
      body: Column(
        children: [
          Text('Choose a category:'),
          DropdownButton<Category>(
            value: selectedCategory,
            onChanged: (Category? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
            items:
                categories.map<DropdownMenuItem<Category>>((Category category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
          ),
          // ... autres champs pour la commande
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Envoyez la commande avec la catégorie sélectionnée
          // ...
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
