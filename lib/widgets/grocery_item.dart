import 'package:flutter/material.dart';

class GroceryItem extends StatelessWidget {
  const GroceryItem({
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
    return Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          width: 20,
          height: 20,
          color: color,
        ),
        Text(text),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(dataCount.toString()),
        ),
      ],
    );
  }
}
