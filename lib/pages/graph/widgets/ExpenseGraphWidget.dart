import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:smart_wallet/pages/graph/widgets/money_section.dart';
import 'package:smart_wallet/pages/graph/widgets/pie_chart.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';

class ExpenseGraphWidget extends StatelessWidget {
  final double totalBudget;
  final Map<String, double> categoryAmountMap;
  final Map<String, Color> categoryColors;

  const ExpenseGraphWidget({
    required this.totalBudget,
    required this.categoryAmountMap,
    required this.categoryColors,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total amount spent
    double totalAmountSpent = categoryAmountMap.values.fold(0.0, (sum, amount) => sum + amount);
    
    // Calculate remaining budget
    double remainingBudget = max(0, totalBudget - totalAmountSpent);

    // Generate pie chart data
    List<PieChartSectionData> pieChartData = categoryAmountMap.entries.map((entry) {
      return PieChartSectionData(
        color: categoryColors[entry.key]!,
        value: entry.value,
        title: "",
      );
    }).toList();

    // Add remaining budget to pie chart
    pieChartData.add(PieChartSectionData(
      color: Color.fromARGB(255, 189, 189, 189),
      value: remainingBudget,
      title: '',
    ));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(SW_Sizes.defaultSpace, 0, SW_Sizes.defaultSpace, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Money
            moneySection(totalAmountSpent: totalAmountSpent, totalBudget: totalBudget),

            //const SizedBox(height: SW_Sizes.spaceBtwSections),

            // Budget Text
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, SW_Sizes.defaultSpace, 8.0, 8.0),
              child: Row(
                children: [
                  Text('Budget so far:', style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
            ),

            // Pie Chart
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: PieChartGraph(size: 30.0, section: pieChartData),
                ),
                const SizedBox(width: SW_Sizes.spaceBtwItems),
                Expanded(
                  flex: 7,
                  child: Wrap(
                    direction: Axis.vertical,
                    spacing: 10.0,
                    runSpacing: 4.0,
                    children: categoryAmountMap.entries.map((entry) {
                      return _buildLegendItem(entry.key, categoryColors[entry.key]!);
                    }).toList(),
                  ),
                ),
              ],
            ),

            // Mini graphs
            Row(
              children: [
                Text(
                  'Percentage of Budget Used: ',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '${((totalAmountSpent / totalBudget) * 100).toStringAsFixed(2)}%',
                  style: const TextStyle(
                    fontSize: 18,
                    color: SW_Colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
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
