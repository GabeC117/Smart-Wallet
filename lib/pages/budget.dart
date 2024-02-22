import 'package:flutter/material.dart';
import 'package:smart_wallet/pages/add_expense.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';

class Budget extends StatefulWidget {
  @override
  _BudgetPage createState() => _BudgetPage();
}

Future<double?> getBudget() async {
  UserDatabase userDatabase = UserDatabase();
  return await userDatabase.getBudget();
}

Future<void> setBudget(double n) async {
  UserDatabase userDatabase = UserDatabase();
  await userDatabase.setBudget(n);
}

Future<double?> getExAmount() async {
  UserDatabase userDatabase = UserDatabase();
  return await userDatabase.getExAmount();
}

Future<List<Map<String, dynamic>>?> getExMap() async {
  UserDatabase userDatabase = UserDatabase();
  return await userDatabase.getExMap();
}

Future<void> deleteExpense(String expenseId) async {
  UserDatabase userDatabase = UserDatabase();
  await userDatabase.deleteExpense(expenseId);
}

class _BudgetPage extends State<Budget> {
  final TextEditingController _budgetController = TextEditingController();
  double _budget = 0.0;
  double _expenses = 0.0;
  List<Map<String, dynamic>> _expensesList = [];

  @override
  void initState() {
    super.initState();
    // Fetch the budget when the widget is initialized
    _fetchBudget();
    _fetchExAmount();
    _fetchExMap();
  }

  void updateBudgetPage() {
    // Fetch updated budget, expenses, etc.
    _fetchBudget();
    _fetchExAmount();
    _fetchExMap();
  }

  Future<void> _fetchBudget() async {
    double? budget = await getBudget();
    if (budget != null) {
      setState(() {
        _budget = budget;
        _budgetController.text = _budget.toString();
      });
    }
  }

  Future<void> _fetchExAmount() async {
    double? amount = await getExAmount();
    if (amount != null) {
      setState(() {
        _expenses = amount;
      });
    }
  }

  Future<void> _fetchExMap() async {
    List<Map<String, dynamic>>? map = await getExMap();
    if (map != null) {
      setState(() {
        _expensesList = map;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter your budget',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _setBudget();
              },
              child: Text('Set Budget'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddExpense(
                      onUpdateBudgetPage: () {
                        // Call the update function when the AddExpense page is popped
                        setState(() {
                          // Update the budget page
                          _fetchBudget();
                          _fetchExAmount();
                          _fetchExMap();
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text('Go to Add Expense'),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _expensesList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text("${_expensesList[index]['category']}"),
                    subtitle: Text("\$${_expensesList[index]['amount'].toStringAsFixed(2)}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        String customId = _expensesList[index]['id']; // Retrieve the custom ID
                        try {
                          await deleteExpense(customId); // Delete the expense using the custom ID
                          setState(() {
                            _expenses -= _expensesList[index]['amount'];
                            _expensesList.removeAt(index);
                          });
                        } catch (e) {
                          // Handle error if deletion fails
                          print('Error deleting expense: $e');
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Total Expenses: \$${_expenses.toStringAsFixed(2)}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Remaining Budget: \$${(_budget - _expenses).toStringAsFixed(2)}'),
            ),
          ],
        ),
      ),
    );
  }

  void _setBudget() {
    final double budget = double.tryParse(_budgetController.text) ?? 0.0;
    setState(() {
      _budget = budget;
      setBudget(_budget); // Update the budget in the database
    });
  }
}
