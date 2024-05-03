import 'package:flutter/material.dart';
import 'package:smart_wallet/pages/add_expense.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';

class Budget extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<Budget> {
  Map<String, double> _categoryBudgets = {};
  List<Map<String, dynamic>> _expenses = [];

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
    _fetchAndUpdateBudgets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker'),
      ),
      body: ListView.builder(
        itemCount: _budgetCategories.length,
        itemBuilder: (context, index) {
          String category = _budgetCategories[index];
          double budget = _categoryBudgets[category] ?? 0.0;  // Use null-aware access
          return ListTile(
            title: Text(category),
            subtitle: Text('\$${budget.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () => _viewExpenses(category),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editCategoryBudget(category, budget),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddExpensePopup,
        label: Text('Add Expense'),
        icon: Icon(Icons.add),
      ),
    );
  }

  void _fetchAndUpdateBudgets() async {
    try {
      for (String category in _budgetCategories) {
        double? categoryBudget = await UserDatabase().getCategoryBudget(category);
        setState(() {
          _categoryBudgets[category] = categoryBudget ?? 0.0; // Default to 0.0 if null
        });
      }
    } catch (e) {
      print('Error fetching budgets: $e');
    }
  }

  void _viewExpenses(String category) async {
    _expenses = await UserDatabase().getCategoryExpenses(category);
    if (_expenses.isEmpty) {
      _showNoExpensesDialog(category);
    } else {
      _showExpensesDialog(category);
    }
  }

  void _showNoExpensesDialog(String category) {
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
  }

  void _showExpensesDialog(String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Expenses for $category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: _expenses.map((expense) => ListTile(
                title: Text('Amount: \$${expense['amount']}'),
                subtitle: Text('Date: ${expense['createdAt']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteExpense(expense['id'], category),
                ),
              )).toList(),
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

  void _deleteExpense(String expenseId, String category) async {
    await UserDatabase().deleteExpense(expenseId);
    // Optionally update the expenses list immediately after deletion
    _viewExpenses(category);
  }

  void _editCategoryBudget(String category, double currentBudget) async {
    final newBudget = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _controller = TextEditingController(text: currentBudget.toString());
        return AlertDialog(
          title: Text('Edit Budget for $category'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter new budget for $category'),
            controller: _controller,
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
            TextButton(
              onPressed: () {
                double? updatedBudget = double.tryParse(_controller.text);
                if (updatedBudget != null) {
                  Navigator.of(context).pop(updatedBudget);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newBudget != null && newBudget != currentBudget) {
      await UserDatabase().setCategoryBudget(category, newBudget);
      setState(() {
        _categoryBudgets[category] = newBudget;
      });
    }
  }

  void _showAddExpensePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: AddExpense(onUpdateBudgetPage: _fetchAndUpdateBudgets),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        );
      },
    );
  }
}
