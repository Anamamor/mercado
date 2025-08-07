
class Order {
  final int? id;
  final int consumerId;
  final int farmerId;
  final List<OrderItem> items;
  final double totalAmount;
  final String status; // pending, confirmed, delivered, cancelled
  final DateTime createdAt;
  final String? deliveryAddress;

  Order({
    this.id,
    required this.consumerId,
    required this.farmerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.deliveryAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'consumerId': consumerId,
      'farmerId': farmerId,
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'deliveryAddress': deliveryAddress,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      consumerId: map['consumerId'],
      farmerId: map['farmerId'],
      items: [], // Se cargarán por separado
      totalAmount: map['totalAmount'].toDouble(),
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
      deliveryAddress: map['deliveryAddress'],
    );
  }
}

class OrderItem {
  final int? id;
  final int orderId;
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItem({
    this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      orderId: map['orderId'],
      productId: map['productId'],
      productName: map['productName'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'].toDouble(),
      totalPrice: map['totalPrice'].toDouble(),
    );
  }
}
