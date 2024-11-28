import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/order_plan_model.dart';

class ViewOrderScreen extends StatefulWidget {
  @override
  _ViewOrderScreenState createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen> {
  final _dateController = TextEditingController();
  List<OrderPlan> _orderPlans = [];

  Future<void> _loadOrderPlans(String date) async {
    final orderPlans = await DatabaseHelper().getOrderPlan(date);
    setState(() {
      _orderPlans = orderPlans.map((plan) => OrderPlan.fromMap(plan)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Order Plans'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Enter Date (YYYY-MM-DD)',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _loadOrderPlans(_dateController.text),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _orderPlans.length,
                itemBuilder: (context, index) {
                  final plan = _orderPlans[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Date: ${plan.date}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Target Cost: \$${plan.targetCost.toStringAsFixed(2)}'),
                          Text('Items: ${plan.items}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
