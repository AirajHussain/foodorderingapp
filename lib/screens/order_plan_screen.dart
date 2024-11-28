import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/food_item_model.dart';

class OrderPlanScreen extends StatefulWidget {
  @override
  _OrderPlanScreenState createState() => _OrderPlanScreenState();
}

class _OrderPlanScreenState extends State<OrderPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _targetCostController = TextEditingController();
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<FoodItem> _foodItems = [];
  List<FoodItem> _selectedFoodItems = [];

  Future<void> _loadFoodItems() async {
    final foodItems = await DatabaseHelper().getFoodItems();
    setState(() {
      _foodItems = foodItems.map((item) => FoodItem.fromMap(item)).toList();
    });
  }

  Future<void> _saveOrderPlan() async {
    if (_selectedFoodItems.isNotEmpty && _formKey.currentState!.validate()) {
      final items = _selectedFoodItems.map((e) => e.toMap()).toList().toString();
      await DatabaseHelper().addOrderPlan(
        _selectedDate,
        items,
        double.parse(_targetCostController.text),
      );
      Navigator.pop(context);
    }
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
        title: Text('Create Order Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Date:'),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = DateFormat('yyyy-MM-dd').format(date);
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_selectedDate),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _targetCostController,
                decoration: InputDecoration(labelText: 'Target Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the target cost';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Select Food Items:'),
              Expanded(
                child: ListView.builder(
                  itemCount: _foodItems.length,
                  itemBuilder: (context, index) {
                    final foodItem = _foodItems[index];
                    return CheckboxListTile(
                      title: Text(foodItem.name),
                      subtitle: Text('\$${foodItem.cost.toStringAsFixed(2)}'),
                      value: _selectedFoodItems.contains(foodItem),
                      onChanged: (isSelected) {
                        setState(() {
                          if (isSelected == true) {
                            _selectedFoodItems.add(foodItem);
                          } else {
                            _selectedFoodItems.remove(foodItem);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _saveOrderPlan,
                child: Text('Save Order Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
