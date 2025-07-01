import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocetak5/data/categories.dart';
import 'package:pocetak5/data/dummy_items.dart';
import 'package:pocetak5/models/grocery_item.dart';
import 'package:pocetak5/widgets/grocery_item.dart';
import 'package:pocetak5/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  @override
  void initState() {
    super.initState();
    loadList();
  }

  List<GroceryItem> listOfItems = [];
  var isLoading = true;
  String error = "";

  void loadList() async {
    final url = Uri.https(
      'flutter-start-ca48a-default-rtd.firebaseio.com',
      'shoping-lista.json',
    );
    final response = await http.get(url);
    print("De mi ovdje molim te ispirntaj status code: ${response.statusCode}");

    if (response.statusCode >= 400) {
      setState(() {
        isLoading = false;
        error = "Failed to fetch data. Please try again.";
      });
      return;
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries.firstWhere(
        (catItem) => catItem.value.name == item.value['category'],
      );
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category.value,
        ),
      );
    }
    setState(() {
      listOfItems = loadedItems;
      isLoading = false;
    });
  }

  void addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => NewItem()));

    if (newItem == null) {
      return;
    }

    setState(() {
      listOfItems.add(newItem);
    });
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error.isNotEmpty
              ? Center(child: Text(error))
              : listOfItems.isEmpty
              ? SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "List of Groceries is empty!",
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      "Hurry up to add a new one...",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: listOfItems.length,
                itemBuilder:
                    (item, index) => Dismissible(
                      key: ValueKey(listOfItems[index].id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        child: Row(
                          children: [
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          listOfItems.removeAt(index);
                        });
                      },
                      child: GroceryListItem(
                        color: listOfItems[index].category.color,
                        text: listOfItems[index].name,
                        dataCount: listOfItems[index].quantity,
                      ),
                    ),
              ),
    );
  }
}
