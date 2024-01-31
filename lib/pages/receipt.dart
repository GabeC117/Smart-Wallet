import 'package:flutter/material.dart';

class Receipts extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text('Uploaded Receipts'),
              centerTitle: true,
            ),
      );
  }
}


/*
use following code on a button to get to this page.


onPressed: () {
  Navigator.push(context,
  MaterialPageRoute(builder: (context) => Receipts()));
}, 

*/
