import 'package:flutter/material.dart';
import 'package:smart_wallet/pages/add_expense.dart'; 

class Budget extends StatefulWidget {
  @override
  _BudgetPage createState() => _BudgetPage();
}

class _BudgetPage extends State<Budget> {
  final TextEditingController _budgetController = TextEditingController();
  double _budget = 0.0;
  double _expenses = 0.0;
  List<Map<String, dynamic>> _expensesList = [];

  void _setBudget() {
    final double budget = double.tryParse(_budgetController.text) ?? 0.0;
    setState(() {
      _budget = budget;
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
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddExpense(
                      onExpenseAdded: (double amount, String category) {
                        setState(() {
                          _expenses += amount; 
                          _expensesList.add({'amount': amount, 'category': category});
                        });
                      },
                    ),
                  ),
                );
              },
              child: Text('Go to Add Expense'),
            ),
            ListView.builder(
              shrinkWrap: true, 
              physics: NeverScrollableScrollPhysics(), 
              itemCount: _expensesList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0), 
                  elevation: 4.0, 
                  child: ListTile(
                    title: Text("${_expensesList[index]['category']}"),
                    subtitle: Text("\$${_expensesList[index]['amount'].toStringAsFixed(2)}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _expenses -= _expensesList[index]['amount']; 
                          _expensesList.removeAt(index); 
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Total Expenses: \$${_expenses.toStringAsFixed(2)}'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Remaining Budget: \$${(_budget - _expenses).toStringAsFixed(2)}'),
            ),
          ],
        ),
      ),
    );
  }
}
