import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';

class ExpenseGraph extends StatefulWidget {
  @override
  _ExpenseGraphState createState() => _ExpenseGraphState();
}

class _ExpenseGraphState extends State<ExpenseGraph> {
  final UserDatabase _userDatabase = UserDatabase();
  late double remainingBudget; // Declare remainingBudget as an instance variable

  @override
  void initState() {
    super.initState();
    calculateRemainingBudget();
  }

  void calculateRemainingBudget() async {
    // Get the budget and expenses
    double budget = await _userDatabase.getBudget() ?? 0.0;
    List<Map<String, dynamic>> expenses = await _userDatabase.getExMap() ?? [];

    // Calculate total expenses
    double totalExpense = 0.0;
    expenses.forEach((exp) {
      double amount = exp['amount']?.toDouble() ?? 0.0;
      totalExpense += amount;
    });

    // Calculate remaining budget
    setState(() {
      remainingBudget = budget - totalExpense;
    });
  }

  Color _getCategoryColor(String category) {
    // Define colors for different categories
    Map<String, Color> categoryColors = {
      'Transportation': Colors.red,
      'Food': Colors.blue,
      'Entertainment': Colors.green,
      'Utilities': Colors.yellow,
      // Add more categories and colors as needed
    };

    // Return color for the given category, or a default color if not found
    return categoryColors[category] ?? Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Graph'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>?>(
          future: _userDatabase.getExMap(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No expenses data available'),
              );
            } else {
              return ListView( // Wrap with ListView
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildPieChart(snapshot.data!),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: _buildLegend(snapshot.data!, remainingBudget),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

Widget _buildPieChart(List<Map<String, dynamic>> expenses) {
  return Container(
    constraints: BoxConstraints(maxHeight: 300), // Adjust maxHeight as needed
    child: FutureBuilder<double?>(
      future: _userDatabase.getBudget(),
      builder: (context, budgetSnapshot) {
        if (budgetSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (budgetSnapshot.hasError) {
          return Center(
            child: Text('Error retrieving budget: ${budgetSnapshot.error}'),
          );
        } else {
          final double budget = budgetSnapshot.data ?? 0.0;

          Map<String, double> categoryAmounts = {};
          double totalExpense = 0.0;
          expenses.forEach((exp) {
            final String category = exp['category'] ?? 'Unknown';
            final double amount = exp['amount']?.toDouble() ?? 0.0;
            categoryAmounts[category] =
                (categoryAmounts[category] ?? 0.0) + amount;
            totalExpense += amount;
          });

          // Calculate remaining budget
          double remainingBudget = budget - totalExpense;

          List<Color> colors = [
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.orange,
            Colors.purple,
          ];

          List<PieChartSectionData> pieData =
              categoryAmounts.entries.map((entry) {
            final String category = entry.key;
            final double amount = entry.value;
            final double percentage = (amount / budget) * 100.0;
            final Color color = colors[
                categoryAmounts.keys.toList().indexOf(category) %
                    colors.length];

            return PieChartSectionData(
              color: color,
              value: amount,
              title: '${percentage.toStringAsFixed(1)}%', // Include percentage text
              radius: 50,
              titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          }).toList();

          // Add section for unused budget
          if (remainingBudget > 0) {
            double percentageUnused = (remainingBudget / budget) * 100;
            pieData.add(
              PieChartSectionData(
                color: Colors.grey,
                value: remainingBudget,
                title: '${percentageUnused.toStringAsFixed(1)}%',
                radius: 50,
                titleStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          }

          // Now that we have both budget and expenses, we can build the pie chart
          return PieChart(
            PieChartData(
              sections: pieData,
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              centerSpaceColor: Colors.white,
            ),
          );
        }
      },
    ),
  );
}


Widget _buildLegend(
    List<Map<String, dynamic>> expenses, double remainingBudget) {
  List<Widget> legendItems = [];
  Set<String> categories =
      expenses.map((exp) => exp['category'] as String).toSet();
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  int index = 0;
  for (String category in categories) {
    legendItems.add(
      Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5),
          Text(category),
        ],
      ),
    );
    index++;
  }

  // Add legend item for unused budget
  if (remainingBudget > 0) {
    legendItems.add(
      Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5),
          Text('Unused Budget'),
        ],
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: legendItems,
  );
}
}