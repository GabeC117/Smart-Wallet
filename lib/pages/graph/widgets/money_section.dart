import 'package:flutter/material.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/pages/budget.dart';

class moneySection extends StatelessWidget {
  const moneySection({
    Key? key,
    required this.totalAmountSpent,
    required double totalBudget,
  })  : _totalBudget = totalBudget,
        super(key: key);

  final double totalAmountSpent;
  final double _totalBudget;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: SW_Sizes.defaultSpace / 2),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
           InkWell(
            onTap: () {
              // Replace 'Budget()' with the actual route you want to navigate to
              Navigator.push(context, MaterialPageRoute(builder: (context) => Budget()));
            },
            child:
          Column(
            children: [
              Text(
                'Budget:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: SW_Sizes.defaultSpace / 2),
              Text(
                '\$ ${_totalBudget.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  color: SW_Colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),),
          Column(
            children: [
              Text(
                'Spent:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: SW_Sizes.defaultSpace / 2),
              Text(
                '\$ ${totalAmountSpent.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  color: _totalBudget - totalAmountSpent > 0 ? SW_Colors.primary : SW_Colors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 50),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'Remaining Budget:',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                //style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: SW_Sizes.defaultSpace / 2),
              Text(
                '\$ ${(_totalBudget - totalAmountSpent).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 30,
                  color: _totalBudget - totalAmountSpent > 0 ? SW_Colors.primary : SW_Colors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      )
    ]);
  }
}
