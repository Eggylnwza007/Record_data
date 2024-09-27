import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  Future<Map<DateTime, double>> getTransactionsForLastTwoMonths() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    DateTime now = DateTime.now();
    DateTime twoMonthsAgo = DateTime(now.year, now.month - 2, now.day);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .where('date', isGreaterThan: twoMonthsAgo)
        .get();

    Map<DateTime, double> data = {};
    for (var doc in snapshot.docs) {
      DateTime date = (doc['date'] as Timestamp).toDate();
      double amount = doc['amount'];
      data[date] = (data[date] ?? 0) + amount;
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('กราฟรายรับรายจ่าย'),
      ),
      body: FutureBuilder<Map<DateTime, double>>(
        future: getTransactionsForLastTwoMonths(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<DateTime, double> data = snapshot.data!;
          List<FlSpot> spots = data.entries.map((entry) {
            return FlSpot(
              entry.key.day.toDouble(),
              entry.value,
            );
          }).toList();

          return LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
