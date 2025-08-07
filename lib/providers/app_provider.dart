
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../services/database_helper.dart';

class AppProvider with ChangeNotifier {
  User? _currentUser;
  List<Product> _products = [];
  List<Product> _myProducts = [];
  List<Order> _orders = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  User? get currentUser => _currentUser;
  List<Product> get products => _products;
  List<Product> get myProducts => _myProducts;
  List<Order> get orders => _orders;
  bool get isFarmer => _currentUser?.userType == 'farmer';
  bool get isConsumer => _currentUser?.userType == 'consumer';

  // Auth methods
  Future<bool> login(String email, String password) async {
    try {
      User? user = await _dbHelper.getUserByEmail(email);
      if (user != null) {
        _currentUser = user;
        await loadData();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(User user) async {
    try {
      int userId = await _dbHelper.insertUser(user);
      _currentUser = User(
        id: userId,
        name: user.name,
        email: user.email,
        phone: user.phone,
        userType: user.userType,
        address: user.address,
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _products = [];
    _myProducts = [];
    _orders = [];
    notifyListeners();
  }

  // Data loading
  Future<void> loadData() async {
    if (_currentUser != null) {
      await loadProducts();
      await loadOrders();
      if (isFarmer) {
        await loadMyProducts();
      }
    }
  }

  Future<void> loadProducts() async {
    _products = await _dbHelper.getAllProducts();
    notifyListeners();
  }

  Future<void> loadMyProducts() async {
    if (_currentUser != null && isFarmer) {
      _myProducts = await _dbHelper.getProductsByFarmer(_currentUser!.id!);
      notifyListeners();
    }
  }

  Future<void> loadOrders() async {
    if (_currentUser != null) {
      if (isFarmer) {
        _orders = await _dbHelper.getOrdersByFarmer(_currentUser!.id!);
      } else {
        _orders = await _dbHelper.getOrdersByConsumer(_currentUser!.id!);
      }
      notifyListeners();
    }
  }

  // Product methods
  Future<bool> addProduct(Product product) async {
    try {
      int productId = await _dbHelper.insertProduct(product);
      await loadMyProducts();
      await loadProducts();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateProduct(Product product) async {
    await _dbHelper.updateProduct(product);
    await loadMyProducts();
    await loadProducts();
  }

  Future<void> deleteProduct(int productId) async {
    await _dbHelper.deleteProduct(productId);
    await loadMyProducts();
    await loadProducts();
  }

  Future<List<Product>> searchProducts(String query) async {
    return await _dbHelper.searchProducts(query);
  }

  // Order methods
  Future<bool> createOrder(List<OrderItem> items, int farmerId, String? deliveryAddress) async {
    if (_currentUser == null) return false;
    
    try {
      double totalAmount = items.fold(0, (sum, item) => sum + item.totalPrice);
      
      Order order = Order(
        consumerId: _currentUser!.id!,
        farmerId: farmerId,
        items: items,
        totalAmount: totalAmount,
        status: 'pending',
        createdAt: DateTime.now(),
        deliveryAddress: deliveryAddress,
      );

      int orderId = await _dbHelper.insertOrder(order);
      
      List<OrderItem> orderItems = items.map((item) => OrderItem(
        orderId: orderId,
        productId: item.productId,
        productName: item.productName,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        totalPrice: item.totalPrice,
      )).toList();

      await _dbHelper.insertOrderItems(orderItems);
      await loadOrders();
      return true;
    } catch (e) {
      return false;
    }
  }
}
