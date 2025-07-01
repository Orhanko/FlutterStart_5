import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocetak5/data/categories.dart';
import 'package:pocetak5/models/category.dart';
import 'package:pocetak5/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return NewItemState();
  }
}

class NewItemState extends State<NewItem> {
  final formKey = GlobalKey<FormState>();
  var enteredName = "";
  var enteredQuality = 1;
  var enteredCategory = categories[Categories.vegetables]!;
  var isSending = false;
  void saveItem() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        isSending = true;
      });
      final url = Uri.https(
        'flutter-start-ca48a-default-rtdb.firebaseio.com',
        'shoping-lista.json',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': enteredName,
          'quantity': enteredQuality,
          'category': enteredCategory.name,
        }),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (!mounted) return;
      Navigator.of(context).pop(
        GroceryItem(
          id: responseData['name'],
          name: enteredName,
          quantity: enteredQuality,
          category: enteredCategory,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a new item")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(label: Text("Name")),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return "Error message";
                  }
                  return null;
                },
                onSaved: (value) {
                  enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(label: Text("Quantity")),
                      initialValue: enteredQuality.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value)! <= 0 ||
                            int.tryParse(value) == null) {
                          return 'Must be a valid, positive number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        enteredQuality = int.parse(value!);
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: enteredCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                SizedBox(width: 6),
                                Text(category.value.name),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          enteredCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Divider(height: 50, thickness: 0),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed:
                        isSending
                            ? null
                            : () {
                              formKey.currentState!.reset();
                              enteredCategory =
                                  categories[Categories.vegetables]!;
                            },
                    child: Text("Reset"),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: isSending ? null : saveItem,
                    child:
                        isSending
                            ? SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                            : Text("Submit"),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
