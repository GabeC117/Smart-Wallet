import 'package:flutter/material.dart';
import 'package:smart_wallet/pages/add_expense.dart';

class Budget extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<Budget> {
  Map<String, double> _categoryBudgets = {};
  Map<String, List<String>> _categoryExpenses = {}; // Mock data structure for expenses

  // Define categories for budgets
  final List<String> _budgetCategories = [
    'Food',
    'Transportation',
    'Entertainment',
    'Utilities',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize budgets and mock expenses to 0 for each category
    for (String category in _budgetCategories) {
      _categoryBudgets[category] = 0.0;
      _categoryExpenses[category] = []; // Initialize empty list for expenses
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Category Budgets',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _categoryBudgets.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text('\$${entry.value.toStringAsFixed(2)}'),
                      ElevatedButton(
                        onPressed: () => _viewExpenses(entry.key),
                        child: Text('View Expenses'),
                      ),
                      ElevatedButton(
                        onPressed: () => _editCategoryBudget(entry.key, entry.value),
                        child: Text('Edit'),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpensePopup(),
        label: Text('Add Expense'),
        icon: Icon(Icons.add),
        tooltip: 'Add Expense',
      ),
    );
  }

  void _viewExpenses(String category) {
    final expenses = _categoryExpenses[category];
    if (expenses == null || expenses.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Expenses Found'),
            content: Text('No expenses recorded for $category.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Expenses for $category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: expenses
                  .map((expense) => ListTile(title: Text(expense)))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAddExpensePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: AddExpense(onUpdateBudgetPage: _fetchAndUpdateBudgets),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        );
      }
    );
  }

  void _fetchAndUpdateBudgets() {
    // Function to fetch and update budget categories
    // Here you would handle the logic to update your budgets after adding an expense
    setState(() {});
  }

  void _editCategoryBudget(String category, double currentBudget) async {
    final newBudget = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Budget for $category'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter new budget for $category',
            ),
            controller: TextEditingController(text: currentBudget.toString()),
            onChanged: (value) {
              try {
                currentBudget = double.parse(value);
              } catch (e) {
                // Handle parse error
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context). pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(currentBudget);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newBudget != null) {
      setState(() {
        _categoryBudgets[category] = newBudget;
      });
    }
  }
}
