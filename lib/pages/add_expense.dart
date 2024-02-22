import 'package:flutter/material.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';
import 'dart:math';


class AddExpense extends StatefulWidget {
  final VoidCallback? onUpdateBudgetPage; // Callback function

  AddExpense({this.onUpdateBudgetPage});

  @override
  _AddExpense createState() => _AddExpense();
}

Future<void> setEx(double a, String c) async {
  UserDatabase userDatabase = UserDatabase();
  await userDatabase.setEx(a, c);
}

class _AddExpense extends State<AddExpense> {
  final TextEditingController _expenseController = TextEditingController();
  String _selectedCategory = 'Select a Category';
  final List<String> _categories = [
    'Select a Category',
    'Food',
    'Transportation',
    'Entertainment',
    'Utilities',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Call the callback function when pressing the back button
            widget.onUpdateBudgetPage?.call();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: _categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _expenseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter an expense',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final double expense = double.tryParse(_expenseController.text) ?? 0.0;
                setEx(expense, _selectedCategory);
              },
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
