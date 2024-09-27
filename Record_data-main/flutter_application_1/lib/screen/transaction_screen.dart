import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _type = 'รายรับ'; // ค่าเริ่มต้นของประเภท
  DateTime _selectedDate = DateTime.now(); // วันที่ปัจจุบัน

  void _submitTransaction() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('transactions')
        .doc(user.uid)
        .collection('user_transactions')
        .add({
      'amount': double.parse(_amountController.text),
      'type': _type,
      'note': _noteController.text,
      'date': _selectedDate,
    });

    // ล้างข้อมูลในฟอร์ม
    _amountController.clear();
    _noteController.clear();
    setState(() {
      _type = 'รายรับ';
      _selectedDate = DateTime.now();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('บันทึกรายรับรายจ่าย'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'จำนวนเงิน'),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _type,
              onChanged: (String? newValue) {
                setState(() {
                  _type = newValue!;
                });
              },
              items: <String>['รายรับ', 'รายจ่าย']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'โน้ต'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'วันที่: ${_selectedDate.toLocal()}'.split(' ')[0],
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTransaction,
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}
