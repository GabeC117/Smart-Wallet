import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:smart_wallet/classes/firebase_classes.dart';
import 'package:smart_wallet/pages/graph/widgets/money_section.dart';
import 'package:smart_wallet/pages/graph/widgets/pie_chart.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';

class ExpenseGraph extends StatefulWidget {
  @override
  _ExpenseGraphState createState() => _ExpenseGraphState();
}

class _ExpenseGraphState extends State<ExpenseGraph> {
  final UserDatabase _userDatabase = UserDatabase();
  String _selectedCategory = 'All';
  final Map<String, Color> _categoryColors = {
    'Food': Color.fromARGB(255, 255, 186, 59),
    'Transportation': Color.fromARGB(255, 248, 130, 169),
    'Utilities': Color.fromARGB(255, 255, 102, 102),
    'Other': Color.fromARGB(255, 126, 235, 124),
    'Entertainment': Color.fromARGB(255, 0, 195, 255),
  };
  double _totalBudget = 0.0;
  double _totalAmountSpent = 0.0;
  double _remainingBudget = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchBudgetAndExpenses();
  }

  Future<void> _fetchBudgetAndExpenses() async {
    double? budget = await _userDatabase.getBudgets();
    if (budget != null) {
      setState(() {
        _totalBudget = budget;
      });
    }

    List<Map<String, dynamic>>? expenses = await _userDatabase.getExMap();
    if (expenses != null) {
      double totalSpent =
          expenses.fold(0.0, (sum, item) => sum + (item['amount'] as double));
      setState(() {
        _totalAmountSpent = totalSpent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = SW_Helpers.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Expense Chart'),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: FutureBuilder<List<Map<String, dynamic>>?>(
          future: _userDatabase.getExMap(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> expenses = snapshot.data!;

              if (_selectedCategory != 'All') {
                expenses = expenses
                    .where(
                        (expense) => expense['category'] == _selectedCategory)
                    .toList();
              }

              double totalAmountSpent = _selectedCategory == 'All'
                  ? expenses.fold(
                      0, (sum, item) => sum + (item['amount'] as double))
                  : expenses.fold(0, (sum, item) {
                      if (item['category'] != 'Remaining') {
                        return sum + (item['amount'] as double);
                      } else {
                        return sum;
                      }
                    });

              double remainingBudget = max(0, _totalBudget - totalAmountSpent);

              double categoryAmount = expenses.fold(
                  0, (sum, item) => sum + (item['amount'] as double));
              double percentageUsed = (_totalBudget == 0)
                  ? 0
                  : (categoryAmount / _totalBudget) * 100;

              Map<String, double> categoryAmountMap = {};
              expenses.forEach((expense) {
                String category = expense['category'] as String;
                double amount = expense['amount'] as double;
                categoryAmountMap.update(category, (value) => value + amount,
                    ifAbsent: () => amount);
                double categoryPercentage =
                    (percentageUsed == 0) ? 0 : (amount / _totalBudget) * 100;
              });

              List<PieChartSectionData> pieChartData =
                  categoryAmountMap.entries.map((entry) {
                return PieChartSectionData(
                  color: _categoryColors[entry.key]!,
                  value: entry.value,
                  title: "",
                );
              }).toList();

              pieChartData.add(PieChartSectionData(
                color: Color.fromARGB(127, 189, 189, 189),
                value: remainingBudget,
                title: '',
              ));

              // Generate smaller pie charts for each section
              List<Widget> smallerPieCharts =
                  categoryAmountMap.entries.map((entry) {
                double sectionValue = entry.value;
                double remainingBudget = _totalBudget - sectionValue;
                double categoryPercentage = (_totalBudget == 0)
                    ? 0
                    : (sectionValue / _totalBudget) * 100;

                List<PieChartSectionData> sectionData = [
                  PieChartSectionData(
                    color: _categoryColors[entry.key]!,
                    value: sectionValue > _totalBudget ? _totalBudget : sectionValue,
                    title: "",
                  ),
                  PieChartSectionData(
                    color: Color.fromARGB(0, 189, 189, 189),
                    value: remainingBudget < 0 ? 0 : remainingBudget,
                    title: '',
                  ),
                ];

                return Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 180,
                          height: 120,
                          alignment: Alignment.centerRight,
                          child: Stack(
                            children: [
                              PieChart(
                                PieChartData(
                                  sections: sectionData,
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: SW_Sizes.spaceBtwSections / 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildLegendItem(
                                entry.key, _categoryColors[entry.key]!),
                          ],
                        ),
                        const SizedBox(height: SW_Sizes.spaceBtwSections / 2),
                        Row(
                          children: [
                            Text(
                              '${(categoryPercentage).toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 14,
                                color: categoryPercentage < 100 ? SW_Colors.primary : SW_Colors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }).toList();

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(SW_Sizes.defaultSpace),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Money
                      moneySection(
                          totalAmountSpent: totalAmountSpent,
                          totalBudget: _totalBudget),

                      const SizedBox(height: SW_Sizes.spaceBtwSections),

                      // Budget Text
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Budget so far:',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                          ],
                        ),
                      ),

                      // Pie Chart
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: PieChartGraph(
                              size: 30.0,
                              section: pieChartData,
                            ),
                          ),
                          const SizedBox(width: SW_Sizes.spaceBtwItems),
                          Expanded(
                            flex: 7,
                            child: Wrap(
                              direction: Axis.vertical,
                              spacing: 10.0,
                              runSpacing: 4.0,
                              children: categoryAmountMap.entries.map((entry) {
                                return _buildLegendItem(
                                  entry.key,
                                  _categoryColors[entry.key]!,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),

                      //const SizedBox(height: SW_Sizes.spaceBtwSections),

                      // Mini graphs
                      Row(
                        children: [
                          //const SizedBox(height: SW_Sizes.spaceBtwSections),
                          Text(
                            'Percentage of Budget Used: ',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            '${percentageUsed.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 18,
                              color: _totalBudget - totalAmountSpent > 0
                                  ? SW_Colors.primary
                                  : SW_Colors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SW_Sizes.spaceBtwSections),
                      // Display smaller pie charts
                      Column(
                        children: smallerPieCharts,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('No expenses found.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        SizedBox(width: 4),
        Text(title),
      ],
    );
  }
}
