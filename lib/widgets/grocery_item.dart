import 'package:flutter/material.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({
    super.key,
    required this.color,
    required this.text,
    required this.dataCount,
  });
  final Color color;
  final String text;
  final int dataCount;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      leading: Container(width: 24, height: 24, color: color),
      trailing: Text(dataCount.toString(), style: TextStyle(fontSize: 16)),
    );
  }
}
