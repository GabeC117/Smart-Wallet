import 'package:flutter/material.dart';
import 'package:smart_wallet/components/drawer.dart';
import 'package:smart_wallet/main.dart';
import 'package:smart_wallet/pages/account.dart';
import 'package:smart_wallet/pages/budget.dart';
import 'package:smart_wallet/pages/graph.dart';
import 'package:smart_wallet/pages/receipt.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> _usernameFuture;
  late Future<double?> _budgetFuture;
  late Future<List<Map<String, dynamic>>?> _recentExpensesFuture;

  @override
  void initState() {
    super.initState();
    _usernameFuture = UserDatabase().getUsername();
    _fetchData(); // Fetch initial data
  }

  void _fetchData() {
    setState(() {
      _budgetFuture = UserDatabase().getBudget();
      _recentExpensesFuture = UserDatabase().getRecentExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade300,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Open drawer on button press
              },
            );
          },
        ),

        title: const Text('Smart Wallet'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: const Text(
              'Test: Back to Sign in',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple.shade300,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              title: const Text('Budget'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Budget()),
                ).then((value) => _fetchData());
              },
            ),
            // Add more list tiles for additional menu items if needed
          ],
        ),

      ),
      //drawer: MyDrawer(),
      body: Container(
        color: Colors.purple.shade100,
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<String?>(
                future: _usernameFuture,
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show loading indicator while fetching username
                  } else {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ListView(
                        children: <Widget>[
                          ListTile(
                            key: const Key('welcome-sw'),
                            title: Text(
                              'Welcome to your Smart Wallet! ${snapshot.data}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Add other widgets as needed

                          FutureBuilder<double?>(
                            future: _budgetFuture,
                            builder: (BuildContext context, AsyncSnapshot<double?> budgetSnapshot) {
                              if (budgetSnapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator(); // Show loading indicator while fetching budget
                              } else {
                                if (budgetSnapshot.hasError) {
                                  return const Text('Error fetching budget');
                                } else {
                                  if (budgetSnapshot.data == null) {
                                    return const Text('Budget not set'); // Display message when budget document does not exist
                                  } else {
                                    return ListTile(
                                      title: Text(
                                        'Current Budget: \$${budgetSnapshot.data}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                          ),
                          FutureBuilder<List<Map<String, dynamic>>?>(
                            future: _recentExpensesFuture,
                            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>?> expensesSnapshot) {
                              if (expensesSnapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator(); // Show loading indicator while fetching recent expenses
                              } else {
                                if (expensesSnapshot.hasError) {
                                  return const Text('Error fetching recent expenses');
                                } else {
                                  if (expensesSnapshot.data != null && expensesSnapshot.data!.isNotEmpty) {
                                    return Column(
                                      children: [
                                        const Text(
                                          'Recent Expenses:',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: expensesSnapshot.data!.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return ListTile(
                                              title: Text(
                                                'Amount: \$${expensesSnapshot.data![index]['amount']}, Category: ${expensesSnapshot.data![index]['category']}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const Text(
                                      'No recent expenses available',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
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
            Container(
              color: Colors.purple.shade300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Budget()),
                      ).then((value) => _fetchData());
                    },
                    icon: const Icon(Icons.attach_money, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Receipts()),
                      );
                    },
                    icon: const Icon(Icons.camera_enhance, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Graphs()),
                      );
                    },
                    icon: const Icon(Icons.trending_up, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.help_center_outlined),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.help_center_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
