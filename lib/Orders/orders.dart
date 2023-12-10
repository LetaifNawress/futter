import 'package:flutter/material.dart';
import 'package:restaurant/Orders/ordersService.dart';
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
