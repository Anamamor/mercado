
class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String category;
  final int quantity;
  final String unit; // kg, unidad, etc.
  final int farmerId;
  final String? image;
  final DateTime createdAt;
  final bool isAvailable;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.farmerId,
    this.image,
    required this.createdAt,
    this.isAvailable = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'farmerId': farmerId,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
      'isAvailable': isAvailable ? 1 : 0,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'].toDouble(),
      category: map['category'],
      quantity: map['quantity'],
      unit: map['unit'],
      farmerId: map['farmerId'],
      image: map['image'],
      createdAt: DateTime.parse(map['createdAt']),
      isAvailable: map['isAvailable'] == 1,
    );
  }
}
