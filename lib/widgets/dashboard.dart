import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final double totalAmount;
  final double paidAmount;
  final double leftAmount;

  const Dashboard({
    Key? key,
    required this.totalAmount,
    required this.paidAmount,
    required this.leftAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(5.0),
      elevation: 2,
      // decoration: BoxDecoration(
      //     color: const Color.fromARGB(255, 247, 240, 247),
      //     borderRadius: BorderRadius.circular(8.0),
      //     boxShadow: const [
      //       BoxShadow(
      //         color: Color.fromARGB(255, 210, 210, 210),
      //         blurRadius: 15.0,
      //       ),
      //     ]),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDashboardItem('Total Amount', totalAmount, Colors.blue),
            _buildDashboardItem('Paid Amount', paidAmount, Colors.green),
            _buildDashboardItem('Left Amount', leftAmount, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20.0,
            color: color,
          ),
        ),
      ],
    );
  }
}
