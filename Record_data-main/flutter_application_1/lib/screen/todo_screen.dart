import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task/screen/signin_screen.dart';
import 'package:task/screen/transaction_screen.dart'; // หน้าบันทึกรายการ
import 'package:task/screen/transaction_list_screen.dart'; // หน้าดูรายการที่บันทึก

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  void logout() async {
    await FirebaseAuth.instance.signOut(); // ออกจากระบบ
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SigninScreen()), // กลับไปที่หน้าล็อกอิน
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("หน้าเมนูหลัก"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransactionScreen()), // บันทึกรายรับรายจ่าย
                );
              },
              child: const Text('บันทึกรายรับรายจ่าย'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransactionListScreen()), // ดูรายการรายรับรายจ่าย
                );
              },
              child: const Text('ดูรายการรายรับรายจ่าย'),
            ),
          ],
        ),
      ),
    );
  }
}
