import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';

class ExpenseGraph extends StatefulWidget {
  @override
  _ExpenseGraphState createState() => _ExpenseGraphState();
}

class _ExpenseGraphState extends State<ExpenseGraph> {
  final UserDatabase _userDatabase = UserDatabase();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: _userDatabase.getExMap(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No expenses data available');
        } else {
          return _buildPieChart(snapshot.data!);
        }
      },
    );
  }

  Widget _buildPieChart(List<Map<String, dynamic>> expenses) {
    return FutureBuilder<double?>(
      future: _userDatabase.getBudget(),
      builder: (context, budgetSnapshot) {
        if (budgetSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (budgetSnapshot.hasError) {
          return Text('Error retrieving budget: ${budgetSnapshot.error}');
        } else {
          // Retrieve the budget value from the snapshot data
          final double budget = budgetSnapshot.data ?? 0.0;
          
          // Aggregate amounts for each category
          Map<String, double> categoryAmounts = {};
          expenses.forEach((exp) {
            final String category = exp['category'] ?? 'Unknown';
            final double amount = exp['amount']?.toDouble() ?? 0.0;
            categoryAmounts[category] = (categoryAmounts[category] ?? 0.0) + amount;
          });

          List<Color> colors = [
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.orange,
            Colors.purple,
            // Add more colors as needed
          ];

          List<PieChartSectionData> pieData = categoryAmounts.entries.map((entry) {
            final String category = entry.key;
            final double amount = entry.value;
            final double percentage = (amount / budget) * 100.0; // Calculate percentage of expenses compared to budget
            final Color color = colors[categoryAmounts.keys.toList().indexOf(category) % colors.length];

            return PieChartSectionData(
              color: color,
              value: amount,
              title: '$category\n${percentage.toStringAsFixed(1)}%', // Display category and percentage compared to budget
              radius: 50,
              titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList();

          return AspectRatio(
            aspectRatio: 1.0,
            child: PieChart(
              PieChartData(
                sections: pieData,
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                centerSpaceColor: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}