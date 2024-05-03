import 'package:flutter/material.dart';
import 'package:smart_wallet/pages/home/widgets/drawer.dart';
import 'package:smart_wallet/pages/home/widgets/navigation_bar.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_wallet/pages/home/colors.dart';
import 'package:smart_wallet/pages/graph/widgets/ExpenseGraphWidget.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/pages/account/account.dart';
import 'package:get/get.dart';
import 'package:smart_wallet/pages/graph/graph.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> _usernameFuture;
  late Future<double?> _budgetFuture;
  late Future<List<Map<String, dynamic>>?> _expensesFuture;
  double _remainingBudget = 0.0;
  Map<String, double> categoryAmounts = {};

  @override
  void initState() {
    super.initState();
    _usernameFuture = UserDatabase().getUsername();
    _fetchData();
  }

  void _fetchData() {
    _budgetFuture = UserDatabase().getBudgets().then((value) => value ?? 0.0);
    _expensesFuture = UserDatabase().getExMap();

    // Calculate remaining budget once futures are resolved
    Future.wait([_budgetFuture, _expensesFuture]).then((values) {
      double budget = values[0] as double? ?? 0.0;
      List<Map<String, dynamic>> expenses =
          values[1] as List<Map<String, dynamic>>;
      double totalExpenses = 0.0;

      categoryAmounts.clear();
      for (var expense in expenses) {
        double amount = expense['amount'] as double? ?? 0.0;
        String category = expense['category'] as String? ?? 'Unknown';
        totalExpenses += amount;
        if (categoryAmounts.containsKey(category)) {
          categoryAmounts[category] = categoryAmounts[category]! + amount;
        } else {
          categoryAmounts[category] = amount;
        }
      }

      setState(() {
        _remainingBudget = budget - totalExpenses;
      });
    });
  }

  void refreshData() {
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (actions: <Widget>[
          IconButton(
            color: Colors.black,
            iconSize: 35,
            onPressed: () => Get.to(() => Account(),), // Ensure PicturePage is a defined widget
            icon: const Icon(Icons.person),
          ),
        ],
        ),//title: const Text('Smart Wallet')),
      drawer: const MyDrawer(),
      bottomNavigationBar:
          navigationBar(refreshData),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<String?>(
              future: _usernameFuture,
              builder: (context, snapshot) => _buildUsernameWelcome(snapshot),
            ),
            FutureBuilder<double?>(
              future: _budgetFuture,
              builder: (BuildContext context, AsyncSnapshot<double?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error fetching budget');
                } else if (snapshot.data == null) {
                  return Text(
                      'Budget not set');
                } else {
                  double budget = snapshot.data!;
                  
                  return InkWell(
                    onTap: () {
                      Get.to(() => ExpenseGraph());
                    },
                    child: ExpenseGraphWidget(
                      categoryColors: categoryColors,
                      categoryAmountMap: categoryAmounts,
                      totalBudget: budget,
                    ),
                  );
                }
              },
            ),
            //_buildExpensesSection(),
            // Add the ExpenseGraph here to display it on the home page
            //ExpenseGraph(), // Ensure that the ExpenseGraph class is designed to be embedded like this
            //Text('Remaining Budget: \$${_remainingBudget.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameWelcome(AsyncSnapshot<String?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(SW_Sizes.defaultSpace, 5, SW_Sizes.defaultSpace, SW_Sizes.defaultSpace),
        child: Text(
          'Welcome to your SmartWallet, ${snapshot.data}!',
          style: TextStyle(fontSize: 30.0, color: SW_Colors.primary, fontWeight: FontWeight.w900),
        ),
      );
    }
  }
}
