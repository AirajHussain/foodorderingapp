import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/food_item_model.dart';

class UpdateFoodScreen extends StatefulWidget {
  final FoodItem foodItem;

  UpdateFoodScreen({required this.foodItem});

  @override
  _UpdateFoodScreenState createState() => _UpdateFoodScreenState();
}

class _UpdateFoodScreenState extends State<UpdateFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.foodItem.name;
    _costController.text = widget.foodItem.cost.toString();
  }

  Future<void> _updateFoodItem() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper().updateFoodItem(
        widget.foodItem.id!,
        _nameController.text,
        double.parse(_costController.text),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Food Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Food Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a food name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _costController,
                decoration: InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cost';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateFoodItem,
                child: Text('Update Food Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}