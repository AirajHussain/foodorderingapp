// order_plan_model.dart
class OrderPlan {
  final int? id;
  final String date;
  final String items; // JSON string representation of selected food items
  final double targetCost;

  OrderPlan({this.id, required this.date, required this.items, required this.targetCost});

  // Convert an OrderPlan to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'items': items,
      'target_cost': targetCost,
    };
  }

  // Create an OrderPlan from a Map retrieved from the database
  factory OrderPlan.fromMap(Map<String, dynamic> map) {
    return OrderPlan(
      id: map['id'],
      date: map['date'],
      items: map['items'],
      targetCost: map['target_cost'],
    );
  }
}
