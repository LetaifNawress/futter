import 'package:flutter/material.dart';
import 'package:restaurant/Orders/ordersService.dart';
import 'package:restaurant/auth/sign_in.dart';
import 'package:restaurant/category/category.dart';
import 'package:restaurant/meals/meal.dart';
import 'package:restaurant/models/Orders_model.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<List<Order>> data = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<List<Order>> orders =
          await ApiService.fetchOrders(); // Utilisez ApiService directement
      setState(() {
        data = orders;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
              );
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
                color: Color.fromARGB(255, 171, 189, 204),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.local_dining),
              title: Text('Meals'),
              onTap: () {
                Navigator.pushReplacement(
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
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int orderIndex) {
          List<Order> orderItems = data[orderIndex];

          return Card(
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: [
                for (Order orderItem in orderItems)
                  ListTile(
                    leading: Image.network(
                      orderItem.photo,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text('Name: ${orderItem.name}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${orderItem.quantity}'),
                        Text('Price: ${orderItem.price}'),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
