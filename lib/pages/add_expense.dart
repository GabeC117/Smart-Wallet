import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  final Function(double, String) onExpenseAdded;

  AddExpense({required this.onExpenseAdded});

  @override
  _AddExpense createState() => _AddExpense();
}

class _AddExpense extends State<AddExpense> {
  final TextEditingController _expenseController = TextEditingController();
  String _selectedCategory = 'Select a Category';
  List<String> _categories = [
    'Select a Category',
    'Food',
    'Transportation',
    'Entertainment',
    'Utilities',
    'Other',
  ];

  void _addExpense() {
    if (_selectedCategory == 'Select a Category') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category and enter a valid expense.')),
      );
      return;
    }
    final double expense = double.tryParse(_expenseController.text) ?? 0.0;
    widget.onExpenseAdded(expense, _selectedCategory); 

    
    setState(() {
      _expenseController.clear();
      _selectedCategory = 'Select a Category'; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
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
          ],
        ),
      ),
    );
  }
}
