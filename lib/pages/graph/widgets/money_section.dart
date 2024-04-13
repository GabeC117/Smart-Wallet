import 'package:flutter/material.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              'Spent:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: SW_Sizes.defaultSpace / 2),
            Text(
              '\$ ${totalAmountSpent.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                color: SW_Colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        //SizedBox(width: SW_Sizes.s),
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
        ),
      ],
    );
  }
}
