import 'package:flutter/material.dart';
import 'package:pocetak5/models/grocery_item.dart';
import 'package:pocetak5/widgets/grocery_item.dart';
import 'package:pocetak5/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> listOfItems = [];
  void addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => NewItem()));

    if (newItem == null) {
      return;
    } else {
      setState(() {
        listOfItems.add(newItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: () {
              addItem();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: listOfItems.length,
        itemBuilder:
            (item, index) => GroceryListItem(
              color: listOfItems[index].category.color,
              text: listOfItems[index].name,
              dataCount: listOfItems[index].quantity,
            ),
      ),
    );
  }
}
