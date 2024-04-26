import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_wallet/pages/budget.dart';
import 'package:smart_wallet/pages/receipt.dart';
import 'package:smart_wallet/pages/graph/graph.dart'; // Import the ExpenseGraph page
import 'package:smart_wallet/classes/firebase_classes.dart';
import 'package:smart_wallet/utils/constants/colors.dart';

class navigationBar extends StatefulWidget {
  final Function() refreshDataCallback;

  navigationBar(this.refreshDataCallback);

  @override
  _navigationBarState createState() => _navigationBarState();
}

class _navigationBarState extends State<navigationBar> {
  late Future<double?> _budgetFuture;
  late Future<List<Map<String, dynamic>>?> _recentExpensesFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      setState(() {
        _budgetFuture = UserDatabase().getBudgets();
        _recentExpensesFuture = UserDatabase().getRecentExpenses();
      });
    } catch (e) {
      // Handle errors here (e.g., print error message, show a snackbar)
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      decoration: const BoxDecoration(
        //borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [SW_Colors.primary, Colors.purple.shade600],
        // ),
        color: SW_Colors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            iconSize: 40,
            onPressed: () => Get.to(() => Budget(),)?.then((value) {
              widget.refreshDataCallback();
            }),
            icon: const Icon(Icons.attach_money), 
          ),
          IconButton(
            iconSize: 40,
            onPressed: () => Get.to(() => PicturePage(),),
            icon: const Icon(Icons.camera_enhance),
          ),
          IconButton(
            iconSize: 40,
            onPressed: () => Get.to(() => ExpenseGraph(),),
            icon: const Icon(Icons.trending_up),
          ),
        ],
      ),
    );
  }
}
