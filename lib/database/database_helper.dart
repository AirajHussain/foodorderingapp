import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'food_ordering.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE food_items (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, cost REAL)');
    await db.execute(
        'CREATE TABLE order_plans (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, items TEXT, target_cost REAL)');
  }

  // CRUD operations for food items

  Future<int> addFoodItem(String name, double cost) async {
    final db = await database;
    return await db.insert('food_items', {'name': name, 'cost': cost});
  }

  Future<List<Map<String, dynamic>>> getFoodItems() async {
    final db = await database;
    return await db.query('food_items');
  }

  Future<int> updateFoodItem(int id, String name, double cost) async {
    final db = await database;
    return await db.update(
      'food_items',
      {'name': name, 'cost': cost},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteFoodItem(int id) async {
    final db = await database;
    return await db.delete('food_items', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD operations for order plans

  Future<int> addOrderPlan(String date, String items, double targetCost) async {
    final db = await database;
    return await db.insert('order_plans', {
      'date': date,
      'items': items,
      'target_cost': targetCost,
    });
  }

  Future<List<Map<String, dynamic>>> getOrderPlan(String date) async {
    final db = await database;
    return await db.query('order_plans', where: 'date = ?', whereArgs: [date]);
  }

  Future<int> updateOrderPlan(int id, String date, String items, double targetCost) async {
    final db = await database;
    return await db.update(
      'order_plans',
      {
        'date': date,
        'items': items,
        'target_cost': targetCost,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteOrderPlan(int id) async {
    final db = await database;
    return await db.delete('order_plans', where: 'id = ?', whereArgs: [id]);
  }
}
