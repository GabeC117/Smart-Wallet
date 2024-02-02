import 'package:flutter/material.dart';
import 'package:smart_wallet/main.dart';
import 'package:smart_wallet/pages/account.dart';
import 'package:smart_wallet/pages/budget.dart';
import 'package:smart_wallet/pages/graph.dart';
import 'package:smart_wallet/pages/receipt.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade300,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open drawer on button press
              },
            );
          },
        ),
        title: Text('Smart Wallet'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(
              'Test:Back to Sign in',
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
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              title: Text('Budget'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Budget()),
                  );
              },
            ),
            // Add more list tiles for additional menu items if needed
          ],
        ),
      ),
      body: Container(
        color: Colors.purple.shade100,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Welcome to your Smart Wallet!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Budget()),
                            );
                          },
                          child: Text('Budget'),
                        )
                      ]),
                ],
              ),
            ),
            Container(
              color: Colors.purple.shade300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Budget()),
                            );
                            },
                      icon: Icon(Icons.attach_money, color: Colors.white)),
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Receipts()),
                            );
                      },
                      icon: Icon(Icons.camera_enhance, color: Colors.white)),
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Graphs()),
                            );
                      },
                      icon: Icon(Icons.trending_up, color: Colors.white)),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.help_center_outlined)),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.help_center_outlined)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}