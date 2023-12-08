import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/models/Orders_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/orders';

  static Future<List<List<Order>>> fetchOrders() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data is List) {
        return data.map<List<Order>>((orderList) {
          if (orderList is List) {
            return orderList
                .map<Order>((json) => Order.fromJson(json))
                .toList();
          } else {
            throw Exception('Invalid order list format');
          }
        }).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load orders');
    }
  }

  static Future<void> addOrder(List<Order> orderItems) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode(orderItems.map((order) => order.toJson()).toList()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add order');
    }
  }

  // Update an existing order by order ID
  static Future<void> updateOrder(
      String orderId, List<Order> orderItems) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$orderId'),
      body: jsonEncode(orderItems.map((order) => order.toJson()).toList()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update order');
    }
  }

  // Delete an existing order by order ID
  static Future<void> deleteOrder(String orderId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$orderId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete order');
    }
  }
}
