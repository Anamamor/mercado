
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/order.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'agri_market.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT NOT NULL,
        userType TEXT NOT NULL,
        address TEXT,
        profileImage TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit TEXT NOT NULL,
        farmerId INTEGER NOT NULL,
        image TEXT,
        createdAt TEXT NOT NULL,
        isAvailable INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (farmerId) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        consumerId INTEGER NOT NULL,
        farmerId INTEGER NOT NULL,
        totalAmount REAL NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        deliveryAddress TEXT,
        FOREIGN KEY (consumerId) REFERENCES users (id),
        FOREIGN KEY (farmerId) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId INTEGER NOT NULL,
        productId INTEGER NOT NULL,
        productName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unitPrice REAL NOT NULL,
        totalPrice REAL NOT NULL,
        FOREIGN KEY (orderId) REFERENCES orders (id),
        FOREIGN KEY (productId) REFERENCES products (id)
      )
    ''');
  }

  // User operations
  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getAllUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<User?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Product operations
  Future<int> insertProduct(Product product) async {
    Database db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'isAvailable = ?',
      whereArgs: [1],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<List<Product>> getProductsByFarmer(int farmerId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'farmerId = ?',
      whereArgs: [farmerId],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<List<Product>> searchProducts(String query) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'name LIKE ? OR description LIKE ? OR category LIKE ? AND isAvailable = ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', 1],
    );
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<void> updateProduct(Product product) async {
    Database db = await database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(int id) async {
    Database db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // Order operations
  Future<int> insertOrder(Order order) async {
    Database db = await database;
    return await db.insert('orders', order.toMap());
  }

  Future<void> insertOrderItems(List<OrderItem> items) async {
    Database db = await database;
    Batch batch = db.batch();
    for (OrderItem item in items) {
      batch.insert('order_items', item.toMap());
    }
    await batch.commit();
  }

  Future<List<Order>> getOrdersByConsumer(int consumerId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'consumerId = ?',
      whereArgs: [consumerId],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Order.fromMap(maps[i]));
  }

  Future<List<Order>> getOrdersByFarmer(int farmerId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'farmerId = ?',
      whereArgs: [farmerId],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Order.fromMap(maps[i]));
  }
}
