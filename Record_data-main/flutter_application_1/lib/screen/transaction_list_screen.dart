import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  Future<void> _calculateTotals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .doc(user.uid)
        .collection('user_transactions')
        .where('type', isEqualTo: 'รายรับ')
        .get();

    QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .doc(user.uid)
        .collection('user_transactions')
        .where('type', isEqualTo: 'รายจ่าย')
        .get();

    double incomeTotal = incomeSnapshot.docs.fold(
        0, (sum, doc) => sum + (doc['amount'] as double));
    double expenseTotal = expenseSnapshot.docs.fold(
        0, (sum, doc) => sum + (doc['amount'] as double));

    setState(() {
      totalIncome = incomeTotal;
      totalExpense = expenseTotal;
    });
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: Colors.green,
        value: totalIncome,
        title: 'รายรับ',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: totalExpense,
        title: 'รายจ่าย',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('กรุณาเข้าสู่ระบบ'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการรายรับรายจ่าย'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('transactions')
                  .doc(user.uid)
                  .collection('user_transactions')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var transactions = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    var transaction = transactions[index];
                    return ListTile(
                      title: Text('${transaction['amount']} บาท'),
                      subtitle: Text(
                          '${transaction['type']} - ${transaction['note']}'),
                      trailing: Text(DateFormat('dd/MM/yyyy').format(
                          (transaction['date'] as Timestamp).toDate())),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'ยอดรวมรายรับ-รายจ่าย',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('รายรับรวม: $totalIncome บาท'),
                Text('รายจ่ายรวม: $totalExpense บาท'),
                const SizedBox(height: 20),
                const Text(
                  'กราฟสัดส่วนรายรับ-รายจ่าย',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: showingSections(),
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
