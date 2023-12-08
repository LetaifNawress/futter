class Order {
  final int id;
  final String name;
  final String photo;
  final int quantity;
  final dynamic price; // Utilisez 'num' s'il peut être à la fois int et double

  Order({
    required this.id,
    required this.name,
    required this.photo,
    required this.quantity,
    required this.price,
  });

  // Ajoutez la méthode toJson pour sérialiser l'objet en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'quantity': quantity,
      'price': price,
    };
  }

  factory Order.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return Order(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        photo: json['photo'],
        quantity: json['quantity'],
        price: json['price'],
      );
    } else {
      throw Exception('Invalid data format received');
    }
  }
}
