import 'package:flutter/material.dart';
import 'package:restaurant/auth/sign_in.dart';
import 'package:restaurant/category/catService.dart';
import 'package:restaurant/meals/meal.dart';
import 'package:restaurant/models/category_model.dart';
import 'package:restaurant/orders/orders.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<Category> categories = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late String selectedImageUrl;

  List<String> categoryImages = [
    'https://www.themealdb.com/images/category/beef.png',
    'https://www.themealdb.com/images/category/chicken.png',
    'https://www.themealdb.com/images/category/dessert.png',
  ];

  @override
  void initState() {
    super.initState();
    if (categoryImages.isNotEmpty) {
      selectedImageUrl = categoryImages.first;
    } else {
      print('Category images list is empty.');
    }
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fetchedCategories = await ApiService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Widget buildCategoryCard(Category category) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(category.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  category.description,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.update),
                      onPressed: () {
                        _showUpdateCategoryDialog(category);
                      },
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteCategoryDialog(category.id);
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

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: nameController,
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(labelText: 'Description'),
                    controller: descriptionController,
                  ),
                  SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    value: selectedImageUrl,
                    items: categoryImages.map((url) {
                      return DropdownMenuItem<String>(
                        value: url,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(url),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedImageUrl = value!;
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
                    _addCategory();
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

  void _addCategory() async {
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        selectedImageUrl.isNotEmpty) {
      try {
        await ApiService.addCategory(
          nameController.text,
          descriptionController.text,
          selectedImageUrl,
        );
        fetchData();
        Navigator.pop(context);
      } catch (e) {
        print('Error adding category: $e');
      }
    }
  }

  void _showUpdateCategoryDialog(Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: nameController..text = category.name,
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(labelText: 'Description'),
                    controller: descriptionController
                      ..text = category.description,
                  ),
                  SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    value: selectedImageUrl,
                    items: categoryImages.map((url) {
                      return DropdownMenuItem<String>(
                        value: url,
                        child: Text(url),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedImageUrl = value!;
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
                    _updateCategory(category.id);
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

  void _updateCategory(String categoryId) async {
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        selectedImageUrl.isNotEmpty) {
      try {
        await ApiService.updateCategory(
          categoryId,
          nameController.text,
          descriptionController.text,
          selectedImageUrl,
        );
        fetchData();
        Navigator.pop(context);
      } catch (e) {
        print('Error updating category: $e');
      }
    }
  }

  void _showDeleteCategoryDialog(String categoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: Text('Are you sure you want to delete this category?'),
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
                  await ApiService.deleteCategory(categoryId);
                  fetchData();
                  Navigator.pop(context);
                } catch (e) {
                  print('Error deleting category: $e');
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddCategoryDialog();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 196, 214, 230),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.fastfood),
              title: Text('Category'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.local_dining),
              title: Text('Meals'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealsScreen()),
                );
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
      body: categories.isNotEmpty
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print('Category tapped: ${categories[index].name}');
                  },
                  child: buildCategoryCard(categories[index]),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
