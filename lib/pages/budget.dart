import 'package:flutter/material.dart';
import 'package:smart_wallet/pages/add_expense.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';
import 'package:intl/intl.dart';

class Budget extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<Budget> {
  final Map<String, double> _categoryBudgets = {};
  List<Map<String, dynamic>> _expenses = [];

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
    _fetchAndUpdateBudgets();
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
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
                        onPressed: () =>
                            _editCategoryBudget(entry.key, entry.value),
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

  void _viewExpenses(String category) async {
    try {
      _expenses = await UserDatabase()
          .getCategoryExpenses(category); // Store fetched expenses
      print('Expenses fetched: $_expenses'); // Add this line to print expenses
      if (_expenses.isEmpty) {
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
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Expenses for $category'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: _expenses
                        .map((expense) => ListTile(
                              title: Text('Amount: \$${expense['amount']}'),
                              subtitle: Text('Date: ${(expense['createdAt'])}'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteExpense(expense['id'], category);
                                  setState(() {
                                    _expenses.remove(expense);
                                  });
                                },
                              ),
                            ))
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
        },
      );
    } catch (e) {
      print('Error fetching expenses: $e');
      // Handle error
    }
  }

  void _deleteExpense(String expenseId, String category) async {
    try {
      await UserDatabase().deleteExpense(expenseId);
      print('Expense deleted successfully');
    } catch (e) {
      print('Error deleting expense: $e');
      // Handle error
    }
  }

  void _showAddExpensePopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: AddExpense(onUpdateBudgetPage: _fetchAndUpdateBudgets),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          );
        });
  }

  void _fetchAndUpdateBudgets() async {
    try {
      // Fetch budget for each category
      for (String category in _budgetCategories) {
        double? categoryBudget =
            await UserDatabase().getCategoryBudget(category);
        if (categoryBudget != null) {
          setState(() {
            _categoryBudgets[category] = categoryBudget;
          });
        }
      }
    } catch (e) {
      print('Error fetching budgets: $e');
    }
  }

  void _editCategoryBudget(String category, double currentBudget) async {
    final newBudget = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        double? updatedBudget = currentBudget;
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
                updatedBudget = double.parse(value);
              } catch (e) {
                // Handle parse error
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
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

    if (newBudget != null) {
      try {
        await UserDatabase().setCategoryBudget(category, newBudget);
        setState(() {
          _categoryBudgets[category] = newBudget;
        });
        print('Budget updated successfully');
      } catch (e) {
        print('Error updating budget: $e');
      }
    }
  }
}
