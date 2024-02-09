import 'package:flutter/material.dart';
import 'package:smart_wallet/pages/home.dart';


class Budget extends StatefulWidget {
  @override
  _BudgetPage createState() => _BudgetPage();
}

class _BudgetPage extends State<Budget> {
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();
  double _budget = 0.0;
  double _expenses = 0.0;
  String _selectedCategory = 'Select a Category';
  List<String> _categories = [
    'Select a Category',
    'Food',
    'Transportation',
    'Entertainment',
    'Utilities',
    'Other',
  ];
  String _lastAddedCategory = ''; 

  void _setBudget() {
    final double budget = double.tryParse(_budgetController.text) ?? 0.0;
    setState(() {
      _budget = budget;
    });
  }

  void _addExpense() {
    if (_selectedCategory == 'Select a Category') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category and enter a valid expense.')),
      );
      return;
    }
    final double expense = double.tryParse(_expenseController.text) ?? 0.0;
    setState(() {
      _expenses += expense;
      _expenseController.clear();
      _lastAddedCategory = _selectedCategory; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter your budget',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _setBudget,
              child: Text('Set Budget'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: DropdownButton<String>(
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
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _expenseController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter an expense',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _addExpense,
              child: Text('Add Expense'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Total Expenses: \$$_expenses'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Remaining Budget: \$${_budget - _expenses}'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Last Added Category: $_lastAddedCategory'),
            ),
          ],
        ),
      ),
    );
  }
}
