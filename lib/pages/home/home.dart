import 'package:flutter/material.dart';
import 'package:smart_wallet/pages/home/widgets/drawer.dart';
import 'package:smart_wallet/pages/budget.dart';
import 'package:smart_wallet/pages/receipt.dart';
import 'package:smart_wallet/pages/graph/graph.dart'; // Import the ExpenseGraph page
import 'package:smart_wallet/classes/firebase_classes.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the necessary chart library
import 'package:smart_wallet/pages/home/widgets/navigation_bar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> _usernameFuture;
  late Future<double?> _budgetFuture;
  late Future<List<Map<String, dynamic>>?> _recentExpensesFuture;
  double _remainingBudget = 0.0;
  final UserDatabase _userDatabase = UserDatabase();
  late double remainingBudget = 0.0;
  List<Map<String, dynamic>>? _expenses;
  //final double budget = budgetSnapshot.data ?? 0.0;

  @override
  void initState() {
    super.initState();
    _usernameFuture = UserDatabase().getUsername();
    _fetchData(); // Fetch initial data
  }

  void _fetchData() {
    setState(() {
      _budgetFuture = UserDatabase().getBudgets();
      _recentExpensesFuture = UserDatabase().getRecentExpenses();
    });

    // Calculate remaining budget once futures are resolved
    Future.wait([_budgetFuture, _recentExpensesFuture]).then((values) {
      double budget = values[0] as double? ?? 0.0;
      double expenses = (values[1] as List<Map<String, dynamic>>?)
              ?.fold<double>(
                  0.0,
                  (sum, expense) =>
                      sum + (expense['amount'] as double? ?? 0.0)) ??
          0.0;

      setState(() {
        _remainingBudget = budget - expenses;
      });
    });
  }

  void refreshData() {
    // Call _fetchData to refresh the data
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Wallet'),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: navigationBar(refreshData),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<String?>(
                future: _usernameFuture,
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ListView(
                        padding: EdgeInsets.all(10), // Adjust padding here
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Welcome to your Smart Wallet, ${snapshot.data}!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FutureBuilder<double?>(
                            future: _budgetFuture,
                            builder: (BuildContext context,
                                AsyncSnapshot<double?> budgetSnapshot) {
                              if (budgetSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                if (budgetSnapshot.hasError) {
                                  return Text('Error fetching budget');
                                } else {
                                  if (budgetSnapshot.data == null) {
                                    return Text(
                                      'Budget not set',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.red,
                                      ),
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            'Current Budget: \$${budgetSnapshot.data}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Remaining Budget: \$$_remainingBudget',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }
                              }
                            },
                          ),
                          FutureBuilder<List<Map<String, dynamic>>?>(
                            future: _recentExpensesFuture,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Map<String, dynamic>>?>
                                    expensesSnapshot) {
                              if (expensesSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                if (expensesSnapshot.hasError) {
                                  return Text('Error fetching expenses');
                                } else {
                                  _expenses = expensesSnapshot.data;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ExpenseGraph()),
                                      );
                                    },
                                    child: _buildPieChartWidget(),
                                  );
                                }
                              }
                            },
                          ),
                          FutureBuilder<List<Map<String, dynamic>>?>(
                            future: _recentExpensesFuture,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Map<String, dynamic>>?>
                                    expensesSnapshot) {
                              if (expensesSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                if (expensesSnapshot.hasError) {
                                  return Text('Error fetching expenses');
                                } else {
                                  _expenses = expensesSnapshot.data;
                                  return _buildLegend(
                                      _expenses ?? [], _remainingBudget);
                                }
                              }
                            },
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartWidget() {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: _userDatabase.getExMap(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>?> expensesSnapshot) {
        if (expensesSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (expensesSnapshot.hasError) {
            return Text('Error fetching expenses');
          } else {
            if (expensesSnapshot.data != null &&
                expensesSnapshot.data!.isNotEmpty) {
              return _buildPieChart(expensesSnapshot.data!);
            } else {
              return Text(
                'No expenses available',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            }
          }
        }
      },
    );
  }

  Widget _buildPieChart(List<Map<String, dynamic>> expenses) {
    return Container(
      constraints: BoxConstraints(maxHeight: 300),
      child: FutureBuilder<double?>(
        future: _userDatabase.getBudgets(),
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
                title: '${percentage.toStringAsFixed(1)}%',
                radius: 50,
                titleStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            }).toList();

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
                  ),
                ),
              );
            }

            return PieChart(
              PieChartData(
                sections: pieData,
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Most Recent Expenses:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: legendItems,
          ),
        ),
      ],
    );
  }
}
