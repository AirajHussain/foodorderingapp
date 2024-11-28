import 'package:flutter/material.dart';
import 'add_food_screen.dart';
import 'update_food_screen.dart';
import 'view_order_screen.dart';
import 'order_plan_screen.dart';
import '../database/database_helper.dart';
import '../models/food_item_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FoodItem> _foodItems = [];

  Future<void> _loadFoodItems() async {
    final foodItems = await DatabaseHelper().getFoodItems();
    setState(() {
      _foodItems = foodItems.map((item) => FoodItem.fromMap(item)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Ordering App'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadFoodItems,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _foodItems.length,
        itemBuilder: (context, index) {
          final foodItem = _foodItems[index];
          return ListTile(
            title: Text(foodItem.name),
            subtitle: Text('\$${foodItem.cost.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateFoodScreen(foodItem: foodItem),
                  ),
                ).then((_) => _loadFoodItems());
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFoodScreen()),
          ).then((_) => _loadFoodItems());
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('View Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewOrderScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add_task),
              title: Text('Create Order Plan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderPlanScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}