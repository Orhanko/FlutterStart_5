import 'package:flutter/material.dart';
import 'package:pocetak5/data/dummy_items.dart';
import 'package:pocetak5/widgets/grocery_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 42, 51, 59),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Your Groceries")),
        body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder:
              (item, index) => GroceryItem(
                color: groceryItems[index].category.color,
                text: groceryItems[index].name,
                dataCount: groceryItems[index].quantity,
              ),
        ),
      ),
    );
  }
}
